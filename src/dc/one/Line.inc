ROUTINE dc.one.Line [Type=INC]

#define onessl x "n $namespace set $namespace=""%SYS"", name=""DefaultSSL"" do:'##class(Security.SSLConfigs).Exists(name) ##class(Security.SSLConfigs).Create(name)"
#define onezpm s r=##class(%Net.HttpRequest).%New(),r.Server="pm.community.intersystems.com",r.SSLConfiguration="ISC.FeatureTracker.SSL.Config" d r.Get("/packages/zpm/latest/installer"),$system.OBJ.LoadStream(r.HttpResponse.Data,"c")
#define onepercentall x "n $namespace set $namespace=""%SYS"",P(""Globals"")=""%DEFAULTDB"",sc=##class(Config.Namespaces).Create(""%All"",.P)"
#define oneirisbion(%ns) do EnableDeepSee^%SYS.cspServer("/csp/"_$$$LOWER(%ns)_"/")
#define onedeepseeon(%namespace) do EnableDeepSee^%SYS.cspServer("/csp/"_$$$LOWER(%namespace)_"/")
#define oneendlesspass X "n $namespace set $namespace=""%SYS"" Do ##class(Security.Users).UnExpireUserPasswords(""*"")"
#define oneexportglobal(%global,%folder) d $System.OBJ.Export(%global_".GBL",%folder_%global_".xml")
#define onekillvar kill  zremove
#define changealladminpass(%password) x "new $namespace,s,p,n set $namespace=""%SYS"",p(""Password"")="_%password_" for n=""admin"",""cspsystem"",""iam"",""superuser"",""unknownuser"",""_system"",""_ensemble"" set s=##class(Security.Users).Modify(n,.p)"

