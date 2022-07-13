param([Parameter(Mandatory=$true)]  $JSONFile)

function CreateADGroup(){
    param( [Parameter(Mandatory=$true)] $groupObject )

    $name = $groupObject.name
    New-ADGroup -name $name -GroupScope Global
}

function RemoveADGroup(){
    param( [Parameter(Mandatory=$true)] $groupObject )
    $name = $groupObject.name
    Remove-ADGroup  -Identity $name -Confirm:$False
}

function RemoveADUser(){
    param( [Parameter(Mandatory=$true)] $userObject )

    $firstname = $userObject.first_name.ToLower();
    $lastname = $userObject.last_name.ToLower();
    $fullname = $firstname + " " + $lastname;
    $username = ($firstname[0] + $lastname  -replace " ","")
    $SamAccountName = $username
    Remove-ADUser -Identity $SamAccountName -Confirm:$False
}

function CreateADUser(){
    param([Parameter(Mandatory=$true)]  $userObject)

    #   Grab name and password from json file
    $firstname = $userObject.first_name.ToLower();
    $lastname = $userObject.last_name.ToLower();
    $fullname = $firstname + " " + $lastname;

    #   For testing purposes we set the password in the json file. We could as well use something like $password = ([System.Web.Security.Membership]::GeneratePassword(12,2))
    $password = $userObject.password;

    #   Create username (name.lastname) and then use the same principle for samaccountname and principalname.
    $username = ($firstname[0] + $lastname  -replace " ","")
    $PrincipalName = $username;
    $SamAccountName = $username

    # Create the AD user object
    New-ADUser -Name $fullname -GivenName $firstname -Surname $lastname -SamAccountName $SamAccountName -UserPrincipalName $PrincipalName@$Global:Domain -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -PassThru | Enable-ADAccount

    # Add the user to his/her group, if the group exists
    foreach($group_name in $userObject.groups) {

        try {
            Get-ADGroup -Identity "$group_name"
            Add-ADGroupMember -Identity $group_name -Members $username
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
        {
            Write-Warning "User $username was not added to group $group_name because it does not exist"
        }
    }

}
#   Read the json file with our users
$json = (Get-Content $JSONFile | ConvertFrom-Json);

#   Get the domain from the json file
$Global:Domain = $json.domain;

foreach ( $group in $json.groups ) {
    CreateADGroup $group
}

foreach ( $user in $json.users ) {
    CreateADUser $user
}