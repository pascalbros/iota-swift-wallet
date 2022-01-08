import Foundation
import SwiftUI

protocol INewAccountViewModel: ObservableObject {
    var goToNewSeed: Bool { get set }
    var goToAddSeed: Bool { get set }
    func onNewSeedSelected()
    func onAddSeedSelected()
    func buildNewSeedView() -> AnyView
    func buildAddSeedView() -> AnyView
}

class NewAccountViewModel: INewAccountViewModel {
    @Published var goToNewSeed: Bool = false
    @Published var goToAddSeed: Bool = false
    
    func onNewSeedSelected() {
        goToNewSeed = true
    }
    
    func onAddSeedSelected() {
        goToAddSeed = true
    }
    
    func buildNewSeedView() -> AnyView {
        return AnyView(NewSeedView(viewModel: NewSeedViewModel()))
    }
    
    func buildAddSeedView() -> AnyView {
        return AnyView(AddSeedView())
    }
}
