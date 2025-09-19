# runR
runR is a simple multi language code runner that makes things simple, supports up to 16 languages!
# Linux and Windows support! 
(the powershell source is directly translated from bash so i dont guarantee that there will be no problems)!

### Dependencies
Arch linux / Manjaro

```bash
sudo pacman -S --needed - < dependencies.txt
```
Windows (REQUIRES [Chocolatey](https://chocolatey.org/ "Package manager for Windows")!)
<br>
[<img src="https://img.chocolatey.org/logos/chocolatey.svg" alt="Chocolatey Logo" width="100"/>](https://chocolatey.org/)
```ps1
Get-Content dependencies.txt | ForEach-Object { choco install $_ -y --ignore-checksums }
```
Or manually download each software like python etc.

# install
## How to install?
### linux:
### Use the installer script 
Which auto downloads the latest source for you and asks if you want to append the alias "j" to your shell config.
### Manually
Just download the given .sh file and alias it for best use.
## What are the supported shells for the installer?
fish shell
csh
zsh
bash

### windows
Place your powershell script somewhere like:
```ps1
C:\Scripts\r.ps1
```
Check if you have a profile file:
```ps1
$PROFILE
```
This usually points to something like:
```ps1
C:\Users\YourName\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
```
If it doesnt then create it:
```ps1
New-Item -Path $PROFILE -ItemType File -Force
```
Open this in some editor (the good old notepad)
```ps1
notepad $PROFILE
```
Add this line:
```ps1
Set-Alias r "C:\Scripts\r.ps1"
```
Allow running scripts:
```ps1
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```
Restart powershell
Good to go :D


# Why does this make life much easier?
### Case 1: you have only 1 type of supported file in a single project dir.

example structure (generated with tree command)
```bash
.
├── iusearchbtw.txt
├── Main.java
├── notmypasswords.csv
└── something.txt

1 directory, 4 files
```
What if i dont want to do the usual things?
I just type "r" in the terminal or the corresponding alias you have set for the script.
And it compiles your .java file in our case with javac and runs the .class file afterwards auto.


### Case 2: you have multiple type of supported files in your dir.


example structure (generated with tree command)
```bash
.
├── Main.java
├── notmypasswords.csv
├── something.txt
└── surprise.c

1 directory, 4 files
```
Okay lets say I wanna run that .c file.
You know the silly gcc has to run and then you gotta hassle with ./a.out thingy, you waste time.
just use "r surprise.c".
You might be asking what if its already compiled? Its gonna run the compiled code only, and re-compile only if the .c file is newer.
Similar case happens for other compiled langs.
How does it know which .out file is for what? For now it assumes a.out is the name for compiled code in case of cpp and c files. (I might be migrating to sourcefilename.c --> sourcefilename.out format later)




Supported lang list: can be found at supported_langs.txt



