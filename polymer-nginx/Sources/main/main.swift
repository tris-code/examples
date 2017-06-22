import Log
import Server
import AsyncFiber
import AsyncDispatch
import Foundation

let async = AsyncFiber()
let server = try Server(host: "127.0.0.1", port: 9001, async: async)

struct Page: Encodable {
    let title: String
    let content: String
    var timestamp: String?

    init(title: String, content: String) {
        self.title = title
        self.content = content
        self.timestamp = nil
    }
}

var pages = [Page]()

pages.append(Page(
    title: "page 1",
    content: "Στο λογοτεχνία άρα πιο όσο κοινωνικές σοβαρότητα ψυχολογίας. Σο θέτουν θεϊκές άλλοτε γι ξεκινά έκδηλο. Σο γιου οι αυτό ίσως. Πω κενές αρ ατ στόχο ηθική έθιμα. Λογικό λαϊκού ποίηση ένα έλα. Τσον σαν σούκ έχει έχει άρα. Ατ κριτικής πα απαγωγέα καλύτερα παρόμοια κι. Τον τελειώσει χειρισμοί ζέη διαβάζουν κοινωνική δομήνικος κοινωνίας δις. Σχολιάζουν αποσκοπούν με σε θα θεωρητικοί. Οπτική μέτωπο ξεκινά κλπ από γίνουν αγάπης στη ατο."))

pages.append(Page(
    title: "page 2",
    content: "Bocca metto scena si seiva na comem so. Amanha ir pueris estudo le ca se. Frisando ate ter encolheu destacou mau dobrando vez. No acoitar chamava ja as me decimas. Degraus voz fio talhada lhe uma decerto. Uns submissao castanhos engeitado bem. Hoje diga rico em do. Podeis mal sao tambem faz mau subita. Dissesses respirava ao privacoes compaixao no retempera."))

pages.append(Page(
    title: "page 3",
    content: " 父親回衙 冒認收了 汗流如雨. 出 關雎 事 誨 ，可 去 覽 」. 關雎 矣 去 誨. 第九回 第五回 第六回 不題 第八回 第三回. 訖乃返 危德至 ﻿白圭志 建章曰： 樂而不淫 第十一回. 覽 關雎 」 ，可. 第三回 貢院 招」 第八回 德泉淹. ，可 出 矣 關雎 覽 意 曰： 」. 矣 覽 耳 誨 關雎. 冒認收了 汗流如雨 吉安而來 父親回衙 玉，不題. 了」 關雎 出 貢院 第十回 相域 不題 第八回 」 矣 去 事. 曰： 耳 意 事 ，可 矣 第一回 了」 誨 出 第三回. 」 覽 關雎 曰： 去 耳 事 ，可. 饒爾去罷」 此是後話 也懊悔不了 ，愈聽愈惱. 誨 曰： 覽 出 耳 」 ，可 關雎. 去 出 誨 覽 矣 關雎 」. "))

server.route(get: "/api/page/:integer") { (pageNumber: Int) in
    let pageNumber = pageNumber - 1
    guard pageNumber >= 0 && pageNumber < pages.count else {
        return Response(status: .notFound)
    }
    var result = pages[pageNumber]
    result.timestamp = String(describing: Date())
    return result
}

try server.start()
async.loop.run()
