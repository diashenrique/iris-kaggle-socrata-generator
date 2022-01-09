/// Description
Class dc.dataset.importer.service.kaggle.KaggleApi Extends dc.dataset.importer.service.AbstractImporterService
{

Parameter Provider = "kaggle";

Property Metadata As %DynamicObject;

Method SearchDataset(pParams As %DynamicObject) As %DynamicObject
{
    Set searchParams = ""
    If (pParams.terms '= "") {
        Set $List(searchParams, * + 1) = "search="_$ZConvert(pParams.terms, "O", "URL")
    }
    Set searchParams = $LTS(searchParams, "&")
    Set params = {
        "Url": ("https://www.kaggle.com/api/v1/datasets/list?filetype=csv&"_searchParams)
    }
    Set params = ..InsertKaggleCredentials(pParams, params)
    Set response = ..HttpUtil.HttpGetJson(params)
    Return response
}

Method InstallDataset(pDatasetParams As %DynamicObject) As %DynamicObject
{
    Set retorno = {
        "warnings": []
    }

    Set datasetId = pDatasetParams.datasetId
    If (datasetId = "") {
        Throw ##class(%Exception.General).%New("In order to install a Kaggle dataset you must provide a ref parameter.")
    }
    
    Set paramsMetadata = {
        "Url": ("https://www.kaggle.com/api/v1/datasets/list/"_datasetId)
    }
    Set paramsMetadata = ..InsertKaggleCredentials(pDatasetParams, paramsMetadata)
    Set ..Metadata = ..HttpUtil.HttpGetJson(paramsMetadata)
    If (..Metadata.datasetFiles.%Size() > 1) {
        Do retorno.warnings.%Push("The dataset has more than 1 files. Using just the first one.")
    }
    Set fileId = $ZConvert(..Metadata.datasetFiles.%Get(0).ref, "O", "URL")
    
    Set downloadUrl = "https://www.kaggle.com/api/v1/datasets/download/"_datasetId_"/"_fileId
    Set paramsDownload = {
        "Url": (downloadUrl)
    }
    Set paramsDownload = ..InsertKaggleCredentials(pDatasetParams, paramsDownload)
    Set ..DownloadInfo = ..HttpUtil.HttpDownloadZIP(paramsDownload)

    Do ..FixCsvHeader()

    Set packageName = ..GetPackageName(pDatasetParams)
    Set className = ..GetClassName(pDatasetParams)
    Set fileName = ..DownloadInfo.fileName
    Set fqn = ..GetClassFQN(packageName, className)
    Set verbose = $Case(pDatasetParams.verbose, "":0, :pDatasetParams.verbose)
    Try {
        $$$TOE(st, ##class(community.csvgen).Generate(fileName, , fqn, .rowType, , .recordsCount, verbose))
    } Catch(e) {
        Throw ##class(%Exception.General).%New(%sqlcontext.%Message)
    }

    If ('pDatasetParams.keepFile) {
        $$$TOE(st, ##class(%File).Delete(fileName))
    }

    Set retorno.className = fqn
    Set retorno.columns = rowType
    Set retorno.records = recordsCount

    Return retorno
}

Method InsertKaggleCredentials(pParams As %DynamicObject, pDestParams As %DynamicObject) As %DynamicObject
{
    If (pParams.credentials '= "") {
        Set service = ##class(dc.dataset.importer.service.CredentialsService).%New()
        Set credentials = service.GetCredentials(pParams.credentials)
        Set pDestParams.username = credentials.username
        Set pDestParams.password = credentials.password
    } ElseIf (pParams.username '= "") && (pParams.password '= "") {
        Set pDestParams.username = pParams.username
        Set pDestParams.password = pParams.password
    } ElseIf (pParams.irisInteropCredentials '= "") {
        Set pDestParams.irisInteropCredentials = pParams.irisInteropCredentials
    } Else {
        Throw ##class(%Exception.General).%New("In order to use the Kaggle API you must provide your credentials in the Kaggle platform. More information here: https://www.kaggle.com/docs/api#authentication")
    }
    Return pDestParams
}

Method GetClassName(pDatasetParams As %DynamicObject) As %String
{
    Set className = pDatasetParams.className
    If (className = "") {
        Set datasetRef = $LFS(..Metadata.datasetFiles.%Get(0).datasetRef, "/")
        Set className = $List(datasetRef, *)
        Set className = $Replace(className, ".csv", "")
        Set className = $ZCVT("DS "_className, "W") // converts to CamelCase
        Set className = $TR(className, " -_", "") // remove non-valid chars
        Set className = $Extract(className, 1, 60) // classes name must have length up to 60
    }
    Return className
}

}
