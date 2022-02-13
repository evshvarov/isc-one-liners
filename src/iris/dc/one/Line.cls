/// contains useful one-liners for ObjectScript development
Class dc.one.Line
{

ClassMethod CreateSSL()
{
    n $namespace
    set $namespace="%SYS", name="DefaultSSL" do:'##class(Security.SSLConfigs).Exists(name) ##class(Security.SSLConfigs).Create(name)
}

/// install ZPM. You can call this, or copy the line
/// courtesy Eduard Lebedyuk
ClassMethod InstallZPM()
{
    s r=##class(%Net.HttpRequest).%New(),r.Server="pm.community.intersystems.com",r.SSLConfiguration="ISC.FeatureTracker.SSL.Config" d r.Get("/packages/zpm/latest/installer"),$system.OBJ.LoadStream(r.HttpResponse.Data,"c")
}

/// Enable IRIS BI in an Namespace
/// Create %All Namespace
/// , but don't forget to return to the initial namespace
ClassMethod CreatePersentAll() As %Status
{
    Set sc = $$$OK
    n $namespace
    set $namespace="%SYS",P("Globals")="%DEFAULTDB",sc=##class(Config.Namespaces).Create("%All",.P)
    Return sc
}

/// enable IRIS BI in a namespace
ClassMethod EnableIRISBI()
{
    // enable in a given namespace
    do EnableDeepSee^%SYS.cspServer("/csp/namespace/") 
    // enable in a current namespace
    do EnableDeepSee^%SYS.cspServer("/csp/"_$$$LOWER($namespace))
}

/// Unexpire passwords to simplify dev mode. Don't use in Production 
ClassMethod UnExpireUserPasswords() As %Status
{
    zn "%SYS" Do ##class(Security.Users).UnExpireUserPasswords("*")
}

/// Export Global in the repo (docker runtime)
ClassMethod ExportGlobal() As %Status
{
    d $System.OBJ.Export("GlobalD.GBL","/irisrun/repo/src/gbl/GlobalD.xml")
}

}
