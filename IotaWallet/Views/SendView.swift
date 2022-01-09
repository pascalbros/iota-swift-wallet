import SwiftUI

struct SendView<VM>: View where VM: ISendViewModel {
    
    @StateObject var viewModel: VM
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("To:")
                        .font(.title)
                        .bold()
                    Text(viewModel.address)
                        .font(.title2)
                    Spacer()
                }
                .font(.title)
                .padding()
                HStack {
                    ButtonView(title: "Paste address", color: .orange, height: 40) {
                        viewModel.onPasteSelected()
                    }
                }
            }
            HStack {
                Text("Amount:")
                    .font(.title)
                Spacer()
            }.padding(EdgeInsets(top: 10, leading: 16, bottom: -18, trailing: 16))
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(.black)
                    .frame(height: 80, alignment: .center)
                HStack {
                    TextField("Amount in Mi", text: $viewModel.amount)
                        .textFieldStyle(PlainTextFieldStyle())
                        .keyboardType(.numberPad)
                        .foregroundColor(.black)
                        .font(.title)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding()
                    Text("Mi")
                        .font(.title)
                        .bold()
                        .padding()
                }
            }.padding()
            ButtonView(title: "Send", color: .accentColor) {
                viewModel.onSendSelected()
            }.disabled(!viewModel.canSend)
            Spacer()
            //NavigationLink(destination: viewModel.buildNextView(), isActive: $viewModel.goToNextView) { EmptyView() }
        }
    }
}

struct SendView_Previews: PreviewProvider {
    class _SendViewModel: ISendViewModel {
        
        @Published var status: ViewStatus = .data
        @Published var address: String = ""
        @Published var amount: String = ""
        @Published var canSend: Bool = true

        func onSendSelected() {
            
        }
        
        func onPasteSelected() {
            
        }
    }
    
    static var previews: some View {
        NavigationView {
            SendView(viewModel: _SendViewModel()).navigationTitle("Send")
        }
    }
}
