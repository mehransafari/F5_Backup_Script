#!/bin/bash

#F5 Backup to FTP Script By "Mehran Safari"

 

 

##TO AVOID USING CLEAR TEXT PASSWORD OF FTP SERVER WE USE HASHED PASSWORD TO MAKE IT SAFER##

FTP_ENC_PASS="ENCRYPTED_PASS"

FTP_PASS=$(echo "$FTP_ENC_PASS" | openssl aes-128-cbc -d -a -salt -pass pass:"" 2>/dev/null)

FTP_USER="USER"

 

##TAKE UCS BACKUP AND ADD DATE ON END OF FILE NAME##

tmsh save /sys ucs "F5-$(date +%Y%m%d)"

*

 

##SEND UCS FILE TO FTP SERVER WITH IP 10.10.10.10 AND FOLDER f5##

curl -T "/var/local/ucs/F5-$(date +%Y%m%d).ucs" --ftp-create-dirs -u $FTP_USER:$FTP_PASS "ftp://10.10.10.10/f5/"

 

 

## FIND OLDER BACKUPS AND DELETE THEM (JUST KEEPS UCS FILES CREATED TODAY.)##

find "/var/local/ucs/" -type f -name "F5-*.ucs" -mtime +1 -delete

 

 

##GOES INTO PARTITION1 (IF YOUR WAF IS PARTITIONED) AND SAVE ALL OF ASM POLICIES IN XML FORMAT TO RECOVER THEM SEPARATELY IF NEEDED)##

for policy in $(tmsh -c "cd /PARTITION1; list asm policy one-line" | awk '{print $3}'); do (tmsh -c "cd /PARTITION1; save asm policy ${policy} xml-file ${policy}.xml") done

 

 

##COMPRESS ALL ASM POLICIES AND ADD DATE ON END OF FILE NAME##

find /var/tmp/ -name "*.xml" -print0 | tar -czvf "F5-Policies-$(date +%Y%m%d).tgz" --null -T -

 

 

##SENDS COMPRESSED POLICY FILES TO FTP SERVER 10.10.10.10 AND FOLDER config##

curl -T "/config/F5-Policies-$(date +%Y%m%d).tgz" --ftp-create-dirs -u $FTP_USER:$FTP_PASS "ftp://10.10.10.10/f5/"

 

 

##REMOVE COMPRESSED AND XML POLICIES CREATED BEFORE##

rm "/config/F5-Policies-$(date +%Y%m%d).tgz"

rm /var/tmp/*.xml
