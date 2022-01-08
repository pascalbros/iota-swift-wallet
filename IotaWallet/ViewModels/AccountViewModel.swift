import Foundation
import SwiftUI
import IOTAWallet

protocol IAccountViewModel: ObservableObject {
    var account: Account? { get }
    var status: ViewStatus { get }
    var goToCreateAccount: Bool { get set }
    var goToAccount: Bool { get set }
    func onCreateAccountSelected()
    func onAccountSelected()
    func buildCreateAccount() -> AnyView
    func buildAccount() -> AnyView
}

class AccountViewModel: IAccountViewModel {
    @Published var account: Account?
    @Published var status: ViewStatus = .loading
    @Published var goToCreateAccount: Bool = false
    @Published var goToAccount: Bool = false

    init() {
        retrieveAccount()
    }
    
    func retrieveAccount() {
        AppWallet.getAccounts { result in
            switch result {
            case .success(let accounts):
                self.status = .data
                self.account = accounts.first != nil ? Account(name: accounts.first!.alias) : nil
                AppAccount = accounts.first
            case .failure(let error):
                self.status = .error
                print(error)
            }
        }
    }
    
    func onAccountSelected() {
        goToAccount = true
    }
    
    func onCreateAccountSelected() {
        goToCreateAccount = true
    }
    
    func buildCreateAccount() -> AnyView {
        AnyView(NewAliasView(viewModel: NewAliasViewModel()))
    }
    func buildAccount() -> AnyView {
        AnyView(MainView())
    }
}
