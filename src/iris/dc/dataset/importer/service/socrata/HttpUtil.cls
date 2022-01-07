/// Description
Class dc.dataset.importer.service.socrata.HttpUtil Extends %RegisteredObject
{

Property SslConfiguration As %String [ InitialExpression = "ISC.FeatureTracker.SSL.Config" ];

Property TempDir As %String;

Method %OnNew() As %Status
{
    Set ..TempDir = ##class(%File).NormalizeDirectory(##class(%SYS.System).TempDirectory())
    Return $$$OK
}

Method CreateHttpRequest(pHttpParams As %DynamicObject) As %Net.HttpRequest
{
    Set request = ##class(%Net.HttpRequest).%New()

    Set request.Https = $Case(pHttpParams.Https, "":1, :pHttpParams.Https)
    Set request.SSLConfiguration = $Case(pHttpParams.SSLConfiguration, "":..SslConfiguration, :pHttpParams.SSLConfiguration)
    
    If (pHttpParams.ContentType '= "") {
        Set request.ContentType = pHttpParams.ContentType
    }
    
    If (pHttpParams.Url = "") {
        Set request.Server = pHttpParams.Server
        Set request.Location = pHttpParams.Location
    }

    Return request
}

Method HttpGet(pHttpParams As %DynamicObject) As %String
{
    Set pHttpParams.ContentType = "application/json"
    Set request = ..CreateHttpRequest(pHttpParams)

    If (pHttpParams.Url = "") {
        Set location = pHttpParams.Location
        $$$TOE(st, request.Get(location))
    } Else {
        Set url = pHttpParams.Url
        $$$TOE(st, request.Get(url))
    }

    Set response = request.HttpResponse
    Set data = response.Data
    Set respText = ""
    While 'data.AtEnd {
        Set respText = respText_data.Read()
    }

    If (request.ContentType = "aplication/json") {
        Set respText = $ZCVT(respText, "I", "JSON")
    }

    Return respText
}

Method HttpGetJson(pHttpParams As %DynamicObject) As %DynamicObject
{
    Set json = ..HttpGet(pHttpParams)
    Return ##class(%DynamicObject).%FromJSON(json)
}

Method HttpDownloadCsvFile(pHttpParams As %DynamicObject) As %DynamicObject
{
    Set retorno = {}

    // todo: validate content-type using a HEAD

    Set request = ..CreateHttpRequest(pHttpParams)
    $$$TOE(st, request.Get(pHttpParams.Url))

    Do ..ValidateCsvContentType(request)
    Set fileName = ..SaveRequestToFile(request)
    Set retorno.fileName = fileName

    Return retorno
}

Method ValidateCsvContentType(pRequest As %Net.HttpRequest)
{
    Set request = pRequest
    Set respponseContentType = request.HttpResponse.ContentType
    If (respponseContentType '[ "text/csv") {
        Throw ##class(%Exception.General).%New("Expected a response with ContentType=""text/csv"", got """_respponseContentType_ """ instead.")
    }
}

Method SaveRequestToFile(pRequest As %Net.HttpRequest, pFileName As %String = "") As %String
{
    If (pFileName '= "") {
        Set fileName = pFileName
    } Else {
        Set fileName = ..TempDir_$Translate($Now(), ".,", "")
    }

    Set file = ##class(%FileBinaryStream).%New()
    $$$TOE(st, file.LinkToFile(fileName))
    $$$TOE(st, file.CopyFrom(pRequest.HttpResponse.Data))
    $$$TOE(st, file.%Save())
    $$$TOE(st, file.%Close())

    Return fileName
}

}
