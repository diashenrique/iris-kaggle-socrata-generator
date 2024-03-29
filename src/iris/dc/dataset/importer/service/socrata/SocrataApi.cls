/// Description
/// @see https://dev.socrata.com/
/// @see https://socratadiscovery.docs.apiary.io/#reference/0/find-by-type/search-by-type
Class dc.dataset.importer.service.socrata.SocrataApi Extends dc.dataset.importer.service.AbstractImporterService
{

Parameter Provider = "socrata";

Property DatasetParams As %DynamicObject;

Property Catalog As %DynamicObject;

Method SearchDataset(pParams As %DynamicObject) As %DynamicObject
{
    Set searchParams = ""
    If (pParams.terms '= "") {
        Set $List(searchParams, * + 1) = "q="_$ZConvert(pParams.terms, "O", "URL")
    }
    Set searchParams = $LTS(searchParams, "&")
    Set response = ..HttpUtil.HttpGetJson({
        "Url": ("https://api.us.socrata.com/api/catalog/v1?only=datasets&"_searchParams)
    })
    Return response
}

Method GetDatasetDetails(pParams As %DynamicObject) As %DynamicObject
{
    // todo:
    #; Set params = {
    #;     "Url": ("https://www.kaggle.com/api/v1/datasets/list/"_pParams.datasetId)
    #; }
    #; Set params = ..InsertKaggleCredentials(pParams, params)
    #; Set response = ..HttpUtil.HttpGetJson(params)
    Set response = {}
    Return response
}

Method GetDatasetId() As %String
{
    Set datasetId = ..DatasetParams.datasetId
    If (datasetId = "") {
        Throw ##class(%Exception.General).%New("In order to install a Socrata dataset you must provide an ID.")
    }
    Return datasetId
}

Method GetCatalog() As %DynamicObject
{
    If ('$IsObject(..Catalog)) || (..Catalog.%ToJSON() = "{}") {
        Set datasetId = ..GetDatasetId()
        Set ..Catalog = ..HttpUtil.HttpGetJson({
            "Url": ("https://api.us.socrata.com/api/catalog/v1?ids="_datasetId)
        })
    }
    Return ..Catalog
}

Method HasResult() As %Boolean
{
    Do ..GetCatalog()
    Return (..Catalog.error = "") && ((..Catalog.results '= "") && (..Catalog.results.%Size() > 0))
}

Method GetDatasetLicense() As %String
{
    If (..GetCatalog().results) {
        Return ..GetCatalog().results.%Get(0).metadata.license
    }
    Return ""
}

Method ProcessInstallation() As %DynamicObject
{
    Set retorno = {
        "warnings": []
    }

    Set datasetId = ..GetDatasetId()

    Do ..GetCatalog()
    
    If (..Catalog.results.%Size() > 1) {
        Do retorno.warnings.%Push("There is more than 1 results. Using just the first one.")
    }
    
    Do ..SetProgressInfo(..ProgressInfoKey, {
        "status":"downloading"
    })
    Set domain = ..Catalog.results.%Get(0).metadata.domain
    Set donwloadUrl = "https://"_domain_"/api/views/"_datasetId_"/rows.csv?accessType=DOWNLOAD"
    Set ..DownloadInfo = ..HttpUtil.HttpDownloadCsvFile({
        "Url": (donwloadUrl)
    })

    Do ..FixCsvHeader()

    Set packageName = ..GetPackageName()
    Set className = ..GetClassName()
    Set fileName = ..DownloadInfo.fileName
    Set fqn = ..GetClassFQN(packageName, className)
    Set verbose = $Case(..DatasetParams.verbose, "":0, :..DatasetParams.verbose)

    Do ..SetProgressInfo(..ProgressInfoKey, {
        "status":"installing"
    })
    Set ex = ""
    Set recordsCount = 0
    Try {
        // todo: in order to minimise errors, the flag to let CSVGEN guess the col type was 
        // turned off; turn it on again and deal with such errors
        $$$TOE(st, ##class(community.csvgen).Generate(fileName, , fqn, .rowType, 0, .recordsCount, verbose))
    } Catch(e) {
        Set ex = ##class(%Exception.General).%New(%sqlcontext.%Message)
    }

    If ('..DatasetParams.keepFile) {
        $$$TOE(st, ##class(%File).Delete(fileName))
    }

    If ($IsObject(ex)) {
        Do $System.OBJ.Delete(fqn, "/display=none")
        Throw ex
    }

    Set retorno.className = fqn
    Set retorno.columns = rowType
    Set retorno.records = recordsCount

    Return retorno
}

Method GetClassName() As %String
{
    Do ..GetCatalog()
    Set className = ..DatasetParams.className
    If (className = "") {
        Set className = ..DatasetParams.datasetId
        Set className = ..Catalog.results.%Get(0).resource.name
        Set className = ..FixClassName(className)
    }
    Return className
}

}
