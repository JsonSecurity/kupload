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

### Terminal 02

- First, we start the server with PHP in the folder where the `index.php`, `server.php` and `uploads/` files are located.
- We use `0.0.0.0` to indicate the local IP address and port `80`.

```
php -S 0.0.0.0:80 
```

#### Terminal 01

- To start the file transfer or upload, we must run the `kupload.sh` script in the folder where the files we want to upload are located.
- It also has some options to indicate whether to continue from a certain file onward.
- We run it and in the first argument we provide our IP, in this case local, and the server.php file.

```
./kupload.sh http://192.168.101.30/server.php
```





