#! /bin/bash

# This is UBER INSECURE... (but occurs pre-almost everything, so it's handy)
echo '*INSECURE* Mini-session: Empty line to continue'
while true; do
 read cmd
 if [ "${cmd}" = "" ]; then break; fi
# Execute the command as 'root' - 
 echo "In: `pwd`"
 ${cmd}
done
