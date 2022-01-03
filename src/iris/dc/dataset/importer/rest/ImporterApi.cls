/// Description
Class dc.dataset.importer.rest.ImporterApi Extends dc.dataset.importer.rest.Base
{

Parameter Version = "1.0.0";

Parameter Title = "IRIS dataset importer";

Parameter BasePath = "/dataset/importer";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<!-- Socrata dataset importer -->
<Route Url="/import" Method="POST" Call="ImportDataset" Cors="true"/>
<!-- Server Info -->
<Route Url="/" Method="GET" Call="GetInfo" Cors="true"/>
<!-- Swagger specs -->
<Route Url="/_spec" Method="GET" Call="SwaggerSpec" />
</Routes>
}

/// Description
ClassMethod ImportDataset() As %Status
{
    Set sc = $$$OK
    Set service = ##class(dc.dataset.importer.service.ImporterService).%New()
    Set response = service.Import(%request.Content)
    Return ..ProcessResult($$$OK, response)
}

}
