/// Description
Class dc.dataset.importer.service.AbstractImporterService Extends %RegisteredObject
{

Parameter Provider;

Property DefaultPackage As %String [ InitialExpression = "dc.dataset.imported" ];

Property HttpUtil As dc.dataset.importer.service.HttpUtil;

Property DownloadInfo As %DynamicObject [ Private ];

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

Method InstallDataset(pDatasetParams As %DynamicObject) As %DynamicObject [ Abstract ]
{
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

Method GetPackageName(pDatasetParams As %DynamicObject) As %String
{
    Set packageName = pDatasetParams.packageName
    If (packageName = "") {
        Set packageName = ..DefaultPackage
    }
    Return packageName
}

Method GetClassName(pDatasetParams As %DynamicObject) As %String [ Abstract ]
{
}

Method GetClassFQN(pPackageName As %String, pClassName As %String) As %String
{
    Set fqn = pPackageName_"."_pClassName
    Set fqn = $Extract(fqn, 1, 220)
    Return fqn
}

}
