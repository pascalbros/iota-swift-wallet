import Foundation
import SwiftUI
import IOTAWallet

protocol ISendViewModel: ObservableObject {
    var status: ViewStatus { get }
    var address: String { get }
    var amount: String { get set }
    var canSend: Bool { get }
    func onSendSelected()
    func onPasteSelected()
}

class SendViewModel: ISendViewModel {
    
    @Published var status: ViewStatus = .data
    @Published var address: String = "" {
        didSet {
            updateCanSend()
        }
    }
    @Published var amount: String = "" {
        didSet {
            updateCanSend()
        }
    }
    @Published var canSend: Bool = false
    func onSendSelected() {
        updateCanSend()
        guard canSend else { return }
        guard let theAmount = Int(amount) else { return }
        status = .loading
        let convertedAmount = Int(IotaUnitsConverter.convert(amount: Double(theAmount), fromUnit: .Mi, toUnit: .i))
        print(convertedAmount)
//        AppAccount?.sendTransfer(address: address, amount: convertedAmount, options: nil, onResult: { result in
//
//        })
    }
    
    func onPasteSelected() {
        var theAddress = UIPasteboard.general.string ?? ""
        #if targetEnvironment(simulator)
        theAddress = "atoi1qzqjcfypqa4hwwpr0yw3vn93m4npjaaexhncpwdsu7x4zrj9mtkuyew5hjx"
        #endif
        guard Bech32.decode(theAddress) != nil else { return }
        address = theAddress
    }
    
    fileprivate var isValidAmount: Bool {
        guard let theAmount = Int(amount) else { return false }
        if amount.starts(with: "0") { return false }
        if theAmount <= 0 { return false }
        return true
    }
    
    fileprivate func updateCanSend() {
        canSend = isValidAmount && !address.isEmpty
    }
}
