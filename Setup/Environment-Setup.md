# Environment Setup

This article describes the steps required to setup the environment in order to conduct the labs. 


## 1. Deploying the Environment: HDInsight Clusters + Attached Storage Account
An ARM template and script is provided to aid in provisioning the clusters for attendees to use. Follow these steps to deploy your cluster:

1. Navigate to the Setup\Scripts folder. 
2. Open azuredeploy.parameters.json and provide the settings requested. At minimum provide a unique name for the cluster.
3. Save the file.
4. Open PowerShell and run the following command to login to your Azure account:

    ```
    Login-AzureRmAccount
    ```

4. Run the following command to provision the cluster:

    ```
    .\Deploy-AzureResourceGroup.ps1 -StorageAccountName '' -ResourceGroupName 'HDInsightLabsEnvironment-01' -ResourceGroupLocation 'westus2' -TemplateFile 'azuredeploy.json' -TemplateParametersFile 'azuredeploy.parameters.json' -ArtifactStagingDirectory '.' -DSCSourceFolder '.\DSC'
    ```

    **NOTE:** You may need to relax your PowerShell execution policy to execute this script. To do so, before running the above first run:
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted

```
    NOTE: Cluster Creation uses these as the defaults:
    - name : hdilabs20170914ignite01  
    - subscription: [user supplied]  
    - resource group: [user supplied] 
    - cluster type: Spark 2.1 on Linux HDI 3.6
    - cluster login username: admin
    - cluster login password: Abc!1234567890
    - ssh username: sshuser
    - use same password as cluster login: checked
    - location: [West US 2]

    - primary storage type: Azure Storage
    - selection method: access key
    - storage account name: [hdilabs20170914ignite01]
    - storage account key: [key]
    - default container: hdi-labs

    - number of worker nodes: 2
    - worker node size: D12 v2
    - head node size: D12 v2
    (will use 16 cores)
```

## 2. Preparing the Attached Storage Account
For each cluster, the script takes care of creating a new storage account, creating the hdi-labs container in it. You will need to copy the retaildata files to the hdi-labs container after the storage account has been created. 

The copy can be performed at the same time as the cluster is being provisioned, so that the data is ready at about the same time as the cluster.

After completing this step, your clusters will contain a copy of the retaildata files underneath the path /retaildata in the default storage container. 

The retaildata source files are currently available at the following public container (no Account Key is required for read access):

**account name**: retaildatasamples

**container**: data

**path**: retaildata

You can perform this copy using the Cloud Shell within the Azure Portal. Follow these steps:
1. Log in to the Azure Portal, and launch the Cloud Shell using the button in the top right corner.
2. Within the Cloud Shell run the following command to copy the dataset from the source location to your cluster's storage account. Observe that no account-key is required for the source because the source account is public/read-only and is accessed with a SAS token. **NOTE: This kicks off a background copy, while the command below will complete in 2-3 minutes, the actual copying of all files takes about 20-30 minutes**.

    **HINT: append the ```--dryrun``` parameter to the below to preview the copy to make sure it is configured as intended.

    ```
    az storage blob copy start-batch --source-account-name retaildatasamples --source-container data   --account-name [DestinationAccountName] --account-key [DestinationAccountKey]  --destination-container hdi-labs --pattern retaildata/rawdata* --source-sas ?sv=2017-04-17&ss=b&srt=co&sp=rl&se=2019-12-31T18:29:33Z&st=2017-09-18T10:29:33Z&spr=https&sig=bw1EJflDFx9NuvLRdBGql8RU%2FC9oz92Dz8Xs76cftJM%3D

    ```

3. Verify the copy has completed by navigating to the destination container using the Azure Portal. In the container list, select the ellipses and then Container properties. If your ouput matches the following, all of the files have been copied over:

    Container Size
    * Blob Count: 3202
    * Size: 12.02 GiB
