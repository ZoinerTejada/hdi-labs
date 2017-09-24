Param(
    [string] [Parameter(Mandatory=$true)] $subscriptionId,
    [string] [Parameter(Mandatory=$true)] $resourceGroupName,
    [string] [Parameter(Mandatory=$true)] $clusterName,
    [string] [Parameter(Mandatory=$true)] $numInstances,
    [string] $resourceGroupLocation = 'westus2'
)

# Example syntax
# ./Deploy-Multiple -subscriptionId 'e223f1b3-d19b-4cfa-98e9-bc9be62717bc' -resourceGroupName 'HDInsightLabsEnvironmentZ' -resourceGroupLocation 'westus2' -clusterName 'hdilabs' -numInstances 2

#$subscriptionId = 'e223f1b3-d19b-4cfa-98e9-bc9be62717bc'
#$resourceGroupName = 'HDInsightLabsEnvironmentZ'
#$resourceGroupLocation = 'westus2'
#$clusterName = 'hdilabs'
#$numInstances = 2

$destContainerName = "hdi-labs"
$sourceFolder = Get-Location
$cred = Get-Credential
$jobs = @()
For($i = 1; $i -le $numInstances; $i++){
    $clusterInstanceName = $clusterName + $i
    $resourceGroupInstanceName = $resourceGroupName +$i
    

    $params = @($clusterInstanceName, $resourceGroupInstanceName, $resourceGroupLocation, $subscriptionId, $sourceFolder, $destContainerName, $cred) 
    $job = Start-Job -ScriptBlock { 
        param($clusterInstanceName, $resourceGroupInstanceName, $resourceGroupLocation, $subscriptionId, $sourceFolder, $destContainerName, $cred) 
        try{
            Get-AzureRmSubscription
        }
        catch{
            Login-AzureRmAccount -Credential $cred
        }
        $sub = Select-AzureRmSubscription -SubscriptionId $subscriptionId
        Write-Host("Deploying instance " + $clusterInstanceName + " in Resource Group " + $resourceGroupInstanceName + " in subscription " + $sub.Subscription.SubscriptionName + " (" + $sub.Subscription.SubscriptionId + ")")
        Set-Location $sourceFolder
        .\Deploy-AzureResourceGroup.ps1 -ResourceGroupName $resourceGroupInstanceName -ResourceGroupLocation $resourceGroupLocation -TemplateFile 'azuredeploy.json' -TemplateParametersFile 'azuredeploy.parameters.json' -ClusterName $clusterInstanceName 
        $storageAccountName = $clusterInstanceName
        Select-AzureRmSubscription -SubscriptionId $subscriptionId
        Set-AzureRmCurrentStorageAccount -ResourceGroupName $resourceGroupInstanceName -Name $storageAccountName
        New-AzureStorageContainer -Name $destContainerName -Permission Off
        $storageKey = (Get-AzureRmStorageAccountKey -Name $storageAccountName -ResourceGroupName $resourceGroupInstanceName).Value[0]
        $sourceSAS = "'?sv=2017-04-17&ss=b&srt=co&sp=rl&se=2019-12-31T18:29:33Z&st=2017-09-18T10:29:33Z&spr=https&sig=bw1EJflDFx9NuvLRdBGql8RU%2FC9oz92Dz8Xs76cftJM%3D'"
        az storage blob copy start-batch --source-account-name retaildatasamples --source-container data   --account-name $storageAccountName --account-key $storageKey --destination-container $destContainerName --pattern retaildata/rawdata* --source-sas ${sourceSAS}

    } -ArgumentList $params  
    $jobs = $jobs + $job 
}

Wait-Job -Job $jobs
Get-Job | Receive-Job