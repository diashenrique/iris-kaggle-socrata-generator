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

Method HttpDownload(pHttpParams As %DynamicObject) As %DynamicObject
{
    Set retorno = {}

    Set request = ..CreateHttpRequest(pHttpParams)
    $$$TOE(st, request.Get(pHttpParams.Url))

    Set fileName = ..TempDir_$Translate($Now(), ".,", "") // todo: usar metodo pardrao para pegar o diretorio tmp do sistema
    Set file = ##class(%FileBinaryStream).%New()
    $$$TOE(st, file.LinkToFile(fileName))
    $$$TOE(st, file.CopyFrom(request.HttpResponse.Data))
    $$$TOE(st, file.%Save())
    $$$TOE(st, file.%Close())

    Set retorno.fileName = fileName

    Return retorno
}

}
