/// Description
Class dc.dataset.importer.service.AbstractImporterService Extends %RegisteredObject
{

Parameter Provider;

Property DefaultPackage As %String [ InitialExpression = "dc.dataset.imported" ];

Property HttpUtil As dc.dataset.importer.service.HttpUtil;

Property DownloadInfo As %DynamicObject;

Property DatasetParams As %DynamicObject;

Method %OnNew(pHttpUtilInstance As dc.dataset.importer.service.HttpUtil = "") As %Status
{
    If (pHttpUtilInstance = "") {
        Set ..HttpUtil = ##class(dc.dataset.importer.service.HttpUtil).%New()
    } Else {
        Set ..HttpUtil = pHttpUtilInstance
    }
    Return $$$OK
}

Method SearchDataset(pParams As %DynamicObject) As %DynamicObject [ Abstract ]
{
}

Method InstallDataset(pDatasetParams As %DynamicObject) As %DynamicObject
{
    Set ..DatasetParams = pDatasetParams
    If ('..HasResult()) {
        Throw ##class(%Exception.General).%New("Dataset not found.")
    }
    Do ..ValidateLicense()
    Set response = ..ProcessInstallation()
    Return response
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
    Set pColName = $Translate(pColName, "()", "")   // remove brackets
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
        #; Set className = $ZCVT("DS "_className, "W") // converts to CamelCase
        #; Set className = $TR(className, " -_", "") // remove non-valid chars
        #; Set className = $Extract(className, 1, 60) // classes name must have length up to 60
    Set className = $ZCVT("DS "_className, "W") // converts to CamelCase
    Set className = $Translate(className, " !@#$%¨&*()-_=+[]{}~^,.;:/?\|'""ªº", "")
    Set className = $Extract(className, 1, 60) // classes name must have length up to 60
    Return className
}

}
