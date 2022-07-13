param( 
    [Parameter(Mandatory=$true)] $OutputJSONFile, 
    [int]$num_users,
    [int]$num_groups
)

# This function removes diacritics and special characters like "ñ" (quite common in spanish names)
function Remove-DiacriticsAndSpaces
{
    Param(
        [String]$inputString
    )
    $replaceTable = @{"ß"="ss";"à"="a";"á"="a";"â"="a";"ã"="a";"ä"="a";"å"="a";"æ"="ae";"ç"="c";"è"="e";"é"="e";"ê"="e";"ë"="e";"ì"="i";"í"="i";"î"="i";"ï"="i";"ð"="d";"ñ"="n";"ò"="o";"ó"="o";"ô"="o";"õ"="o";"ö"="o";"ø"="o";"ù"="u";"ú"="u";"û"="u";"ü"="u";"ý"="y";"þ"="p";"ÿ"="y"}

    foreach($key in $replaceTable.Keys){
        $inputString = $inputString -Replace($key,$replaceTable.$key)
    }
    $inputString = $inputString -replace '[^a-zA-Z0-9]', ''
    return $inputString
}

    
# We cast it as Arraylist so that we can remove items from the list when we do our random list

$group_names = [System.Collections.ArrayList](Get-Content "data/group_names.txt")
$first_names = [System.Collections.ArrayList](Get-Content "data/first_names.txt")
$last_names = [System.Collections.ArrayList](Get-Content "data/last_names.txt")
$passwords = [System.Collections.ArrayList](Get-Content "data/passwords.txt")


$groups = @()
$users = @()

# Default number of users set to 5 (if not set)
if ( $num_users -eq 0 ){
    $num_users = 5
}

# Default number of groups set to 5 (if not set)
if ( $num_groups -eq 0 ){
    $num_groups = 5
}


for( $i = 0; $i -lt $num_groups; $i++ ) {
    $group_name = (Get-Random -InputObject $group_names)
    $group = @{ "name" = "$group_name" }
    $groups += $group
    # We remove them from the list so that we keep unique users and groups
    $group_names.Remove($group_name)
}

for( $i = 0; $i -lt $num_users; $i++ ) {
    $first_name = (Get-Random -InputObject $first_names)
    $first_name = Remove-DiacriticsAndSpaces -inputString "$first_name"
    $last_name = (Get-Random -InputObject $last_names)
    $last_name= Remove-DiacriticsAndSpaces -inputString "$last_name" 
    $password = (Get-Random -InputObject $passwords)

    $new_user = @{
        "first_name"=$first_name.ToLower()
        "last_name"=$last_name.ToLower()
        "password"="$password"
        "groups"= (Get-Random -InputObject $groups).name
    }

    $users += $new_user
    $first_names.Remove($first_name)
    $last_names.Remove($last_name)
    $passwords.Remove($password)
}

echo @{
    "domain"="xyz.com"
    "groups"=$groups
    "users"=$users
} | ConvertTo-Json | Out-File $OutputJSONFile

