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
    /// Dataset with columns name as numbers and with brackets
    Set ..HttpMock.HttpGetJsonResponseMock = {}.%FromJSON(..LoadXData(
        "test.integration.util.Dataset01||Catalog"
    ))
    Set ..HttpMock.HttpDownloadResponseMock = ..LoadXData(
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
    Set ..HttpMock.HttpDownloadResponseMock = ..LoadXData(
        "test.integration.util.Dataset02||CsvFile"
    )
    Set ..Response = ..Api.InstallDataset({
        "datasetId": "hdpu-mku8",
        "keepFile": false
    })
    #; zw ..Response
    Do $$$AssertEquals(..Response.className, "dc.dataset.imported.Ds20142015ParentSchoolSurveyData")
    Do $$$AssertEquals(..Response.columns, "DBN VARCHAR(250),SchoolName VARCHAR(250),""TotalParentResponseRate"" INTEGER,TotalTeacherResponseRate INTEGER,TotalStudentResponseRatee VARCHAR(250)")
    Do $$$AssertEquals(..Response.records, 2098)
}

Method TestInstallDataset03()
{
    /// Dataset with line break in header
    Set ..HttpMock.HttpGetJsonResponseMock = {}.%FromJSON(..LoadXData(
        "test.integration.util.Dataset03||Catalog"
    ))
    Set ..HttpMock.HttpDownloadResponseMock = ..LoadXData(
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
    Set ..HttpMock.HttpDownloadResponseMock = ..LoadXData(
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
    Set ..HttpMock.HttpDownloadResponseMock = ..LoadXData(
        "test.integration.util.Dataset05||CsvFile"
    )
    Set ..Response = ..Api.InstallDataset({
        "datasetId": "vzxr-ymut",
        "keepFile": false
    })
    #; zw ..Response
    Do $$$AssertEquals(..Response.className, "dc.dataset.imported.DsCovid19TestingByHealthcareSystem")
    Do $$$AssertEquals(..Response.columns, "hcs VARCHAR(250),people_served INTEGER,total_tests INTEGER,tests_7days INTEGER,daily_avg_test INTEGER,daily_avg_rate INTEGER")
    Do $$$AssertEquals(..Response.records, 6)
}

}
