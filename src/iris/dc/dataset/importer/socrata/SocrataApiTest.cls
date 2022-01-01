/// Description
Class dc.dataset.importer.socrata.SocrataApiTest Extends %RegisteredObject
{

Property Api As dc.dataset.importer.socrata.SocrataApi;

Method %OnNew() As %Status
{
    Set ..Api = ##class(dc.dataset.importer.socrata.SocrataApi).%New()
    Return $$$OK
}

Method Test()
{
    Set data = ..Api.HttpGetJson({
        "Server": "api.census.gov",
        "SSLConfiguration": "ISC.FeatureTracker.SSL.Config",
        "Location": "/data/2014/pep/natstprc?get=STNAME,POP&for=state:*&DATE_=7"
    })
    Write data.%ToJSON(), !
}

Method DatasetQueryTest1()
{
    Set data = ..Api.HttpGetJson({
        "Url": "https://api.us.socrata.com/api/catalog/v1?categories=Education&only=datasets"
    })
    Write data.%ToJSON(), !
}

Method DatasetQueryTest2()
{
    Set data = ..Api.HttpGetJson({
        "Url": "https://api.us.socrata.com/api/catalog/v1?categories=Education&search_context=data.seattle.gov&only=datasets"
    })
    Write data.%ToJSON(), !
}

Method DatasetQueryTest3()
{
    Set data = ..Api.HttpGetJson({
        "Url": "https://api.us.socrata.com/api/catalog/v1?q=chicago%20crime&only=datasets"
    })
    Write data.%ToJSON(), !
}

Method DownloadDataset1()
{
    Do ..Api.HttpDownload({
        "Url": "https://data.seattle.gov/api/views/fx5g-857s/rows.csv?accessType=DOWNLOAD"
    })
}

Method DownloadDataset2()
{
    Do ..Api.HttpDownload({
        "Url": "https://data.cityofnewyork.us/api/views/hdpu-mku8/rows.csv?accessType=DOWNLOAD"
    })
}

Method DownloadDataset3()
{
    Do ..Api.HttpDownload({
        "Url": "https://data.cityofchicago.org/api/views/ijzp-q8t2/rows.csv?accessType=DOWNLOAD"
    })
}

Method InstallDatasetTest1()
{
    Do ..Api.InstallDataset({
        "datasetId": "fx5g-857s"
    })
}

Method InstallDatasetTest2()
{
    Do ..Api.InstallDataset({
        "datasetId": "hdpu-mku8"
    })
}

Method InstallDatasetTest3()
{
    Do ..Api.InstallDataset({
        "datasetId": "n9tp-i3k3"
    })
}

Method InstallDatasetTest4()
{
    Do ..Api.InstallDataset({
        "datasetId": "emzy-79p5"
    })
}

Method InstallDatasetTest5()
{
    Do ..Api.InstallDataset({
        "datasetId": "vzxr-ymut"
    })
}

Method InstallDatasetTest6()
{
    Do ..Api.InstallDataset({
        "datasetId": "vzxr-ymut"
    })
}

Method InstallBigDatasetTest1()
{
    Do ..Api.InstallDataset({
        "datasetId": "ijzp-q8t2"
    })
}

}