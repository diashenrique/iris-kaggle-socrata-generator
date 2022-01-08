/// Description
Class dc.dataset.importer.service.kaggle.KaggleApi Extends dc.dataset.importer.service.AbstractImporterService
{

Parameter Provider = "kaggle";

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
    Return pDatasetParams
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

}
