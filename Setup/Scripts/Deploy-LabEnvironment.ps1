Param(
    [string] [Parameter(Mandatory=$true)] $subscriptionId,
    [string] [Parameter(Mandatory=$true)] $resourceGroupName,
    [string] [Parameter(Mandatory=$true)] $clusterName,
    [string] [Parameter(Mandatory=$true)] $clusterCount,
    [string] $resourceGroupLocation = 'eastus'
)

#$subscriptionId = 'e123f1b3-d19b-4cfa-98e9-bc9be62717bc'
#$resourceGroupName = 'HDInsightLabsEnvironmentZ'
#$resourceGroupLocation = 'westus2'
#$clusterName = 'hdilabsz1'
#$numInstances = 2

$destContainerName = "hdi-labs"
$sourceFolder = Get-Location
$clusterInstanceName = $clusterName
$resourceGroupInstanceName = $resourceGroupName


# Get-AzureRmSubscription

Login-AzureRmAccount 

$sub = Select-AzureRmSubscription -SubscriptionId $subscriptionId
Write-Host("Deploying instances with prefix " + $clusterInstanceName + " in Resource Group " + $resourceGroupInstanceName + " in subscription " + $sub.Subscription.SubscriptionName + " (" + $sub.Subscription.SubscriptionId + ")")
Set-Location $sourceFolder
.\Deploy-AzureResourceGroup.ps1 -ResourceGroupName $resourceGroupInstanceName `
                                -ResourceGroupLocation $resourceGroupLocation `
                                -TemplateFile 'azuredeploy.all.json' `
                                -TemplateParametersFile 'azuredeploy.all.parameters.json' `
                                -ClusterName $clusterInstanceName `
                                -ClusterCount $clusterCount
$storageAccountName = $clusterInstanceName
Select-AzureRmSubscription -SubscriptionId $subscriptionId
#Set-AzureRmCurrentStorageAccount -ResourceGroupName $resourceGroupInstanceName -Name $storageAccountName
#New-AzureStorageContainer -Name $destContainerName -Permission Off
$storageKey = (Get-AzureRmStorageAccountKey -Name $storageAccountName -ResourceGroupName $resourceGroupInstanceName).Value[0]
# $sourceSAS = "'?sv=2017-04-17&ss=b&srt=co&sp=rl&se=2019-12-31T18:29:33Z&st=2017-09-18T10:29:33Z&spr=https&sig=bw1EJflDFx9NuvLRdBGql8RU%2FC9oz92Dz8Xs76cftJM%3D'"
$sourceSAS = "?sv=2017-04-17&ss=b&srt=co&sp=rl&se=2019-12-31T18:29:33Z&st=2017-09-18T10:29:33Z&spr=https&sig=bw1EJflDFx9NuvLRdBGql8RU%2FC9oz92Dz8Xs76cftJM%3D"

For($i = 0; $i -lt $clusterCount; $i++){
    $destContainerName = $clusterName + $i
    $sourceAccountName = "retaildatasamples"
    $sourceContainer = "data"
    Write-Host("Copying blob batch from '" + $sourceAccountName + ".blob.core.windows.net/" + $sourceContainer + "' to '" + $storageAccountName + ".blob.core.windows.net/" + $destContainerName + "'.")
    # az storage blob copy start-batch --source-account-name $sourceAccountName --source-container $sourceContainer --account-name $storageAccountName --account-key $storageKey --destination-container $destContainerName --pattern retaildata/rawdata* --source-sas ${sourceSAS}
    $contextSource = New-AzureStorageContext -StorageAccountName $sourceAccountName -SasToken $sourceSAS  
    $contextDest = New-AzureStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageKey
    Get-AzureStorageBlob -Context $contextSource -Container $sourceContainer -Blob "*.csv" | Start-AzureStorageBlobCopy -DestContext $contextDest -DestContainer $destContainerName
    Get-AzureStorageBlob -Context $contextSource -Container $sourceContainer -Blob "*.txt" | Start-AzureStorageBlobCopy -DestContext $contextDest -DestContainer $destContainerName
}