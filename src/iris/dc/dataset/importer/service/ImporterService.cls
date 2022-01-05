/// Description
Class dc.dataset.importer.service.ImporterService Extends %RegisteredObject
{

/// Description
Method ApiFactory(pParams As %DynamicObject) As %RegisteredObject
{
    Set api = ""
    If (pParams.provider = ##class(dc.dataset.importer.service.socrata.SocrataApi).#Provider) {
        Set api = ##class(dc.dataset.importer.service.socrata.SocrataApi).%New()
    } Else {
        Throw ##class(%Exception.General).%New("Provider not supported")
    }
    Return api
}

/// Description
Method Import(pParams As %DynamicObject) As %DynamicObject
{
    Set api = ..ApiFactory(pParams)
    Set response = api.InstallDataset({
        "datasetId": (pParams.datasetId)
    })
    #; If (pParams.provider = ##class(dc.dataset.importer.service.socrata.SocrataApi).#Provider) {
    #;     Set socrataApi = ##class(dc.dataset.importer.service.socrata.SocrataApi).%New()
    #;     Set response = socrataApi.InstallDataset({
    #;         "datasetId": (pParams.datasetId)
    #;     })
    #; } Else {
    #;     Throw ##class(%Exception.General).%New("Provider not supported")
    #; }
    Return response
}

/// Description
Method Search(pParams As %DynamicObject) As %Status
{
    Set api = ..ApiFactory(pParams)
    Set response = api.SearchDataset(pParams)
    Return response
}

}
