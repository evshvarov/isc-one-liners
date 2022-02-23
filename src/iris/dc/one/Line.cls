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
    //n $namespace
    //set $namespace="%SYS",P("Globals")="%DEFAULTDB",sc=##class(Config.Namespaces).Create("%All",.P)
    x "n $namespace set $namespace=""%SYS"",P(""Globals"")=""%DEFAULTDB"",sc=##class(Config.Namespaces).Create(""%All"",.P)"
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
ClassMethod UnExpireUserPasswords()
{
    X "n $namespace set $namespace=""%SYS"" Do ##class(Security.Users).UnExpireUserPasswords(""*"")"
}

/// Export Global in the repo (docker runtime)
ClassMethod ExportGlobal()
{
    d $System.OBJ.Export("GlobalD.GBL","/irisrun/repo/src/gbl/GlobalD.xml")
}

/// turns off random global names for class storage strategy
ClassMethod TurnOffRandomGlobals() As %Status
{
    set sc=$SYSTEM.SQL.Util.SetOption("DDLUseExtentSet",0,.oldval)
    return sc
}

/// Make the storage structure for DDL created and UDL created classes similar
/// $lb("",col1,col2,,n)
/// it makes it cancelling Final clause in the Storage
ClassMethod UnifiedLBStorage() As %Status
{
    set sc=$SYSTEM.SQL.Util.SetOption("DDLFinal",0,.oldval)
    return sc
}

/// Change password for preset users
ClassMethod ChangePassword()
{
    x "new $namespace,s,p,n set $namespace=""%SYS"",p(""Password"")=""NewPass123"" for n=""admin"",""cspsystem"",""iam"",""superuser"",""unknownuser"",""_system"",""_ensemble"" set s=##class(Security.Users).Modify(n,.p)"
}
