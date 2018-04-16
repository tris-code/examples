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
import Web
import Fiber

async.use(Fiber.self)

async.task {
    do {
        try WebHost(bootstrap: BlogBootstrap()).run()
    } catch {
        Log.critical(String(describing: error))
    }
}

async.loop.run()
