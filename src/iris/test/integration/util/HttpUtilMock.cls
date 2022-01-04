/// Description
Class test.integration.util.HttpUtil Extends %RegisteredObject
{

Property HttpGetJsonResponseMock As %String;

Property HttpDownloadResponseMock As %String;

Property TempDir As %String [ InitialExpression = {##class(%File).NormalizeDirectory(##class(%SYS.System).TempDirectory())} ];

Method HttpGetJson(pHttpParams As %DynamicObject) As %String
{
    Return ..HttpGetJsonResponseMock
}

Method HttpDownload(pHttpParams As %DynamicObject) As %DynamicObject
{
    Set fileName = ..TempDir_$Translate($Now(), ".,", "")
    Set file = ##class(%File).%New(fileName)
    $$$TOE(st, file.Open("WSN"))
    $$$TOE(st, file.Write(..HttpDownloadResponseMock))
    Do file.Close()
    Return {
        "fileName": (fileName)
    }
}

}
