```bash
docker build -t techempower-example .
docker run --rm -d -p 8080:8080 techempower-example
curl http://127.0.0.1:8080/plaintext
curl http://127.0.0.1:8080/json
# you better run this on linux or without docker
wrk -t2 -d5 -c128 http://127.0.0.1:8080/plaintext
wrk -t2 -d5 -c128 http://127.0.0.1:8080/json

docker stop $(docker ps | grep "techempower-example" | cut -d " " -f 1)
```
