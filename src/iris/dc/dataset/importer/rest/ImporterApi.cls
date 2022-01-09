/// Description
Class dc.dataset.importer.rest.ImporterApi Extends dc.dataset.importer.rest.Base
{

Parameter Version = "1.0.0";

Parameter Title = "IRIS dataset importer";

Parameter BasePath = "/dataset/importer";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<!-- Dataset search: Examples: (1) {"provider":"kaggle", "terms":"healthcare diabets", "credentials":"kaggle"}, (2) {"provider":"kaggle", "terms":"healthcare diabets", "credentials":"kaggle"} -->
<Route Url="/search" Method="POST" Call="SearchDataset" Cors="true"/>
<!-- Dataset importer. Examples: (1) {"provider":"socrata", "datasetId":"hdpu-mku8"}, (2) {"provider":"kaggle", "datasetId":"joniarroba/noshowappointments", "credentials":"kaggle"} -->
<Route Url="/import" Method="POST" Call="ImportDataset" Cors="true"/>
<!-- Credentials creation/update. Example: {"key":"kaggle", "username":"<your-username>", "password":"<your-password>"} -->
<Route Url="/credentials" Method="POST" Call="CreateUpdateCredentials" Cors="true"/>
<!-- Credentials removal -->
<Route Url="/credentials/:key" Method="DELETE" Call="DeleteCredentials" Cors="true"/>
<!-- Server Info -->
<Route Url="/" Method="GET" Call="GetInfo" Cors="true"/>
<!-- Swagger specs -->
<Route Url="/_spec" Method="GET" Call="SwaggerSpec" />
</Routes>
}

/// Description
ClassMethod SearchDataset() As %Status
{
    Set service = ##class(dc.dataset.importer.service.ImporterService).%New()
    Set response = service.Search(%request.Content)
    Return ..ProcessResult($$$OK, response)
}

/// Description
ClassMethod ImportDataset() As %Status
{
    Set service = ##class(dc.dataset.importer.service.ImporterService).%New()
    Set response = service.Import(%request.Content)
    Return ..ProcessResult($$$OK, response)
}

/// Description
ClassMethod CreateUpdateCredentials() As %Status
{
    Set service = ##class(dc.dataset.importer.service.ImporterService).%New()
    Do service.SaveCredentials(%request.Content)
    Return $$$OK
}

/// Description
ClassMethod DeleteCredentials(pCredentialKey As %String) As %Status
{
    Set service = ##class(dc.dataset.importer.service.ImporterService).%New()
    Do service.DeleteCredentials(pCredentialKey)
    Return $$$OK
}

}
