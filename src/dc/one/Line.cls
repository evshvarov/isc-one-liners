Include dc.one.Line

/// contains useful one-liners for ObjectScript development
Class dc.one.Line
{

ClassMethod CreateSSL()
{
    
    $$$onessl
    x "n $namespace set $namespace=""%SYS"", name=""DefaultSSL"" do:'##class(Security.SSLConfigs).Exists(name) ##class(Security.SSLConfigs).Create(name)"
}

/// install ZPM. You can call this, or copy the line
/// courtesy Eduard Lebedyuk
ClassMethod InstallZPM()
{
    $$$onezpm
    s r=##class(%Net.HttpRequest).%New(),r.Server="pm.community.intersystems.com",r.SSLConfiguration="ISC.FeatureTracker.SSL.Config" d r.Get("/packages/zpm/latest/installer"),$system.OBJ.LoadStream(r.HttpResponse.Data,"c")
}

/// install ZPM with proxy. You can call this, or copy the line
/// modified Sergey Mikhaylenko
ClassMethod InstallZPMproxy()
{
	s r=##class(%Net.HttpRequest).%New(),proxy=$System.Util.GetEnviron("https_proxy") Do ##class(%Net.URLParser).Parse(proxy,.pr) s:$G(pr("host"))'="" r.ProxyHTTPS=1,r.ProxyTunnel=1,r.ProxyPort=pr("port"),r.ProxyServer=pr("host") s:$G(pr("username"))'=""&&($G(pr("password"))'="") r.ProxyAuthorization="Basic "_$system.Encryption.Base64Encode(pr("username")_":"_pr("password")) set r.Server="pm.community.intersystems.com",r.SSLConfiguration="ISC.FeatureTracker.SSL.Config" d r.Get("/packages/zpm/latest/installer"),$system.OBJ.LoadStream(r.HttpResponse.Data,"c")
}

/// install ZPM latest beta version. You can call this, or copy the line
/// modified Sergey Mikhaylenko
ClassMethod InstallZPMBetta()
{
	s r=##class(%Net.HttpRequest).%New(),proxy=$System.Util.GetEnviron("https_proxy") Do ##class(%Net.URLParser).Parse(proxy,.pr) s:$G(pr("host"))'="" r.ProxyHTTPS=1,r.ProxyTunnel=1,r.ProxyPort=pr("port"),r.ProxyServer=pr("host") s:$G(pr("username"))'=""&&($G(pr("password"))'="") r.ProxyAuthorization="Basic "_$system.Encryption.Base64Encode(pr("username")_":"_pr("password")) set r.Server="github.com",r.SSLConfiguration="ISC.FeatureTracker.SSL.Config" d r.Get("/intersystems-community/zpm/releases/download/v0.4.1-beta.9/zpm-0.4.1-beta.9.xml"),$system.OBJ.LoadStream(r.HttpResponse.Data,"c")
}

/// Enable IRIS BI in an Namespace
/// Create %All Namespace
/// , but don't forget to return to the initial namespace
ClassMethod CreatePersentAll() As %Status
{
    Set sc = $$$OK
    
    //n $namespace
    //set $namespace="%SYS",P("Globals")="%DEFAULTDB",sc=##class(Config.Namespaces).Create("%All",.P)
    $$$onepercentall
    x "n $namespace set $namespace=""%SYS"",P(""Globals"")=""%DEFAULTDB"",sc=##class(Config.Namespaces).Create(""%All"",.P)"
    Return sc
}

/// enable IRIS BI in a namespace
ClassMethod EnableIRISBI()
{
    
    // enable in a given namespace
    do EnableDeepSee^%SYS.cspServer("/csp/namespace/") 
    // enable in a current namespace
    $$$oneenableirisbi($namespace)
    do EnableDeepSee^%SYS.cspServer("/csp/"_$$$LOWER($namespace))
}

/// Unexpire passwords to simplify dev mode. Don't use in Production 
ClassMethod UnExpireUserPasswords()
{
    $$$oneendlesspass
    X "n $namespace set $namespace=""%SYS"" Do ##class(Security.Users).UnExpireUserPasswords(""*"")"
}

/// Export Global in the repo (docker runtime)
ClassMethod ExportGlobal()
{
    $$$oneexportglobal("GlobalD","/irisrun/repo/src/gbl/") 
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
ClassMethod ChangeAdminPassword() As %Status
{
   
    $$$changealladminpass("pass")
    x "new $namespace,s,p,n set $namespace=""%SYS"",p(""Password"")=""NewPass123"" for n=""admin"",""cspsystem"",""iam"",""superuser"",""unknownuser"",""_system"",""_ensemble"" set s=##class(Security.Users).Modify(n,.p)"
    quit $$$OK
}

}
