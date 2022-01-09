import SwiftUI

struct NewAliasView<VM>: View where VM: INewAliasViewModel {
    @StateObject var viewModel: VM
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(Color.appText)
                    .frame(height: 80, alignment: .center)
                TextField("Type your account alias", text: $viewModel.alias)
                    .textFieldStyle(PlainTextFieldStyle())
                    .foregroundColor(.appText)
                    .font(.title3)
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                    .padding()
            }.padding()
            ButtonView(title: "Continue", color: .accentColor) {
                viewModel.onConfirm()
            }.disabled(viewModel.alias.count < 3 && viewModel.alias.count < 30)
            Text("The alias will be associated to your seed")
                .padding()
                .font(.subheadline)
            Spacer()
            NavigationLink(destination: viewModel.buildNextView(), isActive: $viewModel.goToNextView) { EmptyView() }
        }
        .navigationTitle("Account alias")
    }
}

struct NewAliasView_Previews: PreviewProvider {
    
    class _NewAliasViewModel: INewAliasViewModel {
        @Published var alias: String = ""
        @Published var status: ViewStatus = .data
        @Published var goToNextView: Bool = false

        func onConfirm() {
            Utils.endTextEditing()
            goToNextView = true
        }
        func buildNextView() -> AnyView {
            return AnyView(Text("OK!"))
        }
    }
    
    static var previews: some View {
        NewAliasView<_NewAliasViewModel>(viewModel: _NewAliasViewModel())
    }
}
