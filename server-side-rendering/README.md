(1) Follow [Node](https://github.com/tris-foundation/node) instructions<br>
(2) `cd Web && npm install && npm run build`<br>
(3.Linux) `swift build -Xcc -I/usr/local/include/node -Xlinker /usr/local/lib/libnode.so.64`<br>
(3.macOS) `swift build -Xcc -I/usr/local/include/node -Xlinker /usr/local/lib/libnode.64.dylib`<br>
(4) .build/debug/main<br>
(5) open http://127.0.0.1:8080<br>

Fix for Linux error:<br>
`error while loading shared libraries: libnode.so.64: `<br>
`cannot open shared object file: No such file or directory`<br>
```bash
export LD_LIBRARY_PATH=/usr/local/lib
```

If you install node in a custom location on macOS:
```bash
export DYLD_LIBRARY_PATH=/opt/node/lib
```
