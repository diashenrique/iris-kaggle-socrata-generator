/// Description
Class dc.PackageSample.SocrataApiTest Extends %RegisteredObject
{

Property SslConfiguration As %String [ InitialExpression = "ISC.FeatureTracker.SSL.Config" ];

Property DefaultCsvDel As %String [ InitialExpression = "," ];

Property DatasetParams As %DynamicObject [ Private ];

Property Catalog As %DynamicObject [ Private ];

Property DownloadInfo As %DynamicObject [ Private ];

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

    Set fileName = "/tmp/"_$REPLACE($REPLACE($NOW(), ".", ""), ",", "")
    Set file = ##class(%FileBinaryStream).%New()
    $$$TOE(st, file.LinkToFile(fileName))
    $$$TOE(st, file.CopyFrom(request.HttpResponse.Data))
    $$$TOE(st, file.%Save())
    $$$TOE(st, file.%Close())

    Set retorno.fileName = fileName

    Return retorno
}

Method InstallDataset(pDatasetParams As %DynamicObject)
{
    Set datasetId = pDatasetParams.datasetId

    Set ..Catalog = ..HttpGetJson({
        "Url": ("https://api.us.socrata.com/api/catalog/v1?ids="_datasetId)
    })
    
    Set domain = ..Catalog.results.%Get(0).metadata.domain
    Set donwloadUrl = "https://"_domain_"/api/views/"_datasetId_"/rows.csv?accessType=DOWNLOAD"
    Set ..DownloadInfo = ..HttpDownload({
        "Url": (donwloadUrl)
    })

    Do ..FixCsvHeader()

    Set packageName = ..GetPackageName(pDatasetParams)
    Set className = ..GetClassName(pDatasetParams)
    Set fileName = ..DownloadInfo.fileName
    Set fqn = ..GetClassFQN(packageName, className)
    Do ##class(community.csvgen).Generate(fileName, , fqn)
}

Method FixCsvHeader()
{
    Set csvDel = $Case(..DownloadInfo.CsvDel, "":..DefaultCsvDel, :..DownloadInfo.CsvDel)
    Set csvHeader = ""
    Set headerLength = 0

    // analyze the csv header using info in dataset catalog
    Set stream = ##class(%Stream.FileCharacter).%New()
    $$$TOE(st, stream.LinkToFile(..DownloadInfo.fileName))
    While 'stream.AtEnd {
        Set line = stream.ReadLine()
        Set csvHeader = csvHeader_line
        Set headerLength = headerLength + $Length(line)

        Set actualColsNumber = $Length(csvHeader, csvDel)
        Set expectedColsNumber = ..Catalog.results.%Get(0).resource."columns_name".%Size()

        If (actualColsNumber = expectedColsNumber) {
            Quit
        }
        If (actualColsNumber > expectedColsNumber) {
            Throw ##class(%Exception.General).%New("CSV file has more columns than described in dataset catalog")
        }
    }
    Kill stream

    // fix the CSV file header
    Set file = ##class(%File).%New(..DownloadInfo.fileName)
    $$$TOE(st, file.Open("W"))
    Do file.Write(csvHeader)
    For line = $Length(csvHeader):1:headerLength {
        Do file.Write(" ")
    }
    Do file.Close()
}

Method GetPackageName(pDatasetParams As %DynamicObject) As %String
{
    Set packageName = pDatasetParams.packageName
    If (packageName = "") {
        // todo: trocar
        Set packageName = "dc.PackageSample.datasets"
    }
    Return packageName
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

Method GetClassFQN(pPackageName As %String, pClassName As %String) As %String
{
    Set fqn = pPackageName_"."_pClassName
    Set fqn = $Extract(fqn, 1, 220)
    Return fqn
}

Method SearchDataset()
{
}

Method Test()
{
    Set data = ..HttpGetJson({
        "Server": "api.census.gov",
        "SSLConfiguration": "ISC.FeatureTracker.SSL.Config",
        "Location": "/data/2014/pep/natstprc?get=STNAME,POP&for=state:*&DATE_=7"
    })
    Write data.%ToJSON(), !
}

Method DatasetQueryTest1()
{
    Set data = ..HttpGetJson({
        "Url": "https://api.us.socrata.com/api/catalog/v1?categories=Education&only=datasets"
    })
    Write data.%ToJSON(), !
}

Method DatasetQueryTest2()
{
    Set data = ..HttpGetJson({
        "Url": "https://api.us.socrata.com/api/catalog/v1?categories=Education&search_context=data.seattle.gov&only=datasets"
    })
    Write data.%ToJSON(), !
}

Method DatasetQueryTest3()
{
    Set data = ..HttpGetJson({
        "Url": "https://api.us.socrata.com/api/catalog/v1?q=chicago%20crime&only=datasets"
    })
    Write data.%ToJSON(), !
}

Method DownloadDataset1()
{
    Do ..HttpDownload({
        "Url": "https://data.seattle.gov/api/views/fx5g-857s/rows.csv?accessType=DOWNLOAD"
    })
}

Method DownloadDataset2()
{
    Do ..HttpDownload({
        "Url": "https://data.cityofnewyork.us/api/views/hdpu-mku8/rows.csv?accessType=DOWNLOAD"
    })
}

Method DownloadDataset3()
{
    Do ..HttpDownload({
        "Url": "https://data.cityofchicago.org/api/views/ijzp-q8t2/rows.csv?accessType=DOWNLOAD"
    })
}

Method InstallDatasetTest1()
{
    Do ..InstallDataset({
        "datasetId": "fx5g-857s"
    })
}

Method InstallDatasetTest2()
{
    Do ..InstallDataset({
        "datasetId": "hdpu-mku8"
    })
}

Method InstallDatasetTest3()
{
    Do ..InstallDataset({
        "datasetId": "ijzp-q8t2"
    })
}

}
