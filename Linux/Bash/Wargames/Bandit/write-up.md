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
- human-readable
- 1033 bytes in size
- not executable

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

This is not difficult at all but we can improve the way to get the password for the next bandit user, initially I guess you would try the next one:

```bash
cat data.txt | grep 'millionth'
# You'll see the next text output
millionth       cvX2JJa4CFALtqS87jk27qwqGhBM9pl

# If we know which file and the pattern we're looking for we can simplify things using only grep
grep 'millionth' data.txt
```

In order to improve our toolbelt let's show the `awk`command in action
**From man page:**
*mawk  is  an  interpreter  for  the  AWK  Programming  Language.   The AWK language is useful for manipulation of data files, text retrieval and processing, and for prototyping and experimenting with algorithms.  mawk is a new awk meaning it implements the  AWK language  as  defined in Aho, Kernighan and Weinberger, The AWK Programming Language, Addison-Wesley Publishing, 1988.*

```bash
# Awk is going to receive the arguments from the last command as $1, $2, $n..
# We know that $1 is going to be millionth and $2 the password, by default awk dismiss whitespaces and are not treated as arguments
grep 'millionth' data.txt | awk '{print $2}'

# We can use fully awk for this action, NF{} is an special command of awk to get the last argument
awk /millionth/ data.txt | awk 'NF{print $NF}
```

# Level 8
The password for the next level is stored in the file data.txt and is the only line of text that occurs only once

This level is perfect to sort unique text streams and get the data we really need, if you open the data.txt file you'll see a lot of lines:
```bash
cat data.txt 

WBqr9xvf6mYTT5kLcTGCG6jb3ex94xWr
iwE0KTeKQ8PWihqvjUnpu52YZeIO8Pqb
qaWWAOOquC3yHnfJI4zvPWzCBdfHQ8wa
0N65ZPpNGkUJePzFxctCRZRXVrCbUGfm
cR6riSWC0ST7ALZ2i1e47r3gc0QxShGo
TKUtQbeYnEzzYIne7BinoBx2bHFLBXzG
8NtHZnWzCA8HswoJSCU7Ojg8nP3eKpsA
SzwgS2ADSjP6ypOzp2bIvdqNyusRtrHj
5AdqWjoJOEdx5tJmZVBMo0K2e4arD3ZW
gqyF9CW3NNIiGW27AtWVNPqp3i1fxTMY
flyKxCbHB8uLTaIB5LXqQNuJj3yj00eh
w4zUWFGTUrAAh8lNkS8gH3WK2zowBEkA
# //...
```
We can use the `wc`command that stands for 'word count' to see how many lines this file has:
```bash
# -l option is to print number of lines
cat data.txt | wc -l
# Output is 1001
```
and we can confirm it has a lot of lines so let's see how we can find our password inside this file.

In bash we have available the `uniq` command that allow us to do some operations related with duplications
```bash
# This is not going to work and it's because we need to sort the content first to make the uniq command capable of checking for duplicate lines.
# -u flag stands for 'only print unique lines'
cat data.txt | uniq -u
# // ... You'll see a lot of data again, let's sort first the content:
cat data.txt | sort | uniq -u
# Password printed
```

As we saw in the last level if we know which file is, we can run the command directly without needing to open it with cat:
```bash
sort data.txt | uniq -u
```
# Level 9
The password for the next level is stored in the file data.txt in one of the few human-readable strings, preceded by several ‘=’ characters.

There is just one command that is the key for this level and is `string`
```bash
#  strings - print the strings of printable characters in files
string data.txt
# Output of a bunch of printable characters
S=A.H&^
%hu&
C}Jy
0R@R_

# // ...
```
There are many ways to get the password from this archive, let's try first with `grep` and `tail` using the '=' as the definition says:
```bash
strings data.txt | grep '='
# Output of
=zsGi
Z)========== is
A=|t&E
Zdb=
c^ LAh=3G
*SF=s
&========== truKLdjsbJ5g7yyJ2X2R0o3a5HQJFuLk # Seems that this is the one we're looking for
S=A.H&

# We can do a more accurate grep to retrieve the line we want:
strings data.txt | grep '&='
# Outputs the string containing the password 
# &========== truKLdjsbJ5g7yyJ2X2R0o3a5HQJFuLk

# An alternative with tail could be:
strings data.txt | grep '==' # If we use twice the = character we can see that is the last line
========== the*2i4
========== password
Z)========== is
&========== truKLdjsbJ5g7yyJ2X2R0o3a5HQJFuLk

# Then with tail 
strings data.txt | grep '==' | tail -n 1 
# &========== truKLdjsbJ5g7yyJ2X2R0o3a5HQJFuLk
```
We know what line it is and we have the password value on it but what happen if we need to retrieve only the password without this special characters before. Think this could be runned as an script and we need to get the exact value to continue working on it.

