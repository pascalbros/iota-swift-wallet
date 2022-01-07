import Foundation
import SwiftUI
import IOTAWallet

protocol IAccountViewModel: ObservableObject {
    var account: Account? { get }
    var status: ViewStatus { get }
    var goToCreateAccount: Bool { get set }
    func buildCreateAccount() -> AnyView
    func createAccount()
}

class AccountViewModel: IAccountViewModel {
    @Published var account: Account?
    @Published var status: ViewStatus = .loading
    @Published var goToCreateAccount: Bool = false
    
    init() {
        retrieveAccount()
    }
    
    func retrieveAccount() {
        AppWallet.getAccounts { result in
            switch result {
            case .success(let accounts):
                self.status = .data
                self.account = accounts.first != nil ? Account(name: accounts.first!.alias) : nil
            case .failure(let error):
                self.status = .error
                print(error)
            }
        }
    }
    
    func createAccount() {
        goToCreateAccount = true
    }
    
    func buildCreateAccount() -> AnyView {
        AnyView(NewAccountView())
    }
}
