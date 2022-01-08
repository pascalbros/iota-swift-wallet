import SwiftUI

struct AddSeedView<VM>: View where VM: IAddSeedViewModel {
    
    @StateObject var viewModel: VM
    
    var body: some View {
        VStack {
            List(viewModel.words.indices) { index in
                HStack {
                    Text("\(index+1)")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .frame(width: 30, alignment: .leading)
                    TextField("", text: $viewModel.words[index])
                        .font(.title3)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
            }
            ButtonView(title: "Paste words", color: .orange) {
                viewModel.onPasteMnemonicSelected()
            }
            ButtonView(title: "Continue", color: .accentColor) {
                viewModel.onContinueSelected()
            }.disabled(!areWordsValid)
            NavigationLink(destination: viewModel.buildNextView(), isActive: $viewModel.goToNextView) { EmptyView() }
        }
        .navigationTitle("Mnemonic phrase")
    }
    
    private var areWordsValid: Bool {
        return !viewModel.words.contains("") && viewModel.words.count == 24
    }
}

struct AddSeedView_Previews: PreviewProvider {
    class _AddSeedViewModel: IAddSeedViewModel {
        
        @Published var status: ViewStatus = .data
        @Published var words: [String] = Array(repeating: "", count: 24)
        @Published var goToNextView: Bool = false
        
        func onPasteMnemonicSelected() {
            (0..<words.count).forEach { words[$0] = "\($0)" }
        }
        
        func onContinueSelected() {
            goToNextView = true
        }
        func buildNextView() -> AnyView {
            return AnyView(Text("OK"))
        }
    }
    static var previews: some View {
        NavigationView {
            AddSeedView(viewModel: _AddSeedViewModel())
        }
    }
}
