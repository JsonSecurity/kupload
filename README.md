# kupload
This script is used to automatically and progressively upload files to a server configured by us.

<img src="https://github.com/JsonSecurity/Images/blob/main/scripts/http_kupload.png" />

### Download

```
git clone https://github.com/JsonSecurity/kupload
cd kupload
```
### Dependencies

```
pkg install maven -y
pkg install openjdk-17
```

## HTTP - receiver

```
cd server_http
mvn spring-boot:run
```

## HTTP - sender

```
chmod +x http_kupload.sh
```

```
./http_kupload.sh <ip>
```



