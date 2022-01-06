import Foundation
import SwiftUI
#if canImport(_IOTAWallet)
import IOTAWallet
#endif

protocol IAccountViewModel: ObservableObject {
    var account: Account? { get }
    var status: ViewStatus { get }
    func createAccount()
}

class AccountViewModel: IAccountViewModel {
    @Published var account: Account?
    @Published var status: ViewStatus = .loading
    
    init() {
        retrieveAccount()
    }
    
    func retrieveAccount() {
    #if canImport(_IOTAWallet)
        if sharedWallet == nil {
            sharedWallet = IOTAAccountManager(storagePath: nil, startsAutomatically: true)
        }
        sharedWallet?.getAccounts { result in
            switch result {
            case .success(let accounts):
                self.status = .data
                if let account = accounts.first {
                    self.account = Account(name: account.alias)
                } else {
                    self.account = nil
                }
            case .failure(let error):
                print(error)
            }
        }
    #endif
    }
    
    func createAccount() {
        
    }
}
