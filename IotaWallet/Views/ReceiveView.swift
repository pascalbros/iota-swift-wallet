import SwiftUI

struct ReceiveView<VM>: View where VM: IReceiveViewModel {
    
    @StateObject var viewModel: VM
    
    var body: some View {
        VStack {
            if viewModel.status == .loading {
                ProgressView()
            } else {
                AddressReceiveView(viewModel: viewModel) {
                    viewModel.onReload()
                }
            }
        }.onAppear {
            viewModel.onReload()
        }
    }
}

private struct AddressReceiveView<VM>: View where VM: IReceiveViewModel {
    
    @StateObject var viewModel: VM
    
    var onReload: () -> Void
    
    var body: some View {
        VStack {
            if let qrCode = viewModel.qrCode {
                Image(uiImage: qrCode)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            } else {
                ProgressView().padding()
            }
            Text(viewModel.address)
                .font(.title3)
                .frame(alignment: .center)
                .multilineTextAlignment(.center)
                .padding()
                .contextMenu {
                        Button(action: {
                            UIPasteboard.general.string = viewModel.address
                        }) {
                            Text("Copy to clipboard")
                            Image(systemName: "doc.on.doc")
                        }
                     }
            ButtonView(title: "Reload", color: .accentColor, onSelected: onReload)
        }
    }
}




struct ReceiveView_Previews: PreviewProvider {
    class _ReceiveViewModel: IReceiveViewModel {
        
        @Published var status: ViewStatus = .data
        @Published var address: String = ""
        @Published var qrCode: UIImage?
        
        func onReload() {
            self.status = .loading
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.status = .data
                self.address = "atoi1qzqjcfypqa4hwwpr0yw3vn93m4npjaaexhncpwdsu7x4zrj9mtkuyew5hjx"
                self.generateQRCode()
            }
        }
        
        func generateQRCode() {
            qrCode = nil
            DispatchQueue.main.async {
                self.qrCode = Utils.generateQRCode(from: self.address)
            }
        }
    }
    
    static var previews: some View {
        ReceiveView(viewModel: _ReceiveViewModel()).preferredColorScheme(.light)
    }
}
