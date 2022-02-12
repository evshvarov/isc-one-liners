/// contains useful one-liners for ObjectScript development
Class dc.one.Line
{



ClassMethod CreateSSL()
{
    n $namespace
    set $namespace="%SYS", name="DefaultSSL" do:'##class(Security.SSLConfigs).Exists(name) ##class(Security.SSLConfigs).Create(name)
}

/// install ZPM. You can call this, or copy the line, but don't forget to return to the initial namespace
ClassMethod InstallZPM() 
{
    n $namespace
    set $namespace="%SYS" do ##class(Security.SSLConfigs).Create("ssl") set r=##class(%Net.HttpRequest).%New(),r.Server="pm.community.intersystems.com",r.SSLConfiguration="ssl" do r.Get("/packages/zpm/latest/installer"),$system.OBJ.LoadStream(r.HttpResponse.Data,"c")
}

/// Enable IRIS BI in an Namespace

/// Create %All Namespace
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
    do EnableDeepSee^%SYS.cspServer("/csp/namespace/")
}



}
