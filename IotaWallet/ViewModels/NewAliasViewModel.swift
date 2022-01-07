import Foundation
import SwiftUI

protocol INewAliasViewModel: ObservableObject {
    var status: ViewStatus { get }
    var alias: String { get set }
    var goToNextView: Bool { get set }
    func buildNextView() -> AnyView
    func onConfirm()
}

class NewAliasViewModel: INewAliasViewModel {
    @Published var alias: String = ""
    @Published var status: ViewStatus = .loading
    @Published var goToNextView: Bool = false
    
    func onConfirm() {
        goToNextView = true
    }
    
    func buildNextView() -> AnyView {
        return AnyView(NewAccountView())
    }
}
