$env:PATH = $env:PATH + ';C:\Program Files\Conan\conan\'
$env:PATH = $env:PATH + ';C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\'
$env:PATH = $env:PATH + ';C:\vcpkg\vcpkg-master\downloads\tools\powershell-core-7.2.11-windows\'
$env:PATH = $env:PATH + ';C:\Users\ContainerAdministrator\AppData\Local\Programs\Python\Python311'
$env:PATH = $env:PATH + ';C:\Program Files\7-Zip\'
$env:PATH -split ';'

Start-Process python.exe -ArgumentList "-m pip install pyyaml pysmb"


if ( !($Env:PACKAGE_DIRECTORY | Test-Path) ){
	New-Item $Env:PACKAGE_DIRECTORY -ItemType Directory
}

if (![string]::IsNullOrEmpty($Env:GITSSHKEY)){
    git config --global core.sshCommand "ssh -i c:$Env:HOME_DIRECTORY/.ssh/id_rsa -F /dev/null -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
    git clone git@git.com:project1/bld-helpers.git    
}
else{
     $creds="$Env:GIT_USERNAME`:$Env:GIT_PASSWORD"
     git config --global http.sslVerify "false"
     git clone "https://$creds@git.com/project1/bld-helpers.git"
}

cd $Env:HOME_DIRECTORY/bld-helpers

&./conan_set.ps1

cd $Env:HOME_DIRECTORY/$Env:NAME_PROJECT
conan create . 

Write-Host "variable for public: $Env:PUBLISH"

if ($Env:PUBLISH -eq 'true'){
    Write-Host "variable for public: $Env:PUBLISH"
    #archive artifacts
    cd $Env:PACKAGE_DIRECTORY
    7z a -t7z "$Env:NAME_PROJECT-$Env:TYPE_BUILD-vc19-$Env:VERSION_PROJECT.7z" *.*
    cd $Env:HOME_DIRECTORY/bld-helpers
    &./bld-smb.ps1
}