The awk command in this case could work because we realize that they are separated by a space:
```bash
strings data.txt | grep '&=' | awk '{print $2}'
# Output truKLdjsbJ5g7yyJ2X2R0o3a5HQJFuLk

# Or if we know the line number, NR is another special command from awk to check the line number
strings data. txt | grep '==' | awk 'NR==4' | | awk '{print $2}'
```

# Level 10
The password for the next level is stored in the file data.txt, which contains base64 encoded data

This one is very easy, the command `base64` can help us to obtain the password
```bash
# -d flag is to decode the value
base64 -d data.txt
# The password is IFukwKGsFW8MOq3IRFqrxE1hxTNEbUPR
```
With the skills learned on last levels, let's try to get the exact value from the string, in this case we can use `tr`:
```bash
# Translate the whitespaces into carrier returns
base64 -d data.txt | tr ' ' '\n'
The
password
is
IFukwKGsFW8MOq3IRFqrxE1hxTNEbUPR

# Knowing that the password is the last line we can apply another pipe using tail:
base64 -d data.txt | tr ' ' '\n' | tail -n 1 
# IFukwKGsFW8MOq3IRFqrxE1hxTNEbUPR
```
# Level 11
The password for the next level is stored in the file data.txt, where all lowercase (a-z) and uppercase (A-Z) letters have been rotated by 13 positions.

