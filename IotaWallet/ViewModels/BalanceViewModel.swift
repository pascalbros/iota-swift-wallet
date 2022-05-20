import Foundation
import SwiftUI
import IOTAWallet

protocol IBalanceViewModel: ObservableObject {
    var status: ViewStatus { get }
    var balance: Int { get }
    var formattedBalance: String { get }
    func onReload()
}

class BalanceViewModel: IBalanceViewModel {
    
    @Published var status: ViewStatus = .data
    @Published var balance: Int = 0 {
        didSet {
            formattedBalance = IotaUnitsConverter.iotaToString(amount: UInt64(balance))
        }
    }
    @Published var formattedBalance: String  = ""
    
    func onReload() {
        getBalance()
    }
    
    fileprivate func getBalance() {
        self.status = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            AppAccount?.sync(onResult: { _ in
                AppAccount?.balance(onResult: { result in
                    switch result {
                    case .success(let balance):
                        self.balance = balance.available
                        self.status = .data
                    case .failure:
                        self.status = .error
                    }
                })
            })
        }
    }
}
