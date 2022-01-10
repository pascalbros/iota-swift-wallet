import Foundation
import SwiftUI
import IOTAWallet

protocol IPasswordViewModel: ObservableObject {
    var status: ViewStatus { get }
    var password: String { get set }
    var goToNextView: Bool { get set }
    func onConfirm()
    func onErrorDisappeared()
    func buildNextView() -> AnyView
}

class PasswordViewModel: IPasswordViewModel {
    @Published var password: String = ""
    @Published var status: ViewStatus = .data
    @Published var goToNextView: Bool = false
    
    func onConfirm() {
        status = .loading
        AppWallet.setStrongholdPassword(password) { result in
            switch result {
            case .success(let result):
                if result {
                    self.onPasswordAccepted()
                } else {
                    self.onWrongPassword()
                }
            case .failure:
                self.onWrongPassword()
            }
        }
    }
    
    func onPasswordAccepted() {
        status = .data
        goToNextView = true
    }
    
    func onWrongPassword() {
        status = .error
    }
    
    func onErrorDisappeared() {
        status = .data
    }
    
    func buildNextView() -> AnyView {
        AnyView(AccountView(viewModel: AccountViewModel()))
    }
}
