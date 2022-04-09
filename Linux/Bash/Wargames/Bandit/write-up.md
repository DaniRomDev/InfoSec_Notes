# Wargames - Bandit
Write up for the levels of [bandit wargame](https://overthewire.org/wargames/bandit) follow along with [this youtube tutorial from s4vitar](https://www.youtube.com/watch?v=RUorAzaDftg) 

# Level 1
The password for the next level is stored in a file called **-** located in the home directory

This is a tricky one because if you try to run `cat -` the terminal get stuck, there are multiple ways to read this file with special name as I show here:
```bash
cat ./- # Defining the start of the path
cat /home/<youruser>/- or cat ~/- # Home route
cat ~/* # Using the asterisk as criteria for find any file inside user directory
# With $() we can run commands and get the output in this case from 'pwd'
cat $(pwd)/- # This translates into cat /home/bandit1/-
```

# Level 2
The password for the next level is stored in a file called spaces in this filename located in the home directory

The problem here is that the file name is written with spaces like 'spaces in this filename'
If we run the cat command like this `cat spaces in this filename` we come up with this error on our terminal:
```bash
cat: spaces: No such file or directory
cat: in: No such file or directory
cat: this: No such file or directory
cat: filename: No such file or director

# Is trying to read as a separate files
```
The power of tabulation is strong here, just type the cat command and initial characters for the file and press tab to automatically complete the filename and escape special characters:
```bash
cat sp # press Tab 
cat spaces\ in\ this\ filename
# In this case is scaping whitespace characters so now the command can read the file as one
```
We have alternatives like playing with wildcard as we did in the level 1:
```bash
cat sp* 
cat *ame # All the files that ends with 'ame'
cat *this* # Files with word 'this' in between
cat ~/*

```
# Level 3
The password for the next level is stored in a hidden file in the inhere directory.

This is a simple one because the ls command have an option -a that allow us to see hidden directories/files

```bash
ls -a ./inhere # List all inside the folder included hidden files
# So now we can open the hidden file with cat as we did in last levels
cat ./inhere/.hidden
```
We can try to use a new command called `find` and see if we can also access the hidden file:
```bash
find . -type f # Find only files and not directories
# OUTPUT
./inhere/.hidden
./.bashrc
./.profile
./.bash_logout
```
A little more advanced would be to chain with `xargs` the output of `find` to open the file in one command. `xargs` can be used when you need to take the output from one command and use it as an argument to another. More information on [this stack overflow thread](https://stackoverflow.com/questions/35589179/when-to-use-xargs-when-piping
)

```bash
#The output of find is ./inhere/.hidden so we can pass this as argument to cat
find . -name .hidden -type f | xargs cat
```
# Level 4
The password for the next level is stored in the only human-readable file in the inhere directory. Tip: if your terminal is messed up, try the “reset” command.

When we run a simple ls command we can see a bunch of files without too much information if it's human readable or not:
```bash
ls -l # Long listing format (permissions, size, date...)
total 40K
-rw-r----- 1 bandit5 bandit4 33 May  7  2020 -file00
-rw-r----- 1 bandit5 bandit4 33 May  7  2020 -file01
-rw-r----- 1 bandit5 bandit4 33 May  7  2020 -file02
-rw-r----- 1 bandit5 bandit4 33 May  7  2020 -file03
-rw-r----- 1 bandit5 bandit4 33 May  7  2020 -file04
-rw-r----- 1 bandit5 bandit4 33 May  7  2020 -file05
-rw-r----- 1 bandit5 bandit4 33 May  7  2020 -file06
-rw-r----- 1 bandit5 bandit4 33 May  7  2020 -file07
-rw-r----- 1 bandit5 bandit4 33 May  7  2020 -file08
-rw-r----- 1 bandit5 bandit4 33 May  7  2020 -file0
```

Another tool to add in our repertoire is `file`that have the funcionality of displaying to us the information of the file, so if we combine this with the power of `xargs`we learned on last level we could come up with this:

```bash
find ./inhere -type f | xargs file # Apply file command on each file found from 'find'

./inhere/-file01: data
./inhere/-file00: data
./inhere/-file06: data
./inhere/-file03: data
./inhere/-file05: data
./inhere/-file08: data
./inhere/-file04: data
./inhere/-file07: ASCII text # Seems that this is the human readable one
./inhere/-file02: data
./inhere/-file09: data

# Next step should be
cat inhere/-file07
```
Now we know the filename that is human readable we can combine this into one command:
```bash
find ./inhere/ -type f -name -file07 | xargs cat
```

# Level 5
The password for the next level is stored in a file somewhere under the inhere directory and has all of the following properties:

    human-readable
        1033 bytes in size
	    not executable




