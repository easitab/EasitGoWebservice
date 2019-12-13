# EasitPSHttpServer

A simple http server written in Powershell.

With this http server you can recieve exported objects from Easit GO and take action upon that object.
In its current configuration the server will use the cmdlet 'Start-Job' to run the powershell script
specified as identifier and if present in subfolder 'resources'.

Logs are written to pathtoserverscript/PShttpServer.log with the following syntax:
date time - Level - Message

Current parameters that the server accepts:
- "BindingUrl"
    URL that the server will listen for incomming requests on.
    Default value is 'http://+'
    Adminstrative permissions are required for a binding to network names or addresses.
    [+] takes all requests to the port regardless of name or ip, * only requests that no other listener answers

- "Port"
    Set listening port for http server.
    Default port is 9080.

- "Basedir"
    Set the folder to look for scripts to run.
    Default folder is pathtoserverscript/resources

## Support & Questions

Questions and issue can be sent to [githubATeasit](mailto:github@easit.com)
