/// Description
Class dc.dataset.importer.service.CredentialsService Extends %RegisteredObject
{

Method SaveCredentials(pCredentialKey As %String, pUsername As %String, pPassword As %String)
{
    Set ^dc.dataset.importer.credentials(pCredentialKey) = {
        "username": (pUsername),
        "password": ($SYSTEM.Encryption.AESCBCEncrypt(pPassword, "", ""))
    }.%ToJSON()
}

Method DeleteCredentials(pCredentialKey As %String)
{
    Kill ^dc.dataset.importer.credentials(pCredentialKey)
}

Method GetCredentials(pCredentialKey As %String) As %DynamicObject
{
    Set credentials = $G(^dc.dataset.importer.credentials(pCredentialKey))
    If (credentials = "") {
        Throw ##class(%Exception.General).%New("Kaggle credentials not found")
    }
    Set credentials = {}.%FromJSON(credentials)
    Set credentials.password = $SYSTEM.Encryption.AESCBCDecrypt(credentials.password, "", "")
    Return credentials
}

}
