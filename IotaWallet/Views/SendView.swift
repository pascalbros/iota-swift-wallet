import SwiftUI

struct SendView<VM>: View where VM: ISendViewModel {
    
    @StateObject var viewModel: VM
    @State var progress: CGFloat = 0
    
    var body: some View {
        VStack {
            if viewModel.status == .loading {
                ProgressView()
            } else {
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
                    ButtonView(title: "Paste address", color: .orange, height: 40) {
                        viewModel.onPasteSelected()
                    }
                }
                HStack {
                    Text("Amount:")
                        .font(.title)
                        .bold()
                    Spacer()
                }.padding(EdgeInsets(top: 10, leading: 16, bottom: -18, trailing: 16))
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color.appText)
                        .frame(height: 80, alignment: .center)
                    HStack {
                        TextField("Amount in Mi", text: $viewModel.amount)
                            .textFieldStyle(PlainTextFieldStyle())
                            .keyboardType(.numberPad)
                            .foregroundColor(.appText)
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
                TriggerSlider(sliderView: {
                    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color.accentColor)
                        .overlay(Image(systemName: "arrow.right").font(.system(size: 30)).foregroundColor(.white))
                        .frame(width: 60, height: 60, alignment: .leading)
                }, textView: {
                    Text("Slide to Send").bold().foregroundColor(.white)
                },
                backgroundView: {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.accentColor.opacity(0.6))
                        .frame(height: 60, alignment: .center)
                }, offsetX: $progress,
                  didSlideToEnd: {
                    viewModel.onSendSelected()
                    progress = 0
                }, settings: TriggerSliderSettings(sliderViewHPadding: 10, sliderViewVPadding: 5, slideDirection: .right)).padding()
                    .frame(height: 60, alignment: .center)
                    .disabled(!viewModel.canSend)
                Spacer()
                //NavigationLink(destination: viewModel.buildNextView(), isActive: $viewModel.goToNextView) { EmptyView() }
            }
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
            status = .loading
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.status = .data
            }
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
