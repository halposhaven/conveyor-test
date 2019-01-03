#!/bin/bash

#
# Ensure that root is running the script.
##

USERS="./config-list.conf"

cat ${USERS} | \
while read USER GROUP SMBPASS DIR ; do
   
   groupadd ${GROUP} 2> /dev/null
   adduser ${USER} -g ${GROUP}

   (echo $SMBPASS; echo $SMBPASS) | passwd --stdin ${USER} > /dev/null
   echo Added user ${USER}

   smbpasswd -e ${USER} -w ${SMBPASS} > /dev/null
   (echo $SMBPASS; echo $SMBPASS) | smbpasswd -as ${USER}
   echo -e "${USER} = ${USER}" >> /etc/samba/smbusers

   mkdir /data/share/${DIR}
   chown -R  ${USER}:${GROUP} /data/share/${DIR}
done
