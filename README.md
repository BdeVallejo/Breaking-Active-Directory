# Introduction

Following [John Hammond´s amazing tutorial series](https://www.youtube.com/watch?v=59VqS6wMn6w) I´ve created a script in Powershell to users and groups in a Domain Controller. 

I´ve customized the code a little bit for various reasons. The main reason is that being spanish, many names and last names have more than one word, some special characters and diacritics. I have added some functions to the code that deal with that. 

On the other hand, in his tutorial John is changing the password policy so that the Domain Controller accepts weak passwords. I wanted to play in a more realistic scenario so I haven´t included that. It goes without saying that this makes the Active Directory a bit harder to break.

# Create a list of users

First of all we need to create a list of users. I have chose a list of popular spanish names and surnames and a list of passwords from Daniel Miessler´s [SecList repo](https://github.com/danielmiessler/SecLists). The ones included in the famous `Rockyou` dictionary do not meet Windows´s requirements so I have chosen some from Passwords/Permutations.

So, open a Powershell console:

```
git clone https://github.com/BdeVallejo/Breaking-Active-Directory
cd Breaking-Active-Directory
./random_schema.ps1
```

And then save the json file with a name of your choice. Let´s say users.json for instance.

# Add the users in the Domain Controller

You need to be able to connect to a Domain Controller from the computer that you are working on ( that I will call Management Client from now on ). The reason behind is that you can then copy the appropriate files to the Domain Controller without having to install anything on that machine.

So, the recommended way is:

- Open Powershell as Administrator on the Management Client.
- Get the IP Address of the Domain Controller ( as simple as "ipconfig" in a terminal in the Domain Controller )
- Create a variable ( in this instance, `$dc`) in the Powershell terminal on the Management Client. You will see why in a few moments:
```
$dc = New-PSSession <DOMAINCONTROLLERIP> -Credential (Get-Crendential)`
```

- A pop-up window will be displayed. Enter the Administrator username and password for the Domain Controller. You should be connected to the Domain Controller.

- Type the following:
```
Set-ExecutionPolicy RemoteSigned
```
- A warning message saying "The execution policy helps protect...". Just type "Y".

- Copy the files to the Domain Contoller (in this instance users.json or whichever name you´ve chosen for the json file and add_users.ps1). 
```
cp .\users.json -ToSession $dc C:\Windows\Tasks
cp .\add_users.ps1 -ToSession $dc C:\Windows\Tasks
```

We´re almost there! You just need to move to your Domain Controller and try this out in the Powershell console:

```
cd C:\Windows\Tasks
.\add_users.ps1
``` 

A message asking for a JSON file will appear. Select the json file with the users and that should be it!
```
./users.json
```





