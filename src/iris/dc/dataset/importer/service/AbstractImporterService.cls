/// Description
Class dc.dataset.importer.service.AbstractImporterService Extends %RegisteredObject
{

Parameter Provider;

Property DefaultPackage As %String [ InitialExpression = "dc.dataset.imported" ];

Property HttpUtil As dc.dataset.importer.service.HttpUtil;

Property DownloadInfo As %DynamicObject;

Property DatasetParams As %DynamicObject;

Property ProgressInfoKey As %String;

Method %OnNew(pHttpUtilInstance As dc.dataset.importer.service.HttpUtil = "") As %Status
{
    If (pHttpUtilInstance = "") {
        Set ..HttpUtil = ##class(dc.dataset.importer.service.HttpUtil).%New()
    } Else {
        Set ..HttpUtil = pHttpUtilInstance
    }
    Set ..ProgressInfoKey = $System.Util.CreateGUID()
    Return $$$OK
}

Method SearchDataset(pParams As %DynamicObject) As %DynamicObject [ Abstract ]
{
}

Method GetDatasetDetails(pParams As %DynamicObject) As %DynamicObject [ Abstract ]
{
}

Method InstallDataset(pDatasetParams As %DynamicObject)
{
    Do ..SetProgressInfo(..ProgressInfoKey, {
        "status":"started", "data":null
    })
    Try {
        Set ..DatasetParams = pDatasetParams
        If ('..HasResult()) {
            Throw ##class(%Exception.General).%New("Dataset not found.")
        }
        Do ..ValidateLicense()
        Set response = ..ProcessInstallation()
        Do ..SetProgressInfo(..ProgressInfoKey, {
            "status":"success", "data":(response)
        })
        Job ..ClearProgressInfo(..ProgressInfoKey, 20)
    } Catch(e) {
        Do ..SetProgressInfo(..ProgressInfoKey, {
            "status":"error", "data": (e.DisplayString())
        })
    }
}

Method HasResult() As %Boolean [ Abstract ]
{
}

Method ProcessInstallation() As %DynamicObject [ Abstract ]
{
}

Method GetDatasetLicense() As %String [ Abstract ]
{
}

Method ValidateLicense()
{
    Set license = ..GetDatasetLicense()
    If (license = "") {
        Throw ##class(%Exception.General).%New("The dataset must specify a license.")
    }
}

Method FixCsvHeader() [ Private ]
{
    Set csvHeader = ""
    Set headerLength = 0

    // analyze the csv header looking for break lines in header
    Set stream = ##class(%Stream.FileCharacter).%New()
    $$$TOE(st, stream.LinkToFile(..DownloadInfo.fileName))
    While 'stream.AtEnd {
        Set line = stream.ReadLine()
        Set csvHeader = csvHeader_line
        Set headerLength = headerLength + $Length(line)

        Set hasBreaklineCols = ($Length(csvHeader, """") # 2) = 0
        Quit:('hasBreaklineCols)
    }
    Kill stream

    // fix the CSV file header
    Set file = ##class(%File).%New(..DownloadInfo.fileName)
    $$$TOE(st, file.Open("W"))
    Set fixedCsvHeader = ..FixColName(csvHeader)
    Do file.Write(fixedCsvHeader)
    #; Set actualLength = $Length(csvHeader)
    Set actualLength = $Length(fixedCsvHeader) + 1
    If (actualLength '= headerLength) {
        // fills the "removed" chars with space
        For line = actualLength:1:headerLength {
            Do file.Write(" ")
        }
    }
    Do file.Close()
}

Method FixColName(pColName As %String) As %String [ Private ]
{
    // insert here all kind of rule for fixing col name translation to IRIS class properties...
    Set pColName = $Translate(pColName, " !@#$%¨&*()-_=+[]{}~^.:/?\|'ªº", "")

    // ugly hack to ensure that col names are unique
    // todo: create a better approach...
    Set lst = $LFS(pColName, ",")
    Set len = $LL(lst)
    For i = 1:1:len {
        Set idx = $TR($Justify(i, 2), " ", "0")
        Set colName = $Extract($LG(lst, i), 1, * - 2)
        Set $List(lst, i) = colName_idx
    }
    Set pColName = $LTS(lst, ",")

    Return pColName
}

Method GetPackageName() As %String
{
    Set packageName = ..DatasetParams.packageName
    If (packageName = "") {
        Set packageName = ..DefaultPackage
    }
    Return packageName
}

Method GetClassName() As %String [ Abstract ]
{
}

Method GetClassFQN(pPackageName As %String, pClassName As %String) As %String
{
    Set fqn = pPackageName_"."_pClassName
    Set fqn = $Extract(fqn, 1, 220)
    Return fqn
}

Method FixClassName(pClassName As %String) As %String
{
    Set className = pClassName
    Set className = $ZCVT("DS "_className, "W") // converts to CamelCase
    Set className = $Translate(className, " !@#$%¨&*()-_=+[]{}~^,.;:/?\|'""ªº", "")
    Set className = $Extract(className, 1, 60) // classes name must have length up to 60
    Return className
}

ClassMethod SetProgressInfo(pKey As %String, pMsg As %DynamicObject)
{
    Set ^ProgressInfo(pKey, $I(^ProgressInfo(pKey))) = pMsg.%ToJSON()
}

ClassMethod GetProgressInfo(pKey As %String, pSubKey As %Integer = "") As %DynamicObject
{
    If (pSubKey = "") {
        Set pSubKey = ^ProgressInfo(pKey)
    }
    Return {}.%FromJSON($G(^ProgressInfo(pKey, pSubKey), "{}"))
}

ClassMethod ClearProgressInfo(pKey As %String, pTimeoutSeconds As %Integer = "")
{
    If (pTimeoutSeconds '= "") {
        Hang pTimeoutSeconds
    }
    Kill ^ProgressInfo(pKey)
}

}
