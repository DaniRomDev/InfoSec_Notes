# Level 1
There is a .backup folder with an html named 'bookmarks', grep for password and that's it

# Level 2
This one is a little bit tricky but you need to run strings on the binary file named 'check' so you'll see a word 'love', what word comes into your mind..? yes, you're right, 'sex', that's the password

# Level 3   
This one I didn't understand at all but seems like printfile binary is executed as leviathan3 permissions so we can take advantage of this
The technique here is create a file with a space like
```bash
touch /tmp/user/"pass word.txt"

ltrace ~/printfile /tmp/user/"pass word.txt"

# This is going to print the trace and link into a 'pass' file that not exists yet, this one is going to be a symlink to the leviathan3 path
ln -s /etc/leviathan_pass/leviathan3 /tmp/user/pass

~/printfile "pass word.txt"

```
# Level 4
Another ltrace on 'level3' binary and you'll see that does a comparison with strcmp c function, so if you put snlprintf as password you're going to spawn a shell being leviathan4 user

# Level 5
A suspicious .trash folder contains a binary that runs a an fopen() on leviathan5 file to see the password but it's on binary format
Just convert this binary values into ASCII format and you'll have the password
# Level 6
Ltrace again bla bla on leviathan5 binary and you'll see that tries to read a /tmp/file.log that doesn't exist, create this file as a symlink to leviathan6 password and happiness appears

# Level 7
Another stupid binary in where have a 4 digit password so let's loop this shit until spawn the shell
```bash
for i in {0000..9999}; do ./leviathan6 $i; done

```
