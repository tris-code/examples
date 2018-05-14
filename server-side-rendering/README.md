1. Follow [Node](https://github.com/tris-foundation/node) instructions
2. `cd Web && npm install && npm run build`
3. `swift build -Xcc -I/usr/local/include/node -Xlinker /usr/local/lib/libnode.so.57`
4. .build/debug/main
4. open http://127.0.0.1:8080

Fix for find library error:<br>
`error while loading shared libraries: libnode.so.57: `<br>
`cannot open shared object file: No such file or directory`<br>

GNU/Linux
```bash
export LD_LIBRARY_PATH=/usr/local/lib
```

macOS
```bash
export DYLD_LIBRARY_PATH=/usr/local/lib
```
