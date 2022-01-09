/// Description
Class dc.dataset.importer.service.socrata.SocrataApi Extends dc.dataset.importer.service.AbstractImporterService
{

Parameter Provider = "socrata";

Property DatasetParams As %DynamicObject [ Private ];

Property Catalog As %DynamicObject [ Private ];

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

Method InstallDataset(pDatasetParams As %DynamicObject) As %DynamicObject
{
    Set datasetId = pDatasetParams.datasetId
    If (datasetId = "") {
        Throw ##class(%Exception.General).%New("In order to install a Socrata dataset you must provide an ID.")
    }

    Set ..Catalog = ..HttpUtil.HttpGetJson({
        "Url": ("https://api.us.socrata.com/api/catalog/v1?ids="_datasetId)
    })
    
    Set domain = ..Catalog.results.%Get(0).metadata.domain
    Set donwloadUrl = "https://"_domain_"/api/views/"_datasetId_"/rows.csv?accessType=DOWNLOAD"
    Set ..DownloadInfo = ..HttpUtil.HttpDownloadCsvFile({
        "Url": (donwloadUrl)
    })

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

    Return {
        "className": (fqn),
        "columns": (rowType),
        "records": (recordsCount)
    }
}

Method GetClassName(pDatasetParams As %DynamicObject) As %String
{
    Set className = pDatasetParams.className
    If (className = "") {
        Set className = pDatasetParams.datasetId
        Set className = ..Catalog.results.%Get(0).resource.name
        Set className = $ZCVT("DS "_className, "W") // converts to CamelCase
        Set className = $TR(className, " -_", "") // remove non-valid chars
        Set className = $Extract(className, 1, 60) // classes name must have length up to 60
    }
    Return className
}

}
