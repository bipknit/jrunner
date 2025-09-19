# JRUNNER
jrunner is a simple code runner that makes things simple, supports up to 15 languages!

### Dependencies install cmd
Arch linux / Manjaro

```bash
sudo pacman -S --needed - < dependencies.txt
```

# installer
## How to install?
### Use the installer script 
Which auto downloads the latest source for you and asks if you want to append the alias "j" to your shell config.
### Manually
Just download the given .sh file and alias it for best use.
## What are the supported shells for the installer?
fish shell
csh
zsh
bash


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
I just type "j" in the terminal or the corresponding alias you have set for the script.
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
just use "j surprise.c".
You might be asking what if its already compiled? Its gonna run the compiled code only, and re-compile only if the .c file is newer.
Similar case happens for other compiled langs.
How does it know which .out file is for what? For now it assumes a.out is the name for compiled code in case of cpp and c files. (I might be migrating to sourcefilename.c --> sourcefilename.out format later)




Supported lang list: can be found at supported_langs.txt



