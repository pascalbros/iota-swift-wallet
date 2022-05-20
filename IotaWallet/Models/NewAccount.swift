import Foundation

class NewAccountInProgress {
    static var current = NewAccountInProgress()
    var alias: String = ""
    var mnemonic: String = ""
    var nodeURL = "https://api.lb-0.h.chrysalis-devnet.iota.cafe"
}
