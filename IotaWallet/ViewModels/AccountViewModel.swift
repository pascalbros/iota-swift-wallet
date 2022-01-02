import Foundation
import SwiftUI
import IOTAWallet

class AccountViewModel: ObservableObject {
    @Published var account: Account?
    @Published var status: ViewStatus = .loading
    
    init() {
        retrieveAccount()
    }
    
    func retrieveAccount() {
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
    }
    
    func createAccount() {
        
    }
}
