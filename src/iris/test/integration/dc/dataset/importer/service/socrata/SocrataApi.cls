/// Description
Class test.integration.dc.dataset.importer.service.socrata.SocrataApi Extends %UnitTest.TestCase
{

Property Api As dc.dataset.importer.service.socrata.SocrataApi;

Property Response As %DynamicObject;

Property HttpMock As test.integration.util.HttpUtil;

/// Description
ClassMethod ConfigAndRun() As %Status
{
    Set sc = $$$OK
    Set ^UnitTestRoot = "/irisrun/repo/src/iris/"
    Set packageName = ..%PackageName()
    Do ##class(%UnitTest.Manager).RunTest(packageName, "/loadudl/nodelete")
    #; Do ##class(%UnitTest.Manager).RunTest(, "/nodelete")
    Return sc
}

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
    /// Dataset with columns name as numbers and with brackets
    Set ..HttpMock.HttpGetJsonResponseMock = {}.%FromJSON(..LoadXData(
        "test.integration.util.Dataset01||Catalog"
    ))
    Set ..HttpMock.HttpDownloadCsvFileResponseMock = ..LoadXData(
        "test.integration.util.Dataset01||CsvFile"
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

Method TestInstallDataset02()
{
    /// Dataset with line break in header
    Set ..HttpMock.HttpGetJsonResponseMock = {}.%FromJSON(..LoadXData(
        "test.integration.util.Dataset02||Catalog"
    ))
    Set ..HttpMock.HttpDownloadCsvFileResponseMock = ..LoadXData(
        "test.integration.util.Dataset02||CsvFile"
    )
    Set ex = ""
    Try {
        Set ..Response = ..Api.InstallDataset({
            "datasetId": "hdpu-mku8",
            "keepFile": false
        })
    } Catch(e) {
        Set ex = e
    }
    #; zw ..Response
    Do $$$AssertEquals(ex.Name, "The dataset must specify a license.")
}

Method TestInstallDataset03()
{
    /// Dataset with line break in header
    Set ..HttpMock.HttpGetJsonResponseMock = {}.%FromJSON(..LoadXData(
        "test.integration.util.Dataset03||Catalog"
    ))
    Set ..HttpMock.HttpDownloadCsvFileResponseMock = ..LoadXData(
        "test.integration.util.Dataset03||CsvFile"
    )
    Set ..Response = ..Api.InstallDataset({
        "datasetId": "n9tp-i3k3",
        "keepFile": false
    })
    #; zw ..Response
    Do $$$AssertEquals(..Response.className, "dc.dataset.imported.DsCommunityHealthcareCenters")
    Do $$$AssertEquals(..Response.columns, "Name VARCHAR(250),Description VARCHAR(250),Location VARCHAR(250),Phone_Number VARCHAR(250),geom VARCHAR(250)")
    Do $$$AssertEquals(..Response.records, 26)
}

Method TestInstallDataset04()
{
    /// Dataset with line break in header
    Set ..HttpMock.HttpGetJsonResponseMock = {}.%FromJSON(..LoadXData(
        "test.integration.util.Dataset04||Catalog"
    ))
    Set ..HttpMock.HttpDownloadCsvFileResponseMock = ..LoadXData(
        "test.integration.util.Dataset04||CsvFile"
    )
    Set ..Response = ..Api.InstallDataset({
        "datasetId": "emzy-79p5",
        "keepFile": false
    })
    #; zw ..Response
    Do $$$AssertEquals(..Response.className, "dc.dataset.imported.DsAccessToHealthcare")
    Do $$$AssertEquals(..Response.columns, "Geography VARCHAR(250),Year INTEGER,Race VARCHAR(250),Percentwithoutcoverage MONEY")
    Do $$$AssertEquals(..Response.records, 48)
}

Method TestInstallDataset05()
{
    /// Dataset with line break in header
    Set ..HttpMock.HttpGetJsonResponseMock = {}.%FromJSON(..LoadXData(
        "test.integration.util.Dataset05||Catalog"
    ))
    Set ..HttpMock.HttpDownloadCsvFileResponseMock = ..LoadXData(
        "test.integration.util.Dataset05||CsvFile"
    )
    Try {
        Set ..Response = ..Api.InstallDataset({
            "datasetId": "vzxr-ymut",
            "keepFile": false
        })
    } Catch(e) {
        Set ex = e
    }
    #; zw ..Response
    Do $$$AssertEquals(ex.Name, "The dataset must specify a license.")
}

}
