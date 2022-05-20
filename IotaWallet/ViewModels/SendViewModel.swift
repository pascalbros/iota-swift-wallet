import Foundation
import SwiftUI
import IOTAWallet

protocol ISendViewModel: ObservableObject {
    var status: ViewStatus { get }
    var address: String { get }
    var amount: String { get set }
    var canSend: Bool { get }
    var presentAlert: Bool { get }
    var alert: Alert! { get }
    func onSendSelected()
    func onPasteSelected()
    func onErrorMessageSelected()
    func onSuccessMessageSelected()
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
    @Published var presentAlert: Bool = false
    var alert: Alert!

    func onSendSelected() {
        Utils.endTextEditing()
        updateCanSend()
        guard canSend else { return }
        guard let theAmount = Int(amount) else { return }
        status = .loading
        let convertedAmount = Int(IotaUnitsConverter.convert(amount: Double(theAmount), fromUnit: .Mi, toUnit: .i))
        AppAccount?.sendTransfer(address: address, amount: convertedAmount, options: nil, onResult: { result in
            switch result {
            case .success: self.onTransactionSucceded()
            case .failure: self.onTransactionError()
            }
        })
    }
    
    func onPasteSelected() {
        var theAddress = UIPasteboard.general.string ?? ""
        #if targetEnvironment(simulator)
        theAddress = "atoi1qzqjcfypqa4hwwpr0yw3vn93m4npjaaexhncpwdsu7x4zrj9mtkuyew5hjx"
        #endif
        guard Bech32.decode(theAddress) != nil else { return }
        address = theAddress
        Utils.endTextEditing()
    }

    func onErrorMessageSelected() {
        status = .data
        presentAlert = false
    }

    func onSuccessMessageSelected() {
        status = .data
        presentAlert = false
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
    
    fileprivate func onTransactionSucceded() {
        address = ""
        amount = ""
        status = .data
        alert = Alert(title: Text("Success!"), message: Text("✅ Transaction executed succesfully!"), dismissButton: .default(Text("OK"), action: {
            self.onSuccessMessageSelected()
        }))
        presentAlert = true
    }

    fileprivate func onTransactionError() {
        status = .error
        alert = Alert(title: Text("Transaction error"), message: Text("❌ Unable to complete the transaction"), dismissButton: .default(Text("OK"), action: {
            self.onErrorMessageSelected()
        }))
        presentAlert = true
    }
}
