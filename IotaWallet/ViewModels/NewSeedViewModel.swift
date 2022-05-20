import Foundation
import SwiftUI

protocol INewSeedViewModel: ObservableObject {
    var status: ViewStatus { get }
    var words: [String] { get }
    var goToNextView: Bool { get set }
    func onCopyMnemonicSelected()
    func onCreateSelected()
    func buildNextView() -> AnyView
}

class NewSeedViewModel: INewSeedViewModel {
    
    @Published var status: ViewStatus = .loading
    @Published var words: [String] = []
    @Published var goToNextView: Bool = false
    
    init() {
        generateMnemonic()
    }
    
    fileprivate func generateMnemonic() {
        status = .loading
        AppWallet.generateMnemonic { result in
            switch result {
            case .success(let mnemonic):
                self.status = .data
                self.words = mnemonic.split(separator: " ").map { String($0) }
            case .failure(let error):
                self.status = .error
                print(error)
            }
        }
    }
    
    func onCopyMnemonicSelected() {
        UIPasteboard.general.string = words.joined(separator: " ")
    }
    
    func onCreateSelected() {
        guard !words.isEmpty else { return }
        NewAccountInProgress.current.mnemonic = words.joined(separator: " ")
        AppWallet.storeMnemonic(mnemonic: NewAccountInProgress.current.mnemonic, signer: .stronghold, onResult: nil)
        AppWallet.createAccount(alias: NewAccountInProgress.current.alias,
                                mnemonic: NewAccountInProgress.current.mnemonic,
                                url: NewAccountInProgress.current.nodeURL,
                                localPow: true) { result in
            switch result {
            case .success(let account):
                AppAccount = account
                self.goToNextView = true
            case .failure: break
            }
        }
    }
    
    func buildNextView() -> AnyView {
        return AnyView(MainView())
    }
}
