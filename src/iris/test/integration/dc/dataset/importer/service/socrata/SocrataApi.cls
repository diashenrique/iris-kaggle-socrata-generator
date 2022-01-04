/// Description
Class test.integration.dc.dataset.importer.service.socrata.SocrataApi Extends %UnitTest.TestCase
{

Property Api As dc.dataset.importer.service.socrata.SocrataApi;

Property Response As %DynamicObject;

Property HttpMock As test.integration.util.HttpUtil;

Method OnBeforeAllTests() As %Status
{
    Return $$$OK
}

ClassMethod LoadXData(pXDataId As %String) As %String
{
    Set content = ""
    Set xdata = ##class(%Dictionary.CompiledXData).%OpenId(pXDataId)
    Set data = xdata.Data
    Do data.Rewind()
    While 'data.AtEnd {
        Set content = content_data.Read()
    }
    Return content
}

Method OnBeforeOneTest(testname As %String) As %Status
{
    Set ..HttpMock = ##class(test.integration.util.HttpUtil).%New()
    Set ..Api = ##class(dc.dataset.importer.service.socrata.SocrataApi).%New(
        ..HttpMock
    )
    Quit $$$OK
}

Method OnAfterOneTest(testname As %String) As %Status
{
    Do $System.OBJ.Delete(..Response.className)
    Quit $$$OK
}

Method TestInstallDataset01()
{
    Set ..HttpMock.HttpGetJsonResponseMock = {}.%FromJSON(..LoadXData(
        "test.integration.util.Dataset01||Dataset01Catalog"
    ))
    Set ..HttpMock.HttpDownloadResponseMock = ..LoadXData(
        "test.integration.util.Dataset01||Dataset01"
    )
    Set ..Response = ..Api.InstallDataset({
        "datasetId": "fx5g-857s",
        "keepFile": false
    })
    #; zw ..Response
    Do $$$AssertEquals(..Response.className, "dc.dataset.imported.DsSppAverageClassScores")
    Do $$$AssertEquals(..Response.columns, "ScoreType VARCHAR(250),2015-16 DOUBLE,2016-17 DOUBLE,2017-18 DOUBLE,2018-19 DOUBLE,HeadStartFACES2009 MONEY,EAValidationStudy2013-2014 MONEY,SPPGoal DOUBLE")
    Do $$$AssertEquals(..Response.records, 4)
}

}
