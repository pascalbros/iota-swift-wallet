import SwiftUI

struct NewSeedView<VM>: View where VM: INewSeedViewModel {
    
    @StateObject var viewModel: VM
    
    var body: some View {
        if viewModel.status == .loading {
            ProgressView()
        } else {
            WordsView(viewModel: viewModel)
        }
        NavigationLink(destination: viewModel.buildNextView(), isActive: $viewModel.goToNextView) { EmptyView() }
    }
}

private struct WordsView<VM>: View where VM: INewSeedViewModel {
    
    @StateObject var viewModel: VM

    var body: some View {
        ScrollView {
            VStack {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
                    ForEach((1...viewModel.words.count), id: \.self) { i in
                        Text("\(i). \(viewModel.words[i-1])")
                            .font(.title2.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                    }
                }
                ButtonView(title: "Copy mnemonic", color: .orange) {
                    viewModel.onCopyMnemonicSelected()
                }
                ButtonView(title: "Create wallet", color: .accentColor) {
                    viewModel.onCreateSelected()
                }
            }
        }.navigationTitle("Your mnemonic")
    }
}

struct NewSeedView_Previews: PreviewProvider {
    class _NewSeedViewModel: INewSeedViewModel {
        
        @Published var status: ViewStatus = .data
        @Published var words: [String] = []
        @Published var goToNextView: Bool = false
        
        init() {
            generateMnemonic()
        }
        
        fileprivate func generateMnemonic() {
            words = "clever cross decorate deliver daughter smart evoke clinic furnace quarter wave shine tattoo amazing wrong file dance half obey horror ribbon win person gossip".split(separator: " ").map { String($0) }
        }
        
        func onCopyMnemonicSelected() { }
        
        func onCreateSelected() {
            guard !words.isEmpty else { return }
            goToNextView = true
        }
        
        func buildNextView() -> AnyView {
            return AnyView(Text("OK"))
        }
    }

    static var previews: some View {
        NavigationView {
            NewSeedView(viewModel: _NewSeedViewModel())
        }
    }
}
