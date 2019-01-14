import SSR
import HTTP
import Node

class RiotRenderer: NodeServerSideRenderer {
    let index: Index

    public init(path: Path, handler: @escaping RequestHandler) throws {
        self.index = try Index(at: path)
        try super.init(path: path)

        try context.createFunction(name: "serverFetch") { arguments -> Value in
            guard let path = try arguments.first?.toString() else {
                return .string("no url")
            }
            let response = try handler(Request(url: try URL(path)))
            return .string(response.string ?? "no result")
        }
    }

    override public func render(_ request: Request) throws -> Response {
        let htmlValue = try context.evaluate("""
            (()=>{
                const riot = require('riot')
                const main = require('src/main.tag')
                const deasync = require('deasync')

                fetch = (url) => {
                    const result = serverFetch(url)
                    return new Promise(function(resolve, reject) {
                        resolve({
                            json: () => JSON.parse(result)
                        })
                    });
                }

                var result;
                riot.renderAsync(main).then((html) => result = html)
                deasync.loopWhile(() => result == undefined)
                return result
            })()
            """)
        let body = try htmlValue.toString()
        return Response(html: index.render(with: body))
    }
}
