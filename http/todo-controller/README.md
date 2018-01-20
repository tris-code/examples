```swift
swift run main
```

```bash
curl http://127.0.0.1:8080/todos
curl http://127.0.0.1:8080/todos/0
curl http://127.0.0.1:8080/todos -H 'content-type: application/json' -d '{"id":3, "done": true, "description": "test"}'
curl http://127.0.0.1:8080/todos -H 'content-type: application/json' -d '{"id":3, "done": true, "description": "test"}' -v
```

Docker
```bash
docker build -t todo-controller .
docker run --rm -d -p 8080:8080 todo-controller

docker stop $(docker ps | grep "todo-controller" | cut -d " " -f 1)
```
