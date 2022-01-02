/// Description
/// Based on https://github.com/intersystems-community/iris-rest-api-template
Class dc.dataset.importer.rest.Base Extends %CSP.REST
{

Parameter CHARSET = "utf-8";

Parameter CONTENTTYPE = "application/json";

Parameter HandleCorsRequest = 1;

Parameter Version = "1.0.0";

Parameter Title;

Parameter BasePath;

ClassMethod OnPreDispatch(pUrl As %String, pMethod As %String, ByRef pContinue As %Boolean) As %Status
{
    Set tSC = $$$OK
    Try {
        // read request object into %DynamicObject format
        If ((pMethod'="POST") && (pMethod'="PUT")) || (%request.Content="") {
            Set %request.Content = {}
        } Else {
            If '$isobject(%request.Content) {
                Set tContent = %request.Content
            } Else {
                Set tContent = ""
                While '%request.Content.AtEnd {
                    Set tContent = tContent_%request.Content.Read()
                }
            }
            If (tContent="") {
                Set %request.Content = {}
            } Else {
                Set tContent = $zconvert(tContent, "I", "UTF8")
                Set %request.Content = ##class(%Library.DynamicObject).%FromJSON(tContent)
            }
        }
    } Catch ex {
    Set tSC = ex.AsStatus()
    }
    Quit tSC
}

ClassMethod ProcessResult(pStatus As %Status = {$$$OK}, pResult As %DynamicObject = "") As %Status [ Internal ]
{
    Set tSC = $$$OK
    #Dim %response As %CSP.Response
    If $$$ISERR(pStatus) {
        Set %response.Status = 500
        Set tSC = ..StatusToJSON(pStatus, .tJSON)
        If $IsObject(tJSON) {
            Set pResult = tJSON
        } Else {
            Set pResult = { "errors": [ { "error": "Unknown error parsing status code" } ] }
        }
    } Else {
        If '$IsObject(pResult){
            Set pResult = {}
        }
    }
    
    If pResult.%Extends("%Library.DynamicAbstractObject") {
        Write pResult.%ToJSON()
    } ElseIf pResult.%Extends("%JSON.Adaptor") {
        Do pResult.%JSONExport()
    } ElseIf pResult.%Extends("%Stream.Object") {
        Do pResult.OutputToDevice()
    }
    
    Return tSC
}

ClassMethod GetInfo() As %Status
{
    Set version = ..#Version
    Set info = {
        "version": (version)
    }
    Return ..ProcessResult($$$OK, info)
}

ClassMethod SwaggerSpec() As %Status
{
    $$$TOE(st, ##class(%RoutineMgr).GetWebServerPort(.Port,.Server,.URLPrefix,.URL))
    Set tSC = ##class(%REST.API).GetWebRESTApplication($NAMESPACE, %request.Application, .swagger)
    Do swagger.info.%Remove("x-ISC_Namespace")
    Set swagger.basePath = ..#BasePath
    Set swagger.info.title = ..#Title
    Set swagger.info.version = ..#Version
    // for random ports containers, don't fix a value for this config
    #; Set swagger.host = "localhost:62133"
    Return ..ProcessResult($$$OK, swagger)
}

}
