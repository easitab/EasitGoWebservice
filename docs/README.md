# Docs

## Install

[HOW-TO-Install](https://github.com/easitab/EasitGoWebservice/blob/development/docs/HOW-TO-Install.md)

## Local configuration file

If you would like to use a local configuration file to store your, or your system rather, url and apikey this is now possible.<br>
Save a file called *easitWS.properties* in the home folder of the user running the cmdlet or script using the cmdlet.<br>
The contents of that file should look as shown below but with your values rather then just "".

```json
{
    "url":"",
    "apikey":""
}
```

- If no value for *url* is provided via cmdlet parameter nor the configuration file the cmdlet called will default to "localhost".
- If no value for *apikey* is provided via cmdlet parameter nor the configuration file the cmdlet provide a warning and stop.

## Report an issue or bug

[HOW-TO-ReportAnIssueOrBug](https://github.com/easitab/EasitGoWebservice/blob/development/docs/HOW-TO-ReportAnIssueOrBug.md)

## Help

If you need help with anything regarding the EasitGoWebservice module please open an issue or send an email to githubATeasit.com.

If you would like to help us improve these docs or contribute to them open an issue or pull request.