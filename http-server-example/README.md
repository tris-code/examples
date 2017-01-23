```bash
docker build -t http-example .
docker run --rm -d -p 8080:8080 http-example
curl http://127.0.0.1:8080/hello
curl http://127.0.0.1:8080/robot/47

docker stop $(docker ps | grep "http-example" | cut -d " " -f 1)
```
