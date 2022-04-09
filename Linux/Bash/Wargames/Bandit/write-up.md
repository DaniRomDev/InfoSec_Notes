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

	    Things get a little complicated here because if we list the directories and files on the path we're going to see a bunch of them so a manual approach is not feasible.

	    At least we have critical information:
	    - Human readable means that the type is ASCII text
	    - We have the size of it (1033 bytes)
	    - Is not executable so must not have the 'x' permission

	    Let's translate this conditions into a bash command:
	    ```bash
# ! Operator command is to check for the opposite
# We are looking for type file, not executable and size of 1033 bytes (we need to append c at the end to define that we want it on bytes)

	    find ./inhere/ -type f ! -executable -size 1033c

# Output will be 
./inhere/maybehere07/.file2

# Try to open with
find ./inhere/ -type f ! -executable -size 1033c | xargs cat
```
If we try to open this file we encounter another problem, the content is full of spaces so we need to do some kind of transformation before pass the output to the cat command.

The easy way is use xargs on the next pipe, this command by default will format the content so we can see now the password more readable:
```bash
find ./inhere/ -type f ! -executable -size 1033c | xargs cat | xargs
```
# Alternative with `tr` command
```bash
#  tr on the man page description stands for Translate, squeeze, and/or delete characters from standard input, writing to standard output.

find ./inhere/ -type f ! -executable -size 1033c | xargs cat | tr -d ' ' 
# -d option is for delete and we want to remove all the whitespaces
```
# Alternative with `sed` command
```bash
# sed <operator/<SEARCH>/<REPLACE>/<REGEX OPTION (g m i)>

# operator = s (replacement operator)
# SEARCH = \s (regex for whitespaces)
# REPLACE = '' (transform whitespaces into nothing)
# REGEX OPTION (g for global, this means transform all the matchs)
find ./inhere/ -type f ! -executable -size 1033c | xargs sed 's/\s//g'
```

# Level 6
The password for the next level is stored somewhere on the server and has all of the following properties:

    owned by user bandit7
        owned by group bandit6
	    33 bytes in size

	    The important information here is somewhere on the server so if you run `ls' command on your user directory you can see that we don't have nothing relevant on it.

	    As before we have some conditions to apply on our find command to help us on this adventure:
	    ```bash
# We start looking for files on the root directory because we don't know where it's located
	     find / -type f -user bandit7 -group bandit6 -size 33c
# This come up with some noise
	      find: ‘/root’: Permission denied
	      find: ‘/home/bandit28-git’: Permission denied
	      find: ‘/home/bandit30-git’: Permission denied
	      find: ‘/home/bandit5/inhere’: Permission denied
	      find: ‘/home/bandit27-git’: Permission denied
	      find: ‘/home/bandit29-git’: Permission denied
	      find: ‘/home/bandit31-git’: Permission denied
	      find: ‘/lost+found’: Permission denied
	      find: ‘/etc/ssl/private’: Permission denied
	      find: ‘/etc/polkit-1/localauthority’: Permission denied
	      find: ‘/etc/lvm/archive’: Permission denied
	      find: ‘/etc/lvm/backup’: Permission denied
	      find: ‘/sys/fs/pstore’: Permission denied
	      find: ‘/proc/tty/driver’: Permission denied
	      find: ‘/proc/28534/task/28534/fdinfo/6’: No such file or directory
	      find: ‘/proc/28534/fdinfo/5’: No such file or directory
	      find: ‘/cgroup2/csessions’: Permission denied
	      find: ‘/boot/lost+found’: Permission denied
	      find: ‘/tmp’: Permission denied
	      find: ‘/run/lvm’: Permission denied
	      find: ‘/run/screen/S-bandit1’: Permission denied
	      find: ‘/run/screen/S-bandit10’: Permission denied
	      find: ‘/run/screen/S-bandit25’: Permission denied
	      find: ‘/run/screen/S-bandit30’: Permission denied
	      find: ‘/run/screen/S-bandit9’: Permission denied
	      find: ‘/run/screen/S-bandit28’: Permission denied
	      find: ‘/run/screen/S-bandit18’: Permission denied
	      find: ‘/run/screen/S-bandit20’: Permission denied
	      find: ‘/run/screen/S-bandit12’: Permission denied
	      find: ‘/run/screen/S-bandit5’: Permission denied
	      find: ‘/run/screen/S-bandit7’: Permission denied
	      find: ‘/run/screen/S-bandit16’: Permission denied
	      find: ‘/run/screen/S-bandit26’: Permission denied
	      find: ‘/run/screen/S-bandit8’: Permission denied
	      find: ‘/run/screen/S-bandit15’: Permission denied
	      find: ‘/run/screen/S-bandit4’: Permission denied
	      find: ‘/run/screen/S-bandit3’: Permission denied
	      find: ‘/run/screen/S-bandit19’: Permission denied
	      find: ‘/run/screen/S-bandit31’: Permission denied
	      find: ‘/run/screen/S-bandit17’: Permission denied
	      find: ‘/run/screen/S-bandit2’: Permission denied
	      find: ‘/run/screen/S-bandit22’: Permission denied
	      find: ‘/run/screen/S-bandit21’: Permission denied
	      find: ‘/run/screen/S-bandit14’: Permission denied
	      find: ‘/run/screen/S-bandit13’: Permission denied
	      find: ‘/run/screen/S-bandit24’: Permission denied
	      find: ‘/run/screen/S-bandit23’: Permission denied
	      find: ‘/run/shm’: Permission denied
	      find: ‘/run/lock/lvm’: Permission denied
	      find: ‘/var/spool/bandit24’: Permission denied
	      find: ‘/var/spool/cron/crontabs’: Permission denied
	      find: ‘/var/spool/rsyslog’: Permission denied
	      find: ‘/var/tmp’: Permission denied
	      find: ‘/var/lib/apt/lists/partial’: Permission denied
	      find: ‘/var/lib/polkit-1’: Permission denied
	      /var/lib/dpkg/info/bandit7.password # SPOILER ALERT
	      find: ‘/var/log’: Permission denied
	      find: ‘/var/cache/apt/archives/partial’: Permission denied
	      find: ‘/var/cache/ldconfig’: Permission denied
# //...
	      ```
	      To solve this we need to understand the three streams that bash uses to transfer data, more information on [this link](https://linuxhint.com/bash_stdin_stderr_stdout/)

	      In this case, at unix level, 2 means error and we can redirect all this error to the black hole of linux `/dev/null/` to filter errors from our `find` command output and get the exact data we need:

	      ```bash
# With 2> we can select where to redirect the errors on the output
# Permission denied is considered an error
	      find / -type f -user bandit7 -group bandit6 -size 33c 2>/dev/null

# And successfully we have just the file we need
/var/lib/dpkg/info/bandit7.password
```

# Level 7
The password for the next level is stored in the file data.txt next to the word millionth


