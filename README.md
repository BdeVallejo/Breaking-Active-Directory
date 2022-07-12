# Introduction

Following [John Hammond´s amazing tutorial series](https://www.youtube.com/watch?v=59VqS6wMn6w) I´ve created a script in Powershell to users and groups in a Domain Controller. 

I´ve customized the code a little bit for various reasons. The main reason is that being spanish, many names and last names are two words. With John´s code that creates some issues.

# How it works

You need to be able to connect to a Domain Controller from a computer ( that I will call Management Client from now on ). The reason behind is that for instance you can clone this repository, edit it with Visual Studio or similar and then upload the appropriate files to the Domain Controller without having to install anything on that machine.

So, the recommended way is:

- Clone this repository on the Management Client.
- cd into it:
```
cd Breaking-Active-Directory
```
- Change the sample_schema.json with your own users.
- Open Powershell as Administrator on the Management Client.
- Get the IP Address of the Domain Controller ( as simple as "ipconfig" in a terminal in the Domain Controller )
- Create a variable ( in this instance, `$dc`) in the Powershell terminal on the Management Client. You will see why in a few moments:
```
$dc = New-PSSession <IPDELDOMAINCONTROLLER> -Credential (Get-Crendential)`
```

- A pop-up window will be displayed. Enter the Administrator username and password for the Domain Controller. You should be connected to the Domain Controller.

- Type the following:
```
Set-ExecutionPolicy RemoteSigned
```
- A warning message saying "The execution policy helps protect...". Just type "Y".

- Copy the files to the Domain Contoller
```
cp .\sample_schema.json -ToSession $dc C:\Windows\Tasks
cp .\add_users.ps1 -ToSession $dc C:\Windows\Tasks
```

We´re almost there! You just need to move to your Domain Controller and try this out in the Powershell console:

```
cd C:\Windows\Tasks
.\add_users.ps1
``` 

A message asking for a JSON file will appear. Select the json file with the users and that should be it!
```
./sample_schema.json
```



