/// Description
Class dc.dataset.importer.service.AbstractImporterService Extends %RegisteredObject
{

Parameter Provider;

Property DefaultPackage As %String [ InitialExpression = "dc.dataset.imported" ];

Property HttpUtil As dc.dataset.importer.service.HttpUtil;

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

}
