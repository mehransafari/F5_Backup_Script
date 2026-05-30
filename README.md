**Important Notes:**


* Save the following code in a Bash script file (for example, `F5-BKUP-FTP.sh`) and run it using:

```bash 
bash F5-BKUP-FTP.sh
```

You can also automate the script by specifying the file path and scheduling it through `crontab`. This allows the script to run automatically on a schedule, such as **daily**, **weekly**, or **monthly**.

* To avoid placing the FTP user's password directly in the script, a hashed/encrypted password is used. You can generate it with the following command and place the result in `FTP_ENC_PASS`. If this is not important to you, you can put the password directly in `FTP_PASS`.

```bash
echo -n "PASSWORD" | openssl aes-128-cbc -a -salt -pass pass:""
```

* Enter the username that has **write access** on the FTP server in the `FTP_USER` section.

* The UCS backup will be stored in the **f5** folder, and the compressed archive containing all ASM configurations will be stored in the **config** folder on the FTP server. Create these two folders on the server, or modify the folder names to match your FTP server's configuration and requirements. Also, the FTP server IP address is assumed to be **10.10.10.10**; you can change it as needed.
