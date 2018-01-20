/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

import Log
import Platform
import AsyncFiber

AsyncFiber().registerGlobal()

async.task {
    do {
        try runServer()
    } catch {
        print(String(describing: error))
        exit(1)
    }
}

async.task {
    do {
        try runClient()
    } catch {
        print(String(describing: error))
        exit(1)
    }
}

async.loop.run()
