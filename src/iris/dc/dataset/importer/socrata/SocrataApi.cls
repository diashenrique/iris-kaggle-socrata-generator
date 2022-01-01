/// Description
Class dc.dataset.importer.socrata.SocrataApi Extends %RegisteredObject
{

Property DefaultCsvDel As %String [ InitialExpression = "," ];

Property DefaultPackage As %String [ InitialExpression = "dc.dataset.imported" ];

Property DatasetParams As %DynamicObject [ Private ];

Property Catalog As %DynamicObject [ Private ];

Property DownloadInfo As %DynamicObject [ Private ];

Property HttpUtil As dc.dataset.importer.socrata.HttpUtil [ Private ];

Method %OnNew() As %Status
{
    Set ..HttpUtil = ##class(dc.dataset.importer.socrata.HttpUtil).%New()
    Return $$$OK
}

Method InstallDataset(pDatasetParams As %DynamicObject)
{
    Set datasetId = pDatasetParams.datasetId

    Set ..Catalog = ..HttpUtil.HttpGetJson({
        "Url": ("https://api.us.socrata.com/api/catalog/v1?ids="_datasetId)
    })
    
    Set domain = ..Catalog.results.%Get(0).metadata.domain
    Set donwloadUrl = "https://"_domain_"/api/views/"_datasetId_"/rows.csv?accessType=DOWNLOAD"
    Set ..DownloadInfo = ..HttpUtil.HttpDownload({
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

    // analyze the csv header looking for break lines in header
    Set mustRewrite = 0
    Set stream = ##class(%Stream.FileCharacter).%New()
    $$$TOE(st, stream.LinkToFile(..DownloadInfo.fileName))
    While 'stream.AtEnd {
        Set line = stream.ReadLine()
        Set csvHeader = csvHeader_line
        Set headerLength = headerLength + $Length(line)

        Set hasBreaklineCols = ($Length(csvHeader, """") # 2) = 0
        Quit:('hasBreaklineCols)

        Set mustRewrite = 1
    }
    Kill stream

    // fix the CSV file header
    If (mustRewrite) {
        Set file = ##class(%File).%New(..DownloadInfo.fileName)
        $$$TOE(st, file.Open("W"))
        Set csvHeader = ..FixColName(csvHeader)
        Do file.Write(csvHeader)
        For line = $Length(csvHeader):1:headerLength {
            Do file.Write(" ")
        }
        Do file.Close()
    }
}

/*
Method CreateHeader() As %String
{
    Set cols = ""
    Set names = ..Catalog.results.%Get(0).resource."columns_name"
    Set types = ..Catalog.results.%Get(0).resource."columns_datatype"
    Set colsLength = names.%Size() - 1
    For iCol = 0:1:colsLength {
        Set colName = ..FixColName(names.%Get(iCol))
        Set colType = ..TranslateType(types.%Get(iCol))
        Set $List(cols, * + 1) = colName_" "_colType
    }
    Return $LTS(cols, ", ")
}

Method TranslateType(pDatasetType As %String) As %String
{
    // ref: https://dev.socrata.com/docs/datatypes/#,
    Set sqlType = ""
    If (pDatasetType = "Number") {
        set sqlType = "DOUBLE"
    } ElseIf (pDatasetType = "Text") {
        Set sqlType = "VARCHAR"
    } ElseIf (pDatasetType = "Checkbox") {
        Set sqlType = "VARCHAR"
    } ElseIf (pDatasetType = "Point") {
        Set sqlType = "VARCHAR"
    } ElseIf (pDatasetType = "MultiPoint") {
        Set sqlType = "VARCHAR"
    } ElseIf (pDatasetType = "Line") {
        Set sqlType = "VARCHAR"
    } ElseIf (pDatasetType = "MultiLine") {
        Set sqlType = "VARCHAR"
    } ElseIf (pDatasetType = "Polygon") {
        Set sqlType = "VARCHAR"
    } ElseIf (pDatasetType = "MultiPolygon") {
        Set sqlType = "VARCHAR"
    } ElseIf (pDatasetType = "Location") {
        Set sqlType = "VARCHAR"
    } ElseIf (pDatasetType = "URL") {
        Set sqlType = "VARCHAR"
    } ElseIf (pDatasetType = "Calendar date") {
        Set sqlType = "DATETIME"
    } ElseIf (pDatasetType = "Fixed Timestamp") {
        Set sqlType = "DATETIME"
    } ElseIf (pDatasetType = "Floating Timestamp") {
        Set sqlType = "DATETIME"
    }
    Return sqlType
}
*/
Method FixCsvHeader1()
{
    Set csvDel = $Case(..DownloadInfo.CsvDel, "":..DefaultCsvDel, :..DownloadInfo.CsvDel)
    Set csvHeader = ""
    Set headerLength = 0

    // analyze the csv header using info in dataset catalog
    Set stream = ##class(%Stream.FileCharacter).%New()
    $$$TOE(st, stream.LinkToFile(..DownloadInfo.fileName))
    While 'stream.AtEnd {
        Set line = stream.ReadLine()
        Set line = ..FixColName(line)
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

Method FixColName(pColName As %String) As %String
{
    // insert here all kind of rule for fixing col name translation to IRIS class properties...
    Set pColName = $Translate(pColName, "()", "")   // remove brackets
    Return pColName
}

Method GetPackageName(pDatasetParams As %DynamicObject) As %String
{
    Set packageName = pDatasetParams.packageName
    If (packageName = "") {
        Set packageName = ..DefaultPackage
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

}
