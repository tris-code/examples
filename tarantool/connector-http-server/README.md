# Instructions

0. Install [Tarantool](https://tarantool.org/download.html) 1.7+
1. Run tarantool.lua to start tarantool database
2. Run `swift build && .build/debug/main` to build & run the project
3. curl -X POST -H "Content-Type: application/json" -d '{"email":"xyz","password":"xyz"}' http://localhost:8181/api/v1/registration
