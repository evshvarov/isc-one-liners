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

/// Read file. Sample run: if ##class(dc.one.Line).ReadFile("/irisdev/app/module.xml",.txt) write txt
/// by Sergey Mikhaylenko
ClassMethod ReadFile(filename="/irisdev/app/module.xml",ByREf txt) as %Status
{
	set f=##class(%File).%New(filename) if f.Open("RSU") {s txt=f.Read() w !,txt } else { w !,$System.Status.GetErrorText($g(%objlasterror)) quit $g(%objlasterror) } d f.%Close() quit $$$OK
}

/// Write to file. Sample run: write ##class(dc.one.Line).Write2File("d:\!\log.txt","do 1^%SS") 
/// by Sergey Mikhaylenko
ClassMethod Write2File(fn = "/tmp/log.txt", ByRef cmd) As %Status
{
	set:$g(fn)="" fn="/tmp/log.txt" open fn:("WNSK\UTF8\"):1 if $test { use fn xecute cmd close fn quit $$$OK } else { w !,$System.Status.GetErrorText($g(%objlasterror)) quit $g(%objlasterror) }
}

/// install ZPM with proxy. You can call this, or copy the line
/// modified Sergey Mikhaylenko
ClassMethod InstallZPMproxy()
{
	s r=##class(%Net.HttpRequest).%New(),proxy=$System.Util.GetEnviron("https_proxy") Do ##class(%Net.URLParser).Parse(proxy,.pr) s:$G(pr("host"))'="" r.ProxyHTTPS=1,r.ProxyTunnel=1,r.ProxyPort=pr("port"),r.ProxyServer=pr("host") s:$G(pr("username"))'=""&&($G(pr("password"))'="") r.ProxyAuthorization="Basic "_$system.Encryption.Base64Encode(pr("username")_":"_pr("password")) set r.Server="pm.community.intersystems.com",r.SSLConfiguration="ISC.FeatureTracker.SSL.Config" d r.Get("/packages/zpm/latest/installer"),$system.OBJ.LoadStream(r.HttpResponse.Data,"c")
}

/// install ZPM latest beta version. You can call this, or copy the line
/// modified Sergey Mikhaylenko
ClassMethod InstallZPMBeta()
{
	s r=##class(%Net.HttpRequest).%New(),proxy=$System.Util.GetEnviron("https_proxy") Do ##class(%Net.URLParser).Parse(proxy,.pr) s:$G(pr("host"))'="" r.ProxyHTTPS=1,r.ProxyTunnel=1,r.ProxyPort=pr("port"),r.ProxyServer=pr("host") s:$G(pr("username"))'=""&&($G(pr("password"))'="") r.ProxyAuthorization="Basic "_$system.Encryption.Base64Encode(pr("username")_":"_pr("password")) set r.Server="github.com",r.SSLConfiguration="ISC.FeatureTracker.SSL.Config" d r.Get("/intersystems-community/zpm/releases/download/v0.4.1-beta.12/zpm-0.4.1-beta.12.xml"),$system.OBJ.LoadStream(r.HttpResponse.Data,"c")
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

/// do ##class(dc.one.Line).passwordless() 
/// https://community.intersystems.com/post/passwordless-mode-dev-mode-iris
ClassMethod passwordless(app="/csp/sys") As %Status
{
  X "n $namespace set $namespace=""%SYS"" set par(""AutheEnabled"")=64,tSC=##class(Security.Applications).Modify($g(app,""/csp/sys""),.par),role=""%All"",tSC=##class(Security.Users).AddRoles(""UnknownUser"",.role,1) "
  quit $$$OK
}

/// Fastest way to create a namespace with two databases for code and globals
/// do ##class(dc.one.Line).createdatabase("testdb") 
ClassMethod createdatabase(name) As %Library.ResultSet
{
  quit $SYSTEM.SQL.Execute("CREATE DATABASE "_name)
}

}
