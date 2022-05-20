import SwiftUI

struct PasswordView<VM>: View where VM: IPasswordViewModel {
    @StateObject var viewModel: VM
    
    var body: some View {
        VStack {
            if viewModel.status == .loading {
                ProgressView()
                    .padding(85)
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color.appText)
                        .frame(height: 80, alignment: .center)
                    SecureField("Stronghold password", text: $viewModel.password)
                        .textFieldStyle(PlainTextFieldStyle())
                        .foregroundColor(.appText)
                        .font(.title3)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding()
                }.padding()
                ButtonView(title: "Continue", color: .accentColor) {
                    viewModel.onConfirm()
                }.disabled(viewModel.password.count < 3)
            }
            Text("A password is needed in order to unlock the wallet, if it's your first time, type a new one")
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                .font(.subheadline)
            Spacer()
            NavigationLink(destination: viewModel.buildNextView(), isActive: $viewModel.goToNextView) { EmptyView() }
        }
        .navigationTitle("Enter Password")
        .alert(isPresented: Binding(get: { viewModel.status == .error }, set: { _,_ in })) {
            Alert(title: Text("Password error"), message: Text("Unable to log you in"), dismissButton: .default(Text("OK")))
        }.onDisappear {
            viewModel.onErrorDisappeared()
        }
    }
}

struct PasswordView_Previews: PreviewProvider {
    
    class _PasswordViewModel: IPasswordViewModel {
        @Published var goToNextView: Bool = false
        @Published var password: String = ""
        @Published var status: ViewStatus = .data
        func onConfirm() {
            status = .loading
            Utils.endTextEditing()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.status = .error
            }
        }
        func onErrorDisappeared() {
            status = .data
        }
        
        func buildNextView() -> AnyView {
            AnyView(Text("OK"))
        }
    }
    
    static var previews: some View {
        PasswordView<_PasswordViewModel>(viewModel: _PasswordViewModel())
    }
}
