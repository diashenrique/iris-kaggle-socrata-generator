/// Description
Class dc.dataset.importer.service.ImporterService Extends %RegisteredObject
{

/// Description
Method ApiFactory(pParams As %DynamicObject) As %RegisteredObject
{
    Set api = ""
    If (pParams.provider = ##class(dc.dataset.importer.service.socrata.SocrataApi).#Provider) {
        Set api = ##class(dc.dataset.importer.service.socrata.SocrataApi).%New()
    } ElseIf (pParams.provider = ##class(dc.dataset.importer.service.kaggle.KaggleApi).#Provider) {
        Set api = ##class(dc.dataset.importer.service.kaggle.KaggleApi).%New()
    } Else {
        Throw ##class(%Exception.General).%New("Provider not supported")
    }
    Return api
}

/// Description
Method Search(pParams As %DynamicObject) As %DynamicObject
{
    Set api = ..ApiFactory(pParams)
    Set response = api.SearchDataset(pParams)
    Return response
}

/// Description
Method Import(pParams As %DynamicObject) As %DynamicObject
{
    Set api = ..ApiFactory(pParams)
    Set response = api.InstallDataset({
        "datasetId": (pParams.datasetId),
        "credentials":(pParams.credentials)
    })
    Return response
}

Method SaveCredentials(pParams As %DynamicObject)
{
    Set service = ##class(dc.dataset.importer.service.CredentialsService).%New()
    Set credentialsKey = pParams.key
    Set username = pParams.username
    Set password = pParams.password
    Do service.SaveCredentials(credentialsKey, username, password)
}

Method DeleteCredentials(pCredentialKey As %String)
{
    Set service = ##class(dc.dataset.importer.service.CredentialsService).%New()
    Do service.DeleteCredentials(pCredentialKey)
}

}
