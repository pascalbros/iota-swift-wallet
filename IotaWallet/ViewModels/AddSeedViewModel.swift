import Foundation
import SwiftUI

protocol IAddSeedViewModel: ObservableObject {
    var status: ViewStatus { get }
    var words: [String] { get set }
    var goToNextView: Bool { get set }
    func onPasteMnemonicSelected()
    func onContinueSelected()
    func buildNextView() -> AnyView
}

class AddSeedViewModel: IAddSeedViewModel {
    
    @Published var status: ViewStatus = .data
    @Published var words: [String] = Array(repeating: "", count: 24)
    @Published var goToNextView: Bool = false
    
    func onPasteMnemonicSelected() {
        let currentWords = (UIPasteboard.general.string ?? "").split(separator: " ")
        guard currentWords.count == 24 else { return }
        words = currentWords.map { String($0) }
    }
    
    func onContinueSelected() {
        guard !words.isEmpty else { return }
        NewAccountInProgress.current.mnemonic = words.joined(separator: " ")
        AppWallet.verifyMnemonic(mnemonic: NewAccountInProgress.current.mnemonic) { result in
            switch result {
            case .success(let value):
                if value {
                    self.onSuccess()
                }
            case .failure: break
            }
        }
    }
    
    fileprivate func onSuccess() {
        AppWallet.storeMnemonic(mnemonic: NewAccountInProgress.current.mnemonic, signer: .stronghold, onResult: nil)
        AppWallet.createAccount(alias: NewAccountInProgress.current.alias,
                                mnemonic: NewAccountInProgress.current.mnemonic,
                                url: NewAccountInProgress.current.nodeURL,
                                localPow: true, onResult: nil)
        goToNextView = true
    }
    
    func buildNextView() -> AnyView {
        return AnyView(MainView())
    }
}
