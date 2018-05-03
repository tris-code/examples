/******************************************************************************
 *                                                                            *
 * Tris Foundation disclaims copyright to this source code.                   *
 * In place of a legal notice, here is a blessing:                            *
 *                                                                            *
 *     May you do good and not evil.                                          *
 *     May you find forgiveness for yourself and forgive others.              *
 *     May you share freely, never taking more than you give.                 *
 *                                                                            *
 ******************************************************************************/

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
