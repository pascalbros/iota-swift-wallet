import Foundation
import SwiftUI
import IOTAWallet

protocol IReceiveViewModel: ObservableObject {
    var status: ViewStatus { get }
    var address: String { get }
    var qrCode: UIImage? { get }
    func onReload()
}

class ReceiveViewModel: IReceiveViewModel {
    
    @Published var status: ViewStatus = .data
    @Published var address: String = "" {
        didSet(oldValue) {
            guard oldValue != address else { return }
            generateQRCode()
        }
    }
    @Published var qrCode: UIImage?

    func onReload() {
        self.status = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            AppAccount?.sync(onResult: { _ in
                AppAccount?.generateAddress(onResult: { result in
                    switch result {
                    case .success(let address):
                        self.address = address.address
                        self.status = .data
                    case .failure:
                        self.status = .error
                    }
                })
            })
        }
    }
    
    fileprivate func generateQRCode() {
        qrCode = nil
        DispatchQueue.main.async {
            self.qrCode = Utils.generateQRCode(from: self.address)
        }
    }
}
