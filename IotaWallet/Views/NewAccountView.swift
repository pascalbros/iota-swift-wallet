import SwiftUI

struct NewAccountView<VM>: View where VM: INewAccountViewModel {
    
    @StateObject var viewModel: VM
    
    var body: some View {
        VStack(spacing: 50) {
            ButtonView(title: "I need to generate a new one", color: Color.orange) {
                viewModel.onNewSeedSelected()
            }
            ButtonView(title: "I have a mnemonic phrase", color: Color.accentColor) {
                viewModel.onAddSeedSelected()
            }
            NavigationLink(destination: viewModel.buildNewSeedView(), isActive: $viewModel.goToNewSeed) { EmptyView() }
            NavigationLink(destination: viewModel.buildAddSeedView(), isActive: $viewModel.goToAddSeed) { EmptyView() }
        }
        .padding(30)
        .navigationTitle("Seed")
    }
}

struct NewAccountView_Previews: PreviewProvider {
    
    class _NewAccountViewModel: INewAccountViewModel {
        @Published var goToNewSeed: Bool = false
        @Published var goToAddSeed: Bool = false
        
        func onNewSeedSelected() { goToNewSeed = true }
        func onAddSeedSelected() { goToAddSeed = true }
        func buildNewSeedView() -> AnyView {
            return AnyView(Text("New Seed"))
        }
        func buildAddSeedView() -> AnyView {
            return AnyView(Text("Add Seed"))
        }
    }
    
    static var previews: some View {
        NewAccountView(viewModel: _NewAccountViewModel()).preferredColorScheme(.light)
    }
}
