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


$sourceFolder = Get-Location
$cred = Get-Credential
$jobs = @()
For($i = 1; $i -le $numInstances; $i++){
    $clusterInstanceName = $clusterName + $i
    $resourceGroupInstanceName = $resourceGroupName +$i
    

    $params = @($clusterInstanceName, $resourceGroupInstanceName, $resourceGroupLocation, $subscriptionId, $sourceFolder, $cred) 
    $job = Start-Job -ScriptBlock { 
        param($clusterInstanceName, $resourceGroupInstanceName, $resourceGroupLocation, $subscriptionId, $sourceFolder, $cred) 
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
    } -ArgumentList $params  
    $jobs = $jobs + $job 
}

Wait-Job -Job $jobs
Get-Job | Receive-Job