Basically reading the definition we can detect that the rotated positions are the same of [Caesar cipher](https://brilliant.org/wiki/caesar-cipher/)

In this one is perfect to create **our first alias** that related to a specific command execution to translate a value encoded with caesar cipher.
```bash
# We can rotate characters with tr with the help of regex, so an 'A' is transformed into 'N' or an 'a' is transformed into 'n' also on lowercase
cat data.txt | tr 'A-Za-z' 'N-ZA-Mn-za-m'
# The password is 5Te8Y4drgCRfCx8ugdwuEX8KFC6k2EUu

# We can create an alias to reuse this function
# ROT13 is a simple letter substitution cipher that replaces a letter with the 13th letter after it in the alphabet. ROT13 is a special case of the Caesar cipher which was developed in ancient Rome
alias rot13="tr 'A-Za-z' 'N-ZA-Mn-za-m'"

# and we can execute again as 
cat data.txt | rot13
# The password is 5Te8Y4drgCRfCx8ugdwuEX8KFC6k2EUu
```
If you create the alias on the fly and close the terminal session, this one will disappear. To keep the alias on the system you need to add this alias in the bash configuration file you're currently using *(.bashrc, .zshrc ...)*
```bash
# .bashrc
alias rot13="tr 'A-Za-z' 'N-ZA-Mn-za-m'"
```
# Level 12
The password for the next level is stored in the file data.txt, which is a hexdump of a file that has been repeatedly compressed. For this level it may be useful to create a directory under /tmp in which you can work using mkdir. For example: mkdir /tmp/myname123. Then copy the datafile using cp, and rename it using mv (read the manpages!)

Copy the file as the definition says:
```bash
# Replace <yourname> with the name you want
mkdir /tmp/<yourname/ && cp ~/data.txt /tmp/<yourname>/data.txt && cd /tmp/<yourname>
```
Once we are on the temporal folder we can start playing with `xxd`, as the man pages definition says ->  *xxd - make a hexdump or do the reverse*
```bash
# So for example, transform into hexadecimal the next string
echo "My fancy string" | xxd
# You'll see the next output
00000000: 4d79 2066 616e 6379 2073 7472 696e 670a  My fancy string.

# To get only the hexadecimal part use -ps 
echo "My fancy string" | xxd -ps
# You'll see this 4d792066616e637920737472696e670a

# If we want to revert the hex value use the -r flag
echo "My fancy string" | xxd | xxd -r
# You'll see again your original value "My fancy string"
```
Then go apply this command into our special data.txt file:
```bash
xxd -r data.txt
# You'll see a weird characters in apparently random positions, let's create a new file with the hex reversed to inspect the file type
xxd -r data.txt > data && file data
# The output now is:
data: gzip compressed data, was "data2.bin", last modified: Thu May  7 18:14:30 2020, max compression, from Unix
```
A good information appears but if we go back to the definition of this level remember this sentence `this is a hexdump of a file that has been repeatedly compressed`

So I guess it has been compressed many times and it will take a long time manually decompress it again and again *(even in several compression formats).*

**Yeah! the perfect chance to create our first bash script**
I know all the compression formats that appear because I have done it manually with the first ones *(gzip, bzip2 and tar)* so in every iteration from the first compressed file that we get from the hexdump with `xxd` we need to check the compression format of this file and save the uncompressed filename to use in the next loop step.

**Note:** *Unfortunately the bandit server for this level doesn't have the `7z` library that is an universal compression tool that make this work more easy but in order to try resolve the levels inside the bandit server, let's continue creating our script.*

```bash
#!/bin/bash
# A few functions to help us on the decompression process

# With this one we can know file type in order to choose the decompression tool
function get_type() {
        echo $(file -b $1 | tr ' ' '\n' | head -n1)
}

# Get the filename of the uncompressed file when is .gz format
function gzip_get_filename() {
        echo $(gzip -l $1 | tr ' ' '\n' | tail -1)
}

# Get the filename of the uncompressed file when is .tar format
function tar_get_filename() {
        echo $(tar -tf $1)
}

last_file=data
xxd -r ./data.txt > "$last_file"

while true; do
        # Clean up this generated files on each iteration to avoid collisions
	    rm -f *.gz *.tar.gz *.bz

	        type=$(get_type "$last_file")

		    if [ "$type" == "ASCII" ]; then
			        echo $(cat "$last_file" | tr ' ' '\n' | tail -1)
				        exit 1
					    elif [ "$type" == "gzip" ]; then
					            mv -f "$last_file" data.gz
						            last_file=$(gzip_get_filename data.gz)
							            gzip -d data.gz
								        elif [ "$type" == "bzip2" ]; then
									    # With bzip2 we don't have a list option like gzip or tar but we know that the result file compressed is always the same without the .bz2 part.
									            mv -f "$last_file" "$last_file.bz2" && bzip2 -d "$last_file.bz2"
										        elif [ "$type" == "POSIX" ]; then
											        mv -f "last_file" data.tar.gz
												        last_file=$(tar_get_filename data.tar.gz)
													        tar -xf data.tar.gz
														    else
															        echo "$last_file $type NOT FOUND, ABORTING..."
																    exit 1
																        fi
																	done
																	```

																	Give execution permissions for your user in this new script `chmod u+x ./decompress.sh` and run it with `./decompress.sh`. If all went well, you should see the password on the console output.

# Level 13
The password for the next level is stored in `/etc/bandit_pass/bandit14` and can only be read by user bandit14. For this level, you don’t get the next password, but you get a private SSH key that can be used to log into the next level. Note: localhost is a hostname that refers to the machine you are working on

This level is not complicated as the other ones, if you list the files after connect via ssh with bandit13 you can see a private key of type **PEM RSA private key**. Using `ssh`command we can make a connection from this machine very easy to bandit14

```bash
# Don't use the -p flag to define the port, is not needed in connection.
ssh -i ./sshkey.private bandit14@localhost

# Once inside the machine we have the path from definition of level 13 to get the password
cat /etc/bandit_pass/bandit14
```

# Level 14
The password for the next level can be retrieved by submitting the password of the current level to port 30000 on localhost.

The password is the one we obtained in the previous process on `/etc/bandit_pass/bandit14`. First of all we need to check if the port is really opened with a simple echo:
```bash
echo ' ' > /dev/tcp/127.0.0.1/30000
# If nothing happens, it's because it's open, you can know if it's true using this helper in console that gives the status bit of the last executed command
echo $? # 0

# Or you can simplify things using && that only run the next expression if the output was 0
echo ' ' > /dev/tcp/127.0.0.1/30000 && echo "Port 30000 is open"
```
Once we confirm the port is open, `netcat` comes to the rescue to make a connection on port 30000, a simplified way to give the password is using pipes a`fter open the file with the password content:

```bash
cat /etc/bandit_pass/bandit14 | nc localhost 30000
# Correct!
BfMYroe26WYalil77FoDi9qh59eK5xN
```
`telnet`is another way to make a connection on the port, this time you need to copy the password when prompt is ready:
```bash
telnet localhost 30000
# Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'
```
# Level 15
The password for the next level can be retrieved by submitting the password of the current level to port 30001 on localhost using SSL encryption.

The modus operandi is similar as we did in level 14 but this time if you try to connect via `netcat`or `telnet` using the actual password, the connection is closed because is expecting an SSL encryption on the transport layer.

This time `openssl` makes it's appearance, reading the man pages we can found an interesting option that's useful on this wargame:

**s_client:** *This implements a generic SSL/TLS client which can establish a transparent connection to a remote server speakingSSL/TLS. It's intended for testing purposes only and provides only rudimentary interface functionality but internally uses mostly all functionality of the OpenSSL ssl library*

So with this new information we can establish this connection on the remote server:
```bash
openssl s_client -connect 127.0.0.1:30001
# A bunch of data appears in the screen, just paste the password and enjoy your flag
```
# Level 16
The credentials for the next level can be retrieved by submitting the password of the current level to a port on localhost in the range 31000 to 32000. First find out which of these ports have a server listening on them. Then find out which of those speak SSL and which don’t. There is only 1 server that will give the next credentials, the others will simply send back to you whatever you send to it.

Scanning ports is the key here, fortunately we have available the nmap tool on this serve so se can take advantage of it for our purpose on getting the password for the next level.

We're not get into detail on nmap tool in this level but you'll see that is a powerful network tool
```bash
# This means, find open ports with insane option -T paranoid|sneaky|polite|normal|aggressive|insane
# Using the port range 31000 ~ 32000 on localhost
 nmap --open -T5 -v -n -p31000-32000 127.0.0.1
 
 # This must give you the open ports in this range like this:
 Starting Nmap 7.40 ( https://nmap.org ) at 2022-04-14 10:59 CEST
Initiating Ping Scan at 10:59
Scanning 127.0.0.1 [2 ports]
Completed Ping Scan at 10:59, 0.00s elapsed (1 total hosts)
Initiating Connect Scan at 10:59
Scanning 127.0.0.1 [1001 ports]
Discovered open port 31046/tcp on 127.0.0.1
Discovered open port 31518/tcp on 127.0.0.1
Discovered open port 31691/tcp on 127.0.0.1
Discovered open port 31790/tcp on 127.0.0.1
Discovered open port 31960/tcp on 127.0.0.1
Completed Connect Scan at 10:59, 0.04s elapsed (1001 total ports)
Nmap scan report for 127.0.0.1
Host is up (0.00026s latency).
Not shown: 996 closed ports
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT      STATE SERVICE
31046/tcp open  unknown
31518/tcp open  unknown
31691/tcp open  unknown
31790/tcp open  unknown
31960/tcp open  unknown

Read data files from: /usr/bin/../share/nmap
Nmap done: 1 IP address (1 host up) scanned in 0.09 second
```
As we see here we have 5 ports opened on this range, now is just trying manually which one speak SSL. Create an script for this level is not worth it because there are only few ports to try in.
```bash
# Using the openssl command as we did in the last level we could know which one speak SSL
openssl s_client -connect 127.0.0.1:<PORT_YOU_WANT_TRY>
```
Once you detect the SSL port just paste the actual level password and you'll receive a ssh private key
```bash
# Create a new temporary directory to create the private key and make the connection into the another machine
mktemp -d # You should see the new directory in the format: /tmp/tmp.4929B112
cd /tmp/tmp.4929B112 && touch private_key && chmod 600 private_key # Only gives permissions for your user.

# Open the file with your favorite editor (vim, nano, //...) and paste the SSH key you retrieved from the SSL port
ssh -i private_key bandit17@localhost
```
Done!
# Level 17
There are 2 files in the homedirectory: passwords.old and passwords.new. The password for the next level is in passwords.new and is the only line that has been changed between passwords.old and passwords.new

NOTE: if you have solved this level and see ‘Byebye!’ when trying to log into bandit18, this is related to the next level, bandit19

First of all let's get the password for this level to not use the ssh key if we want to connect on bandit16 again. ***Notice that you can access to the current level password always on this folder.***
```bash
cat /etc/bandit_pass/bandit17
```

In this one we need to get the only line that is one file but not in the other one (a diff basically). We're going to use the `diff` command to get the line difference:
```bash
diff passwords.old passwords.new
# 42c42
< w0Yfolrc5bwjS4qw5mq1nnQi6mF03bii
---
> kfBf3eYk5BPBRzwjqutbbfE887SVc5Yd # Password here
```
# Level 18
The password for the next level is stored in a file readme in the homedirectory. Unfortunately, someone has modified .bashrc to log you out when you log in with SSH.

If you remember the clue 'Byebye!' from the last level is because if you try to connect via ssh into this level you will be logout after trying to connect. This happens because when you connect into the server via ssh the .bashrc is loaded first so inside this file there is few lines to logout after connect via ssh.

We can take advantage on the delay of ssh connection to execute commands before load the .bashrc like this:
```bash
ssh -p 2220 bandit18@bandit.labs.overthewire.org cat .bashrc 
# Should display the content of .bashrc and then logout
# //..
# if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
echo 'Byebye !'
exit 0
```

So knowing this behavior we can spam a bash instead of running 'cat .bashrc':
```bash
ssh -p 2220 bandit18@bandit.labs.overthewire.org bash
# Minimal bash spawned so we're able now to read the content of readme file to get the password for the next level
cat readme
```
# Level 19
To gain access to the next level, you should use the setuid binary in the homedirectory. Execute it without arguments to find out how to use it. The password for this level can be found in the usual place (/etc/bandit_pass), after you have used the setuid binary.

If we read the description carefully, we realise that it is simply a matter of following the steps to obtain the new password, so you'll find this binary called `bandit20-do`, let's execute the binary to see how we can use it

```bash
./bandit20-do
# Run a command as another user.
  Example: ./bandit20-do id
  
# So if I can run command as bandit20 user we can read the password on the folder
./bandit20-do cat /etc/bandit_pass/bandit20
```
# Level 20
There is a setuid binary in the homedirectory that does the following: it makes a connection to localhost on the port you specify as a commandline argument. It then reads a line of text from the connection and compares it to the password in the previous level (bandit20). If the password is correct, it will transmit the password for the next level (bandit21).

NOTE: Try connecting to your own network daemon to see if it works as you think

Things are getting more complicated from this level, so it can be confusing this one but is just connect to a whatever free port on the machine and then connect to it via the setuid binary defined in the level:

To pass this level you'll need to connect via ssh into bandit20 in two separate terminal sessions because in the first one we're going to use the setuid binary to connect into the port we opened in the other session using `netcat`. Make sure the use netcat before run the suconnect binary
```bash
#1 Session
./suconnect 5001 

#2 Session
nc -nlvp 5001 # You can set here the whatever port you want, just make sure that is free (don't use the popular ones like 80, 443, 22 ...)
# listening on [any] 5001 ...
connect to [127.0.0.1] from (UNKNOWN) [127.0.0.1] 47642
```
Now you can send the current level password on #2 Session and you'll receive the next password in the #1 session

# Level 21
A program is running automatically at regular intervals from cron, the time-based job scheduler. Look in /etc/cron.d/ for the configuration and see what command is being executed.

It is most easy that you think on this one, if you list the files inside `/etc/cron.d` you'll see a few bandit files:
```bash
ls /etc/cron.d
# cronjob_bandit15_root  cronjob_bandit17_root  cronjob_bandit22  cronjob_bandit23  cronjob_bandit24  cronjob_bandit25_root
```
The next level is 22 so let's try to read the `cronjob_bandit22` file and see the content:
```bash
cat /etc/cron.d/cronjob_bandit22
# @reboot bandit22 /usr/bin/cronjob_bandit22.sh &> /dev/null
* * * * * bandit22 /usr/bin/cronjob_bandit22.sh &> /dev/null
```
This execute a script in regular intervals so seems juicy, I guess in the content would be the password for the next level:
```bash
cat /usr/bin/cronjob_bandit22.sh
# #!/bin/bash
# chmod 644 /tmp/t7O6lds9S0RqQh9aMcz6ShpAoZKF7fgv
# cat /etc/bandit_pass/bandit22 > /tmp/t7O6lds9S0RqQh9aMcz6ShpAoZKF7fgv

# Fortunately this script is dumping the password into a file in the temporary directory where we have read permissions so let's pick up the password:
cat /tmp/t7O6lds9S0RqQh9aMcz6ShpAoZKF7fgv
```

# Level 22
A program is running automatically at regular intervals from cron, the time-based job scheduler. Look in /etc/cron.d/ for the configuration and see what command is being executed.

NOTE: Looking at shell scripts written by other people is a very useful skill. The script for this level is intentionally made easy to read. If you are having problems understanding what it does, try executing it to see the debug information it prints.


This is very similar to level 21, just follow the trace of the cron tab for bandit23
```bash
cat  /etc/cron.d/cronjob_bandit23
# @reboot bandit23 /usr/bin/cronjob_bandit23.sh  &> /dev/null
# * * * * * bandit23 /usr/bin/cronjob_bandit23.sh  &> /dev/null

cat /usr/bin/cronjob_bandit23.sh
# If you pay attention to the script content is very simple, just instead of whoami, change for the user you wants the password, in this case bandit23

cat /tmp/$(echo I am user bandit23 | md5sum | cut -d ' ' -f 1)
```
# Level 23
A program is running automatically at regular intervals from cron, the time-based job scheduler. Look in /etc/cron.d/ for the configuration and see what command is being executed.

NOTE: This level requires you to create your own first shell-script. This is a very big step and you should be proud of yourself when you beat this level!

NOTE 2: Keep in mind that your shell script is removed once executed, so you may want to keep a copy around…

This is more fun to do, follow the trace is similar to the latest etc/cron.d exercises so let's open the script for bandit24 and see the content:
```bash
cat /usr/bin/cronjob_bandit24.sh

# In this one you can translate that is reading files inside /var/spool/bandit24 directory and the content is removed after 60s passed if you are bandit23, so we can take advantage of this to insert our script that is going to read the password of bandit24.

mktemp -d 
chmod -R o+rwx /tmp/<your-tmp-created/

# Create your script that make a simple cat on /etc/bandit_pass/bandit24 and echo the content in a .txt file. Then copy your script inside /var/spool/bandit24
cp /tmp/<your-tmp-created>/script.sh /var/spool/bandit24
```

You can watch every second with the command `watch` for the command ls -lha on the tmp directory, for us is only wait that the .txt file is created with the passwordº
```bash
watch -n 1 ls -lha
```
# Level 24
A daemon is listening on port 30002 and will give you the password for bandit25 if given the password for bandit24 and a secret numeric 4-digit pincode. There is no way to retrieve the pincode except by going through all of the 10000 combinations, called brute-forcing.

This one is ugly what is a good exercise to practice brute force in order to get the secret 4 digit pincode

We know that the argument is expecting on port 30002 is the actual level password plus the 4 digit pincode we don't know yet, so let's create the script that generates our dictionary:
```bash
#!/bin/bash

password=$(cat /etc/bandit_pass/bandit24)
file=$1

for digit in {0000.9999}; do
    echo "$password $code" >> $file
done
```

So if we run the script passing the name of the file we want generate, the dictionary should be created with all combinations:
```bash
./pincode-dict-generator.sh dictionary.txt
```

With this new dictionary file and netcat, the pleasure is served
```bash
# We remove the lines with 'Wrong' and 'Please' to avoid overwhelm the terminal outputº
cat dictionary.txt | nc localhost 30002 | grep -eV "Wrong|Please"

# And now just wait until this message appears
Correct!
The password of user bandit25 is uNG9O58gUE7snukf3bvZ0rxhtnjzSGzG

Exiting
```
# Level 25
Logging in to bandit26 from bandit25 should be fairly easy… The shell for user bandit26 is not /bin/bash, but something else. Find out what it is, how it works and how to break out of it.

This level is to practice on the concept of 'jail shell', in this case we're going to take in advantage the more command the is using the actual bash of bandit26. If we take a look what bash this user have we must see:
```bash
cat /etc/passwd | grep bandit26
# bandit26:x:11026:11026:bandit level 26:/home/bandit26:/usr/bin/showtext
If we open the content of the showtext 

cat /usr/bin/showtext
# #!/bin/sh

# export TERM=linux

# more ~/text.txt
#exit 
```
Yeah, let's exploit this more with a jail shell. If you try to connect via ssh with the key we have in our home directory the connection into localhost is closed
```bash
ssh -i ./bandit26.ssh_key bandit26@localhost
# Connection to localhost is closed
```
Just move the terminal to be very minimal and try to connect via ssh, if you did this correctly, you should see a 'More 50% text' that is the pagination of the more command, from here we can spawn the vim code editor with the key 'v'.

From here just:
```bash
:set shell=/bin/bash

# and then 
:shell
```
Perfect, bash spawned, get the flag but don't exit the server because this is the only way to access bandit26 level`
# Level 26
Good job getting a shell! Now hurry and grab the password for bandit27!

On the home directory we have a binary to execute commands as bandit27 (don't know why this level is so easy, maybe to relax our minds)
```bash
# Spawn a bash as bandit27 user
./bandit27-do bash -p
# or just read the flag for next level
./bandit27-do cat /etc/bandit_pass/bandit27
```
# Level 27
There is a git repository at ssh://bandit27-git@localhost/home/bandit27-git/repo. The password for the user bandit27-git is the same as for the user bandit27.

The first thing that comes into your mind is connect directly via ssh into this address but if you try that the connection will be closed but a message appears sharing the information that a git shell interactive is available so we can run commands into this address, let's do a clone:
```bash
git clone ssh://bandit27-git@localhost/home/bandit27-git/rep
```
Inside this repo there is a README file where we can find the password for the next level
# Level 28
There is a git repository at ssh://bandit28-git@localhost/home/bandit28-git/repo. The password for the user bandit28-git is the same as for the user bandit28.

Clone the repository and find the password for the next level

In this one we have the same as the last level but in this case we need to see the git log because the actual readme doesn't have the credentials
So just run after clone the repo the command:
```bash
git log -p
# This should display the diff on the last commit and now you can see the password
```
# Level 29
There is a git repository at ssh://bandit29-git@localhost/home/bandit29-git/repo. The password for the user bandit29-git is the same as for the user bandit29.

Clone the repository and find the password for the next level.

Another git repo but this time in the actual branch the commits doesn't show the password so we need to list the available branchs with:
```bash
git branch -r && git checkout origin/dev && git log -p
```
And you'll see the password, magic

# Level 30
There is a git repository at ssh://bandit30-git@localhost/home/bandit30-git/repo. The password for the user bandit30-git is the same as for the user bandit30.

Clone the repository and find the password for the next level.

Anoter tricky repository, this time we don't have interesting commits or branchs but now we have the tag information so:
```bash
git tag # show 'secret'
git show secret
# Voila, the password
```

# Level 31
There is a git repository at ssh://bandit31-git@localhost/home/bandit31-git/repo. The password for the user bandit31-git is the same as for the user bandit31.

Clone the repository and find the password for the next level.

Maybe this one is the more funny of the git repositories, if you clone this repo you'll see a README giving us information that in order to retrieve the password we need to push a key.txt file into the repository but we need to do some stuff before:
```bash
# We need to copy the .gitconfig into this repository cloned
cp ~/.gitconfig ~/tmp/<your-temp-directory>/repo

cd /tmp/<your-temp-<directory>/repo 
echo "May I come in?" > key.txt

# If you try to add into a new commit you'll see that key.txt is ignoring, we need pass the flag -g to force add this file bypassing .gitignore
git add -f key.txt
git push origin master
3 And you'll receive the password on the message after the push :)º
```
# Level 32 (final boss)
After all this git stuff its time for another escape. Good luck!

Here we can see an uppercase shell that transform all our command into uppercase so we always get a <COMMAND>: not found. To escape from this we can spawn a new shell with 
```bash
$0

# And then run commands as normal
cat /etc/bandit_pass/bandit33
```


