/// Description
Class dc.dataset.importer.service.ImporterService Extends %RegisteredObject
{

/// Description
Method Import(pParams As %DynamicObject) As %DynamicObject
{
    Set response = {}
    If (pParams.provider = ##class(dc.dataset.importer.socrata.SocrataApi).#Provider) {
        Set socrataApi = ##class(dc.dataset.importer.socrata.SocrataApi).%New()
        Set response = socrataApi.InstallDataset({
            "datasetId": (pParams.datasetId)
        })
    } Else {
        Throw ##class(%Exception.General).%New("Provider not supported")
    }
    Return response
}

}
