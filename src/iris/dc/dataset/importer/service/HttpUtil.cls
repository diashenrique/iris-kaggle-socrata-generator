/// Description
Class dc.dataset.importer.service.HttpUtil Extends %RegisteredObject
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

    Set username = pHttpParams.username
    Set password = pHttpParams.password
    If (username '= "") && (password '= "") {
        Set request.Username = username
        Set request.Password = password
    } ElseIf (pHttpParams.irisInteropCredentials '= "") {
        // todo: get credetials from IRIS Interoperability
        Set credentials = ##class(Ens.Config.Credentials).%OpenId("kaggle")
        If (credentials = "") {
            Throw ##class(%Exception.General).%New("Credentials not found.")
        }
        Set request.Username = credentials.Username
        Set request.Password = credentials.Password
    }

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

    Do ..ValidateCsvContentType(request, "text/csv")
    Set fileName = ..SaveRequestToFile(request)
    Set retorno.fileName = fileName

    Return retorno
}

/// Description
Method HttpDownloadZIP(pHttpParams As %DynamicObject) As %DynamicObject
{
    Set retorno = {
        "warnings": []
    }
    
    #; Set url = "https://www.kaggle.com/api/v1/datasets/list/joniarroba/noshowappointments"
    Set url = "https://www.kaggle.com/api/v1/datasets/download/joniarroba/noshowappointments"
    Set username = "jjunior"
    Set password = "b2d5fa4d1fd88cb98698005166e0bd0f"

    // todo: validate content-type using a HEAD

    Set request = ..CreateHttpRequest({
        "Url": (url),
        "username": (username),
        "password": (password)
    })
    $$$TOE(st, request.Get(url))
    Do ..ValidateCsvContentType(request, "application/zip")
    Set fileName = ..SaveRequestToFile(request)

    Set zipTempDir = ..TempDir_"/dir"_##class(%File).GetFilename(fileName)
    If ('##class(%File).CreateDirectory(zipTempDir, .status)) {
        Throw ##class(%Exception.General).%New("Can't create a temp directory for extrating zip file.")
    }
    Set fileList = ..UnZip(fileName, zipTempDir)
    If (fileList.%Size() > 1) {
        Do retorno.warnings.%Push("There was more than 1 file in the zip file. Using the first one.")
    }
    Set retorno.fileName = zipTempDir_"/"_fileList.%Get(0)

    Return retorno
}

Method ValidateCsvContentType(pRequest As %Net.HttpRequest, pContentType As %String)
{
    Set request = pRequest
    Set responseContentType = request.HttpResponse.ContentType
    If (responseContentType '[ pContentType) {
        Throw ##class(%Exception.General).%New("Expected a response with ContentType="""_pContentType_""", got """_responseContentType_ """ instead.")
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

/// Description
ClassMethod UnZip(pZipFileName As %String, pExtractToDir As %String) As %DynamicObject [ Language = python ]
{
    #; https://stackoverflow.com/a/3451150/345422
    import zipfile
    import iris
    with zipfile.ZipFile(pZipFileName, 'r') as zip_ref:
        zip_ref.extractall(pExtractToDir)
        fileList = zip_ref.namelist()
    
    dynarray = iris.cls("%DynamicArray")._New()
    for file in fileList:
        dynarray._Push(file)
    return dynarray
}

}
