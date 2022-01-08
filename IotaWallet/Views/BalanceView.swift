import SwiftUI

struct BalanceView<VM>: View where VM: IBalanceViewModel {
    
    @StateObject var viewModel: VM
    
    var body: some View {
        ZStack {
            if viewModel.status == .loading {
                ProgressView()
            } else {
                CardView(title: "Balance", details: viewModel.formattedBalance) {
                    viewModel.onReload()
                }
            }
        }.onAppear {
            viewModel.onReload()
        }
    }
}

struct CardView: View {
    @State var title: String
    @State var details: String
    var onReload: (() -> Void)
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.accentColor)
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 0)
            VStack {
                Text(title)
                    .foregroundColor(.white)
                    .font(.system(size: 22).bold())
                Text(details)
                    .foregroundColor(.white)
                    .font(.system(size: 33).bold())
            }
            GeometryReader { geometry in
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                onReload()
                            }, label: {
                                Image(systemName: "arrow.clockwise").renderingMode(.template).padding()
                            })
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }

                }
                .edgesIgnoringSafeArea(.all)
        }
        .padding(20)
        .frame(height: 200, alignment: .center)
    }
}

struct BalanceView_Previews: PreviewProvider {
    class _BalanceViewModel: IBalanceViewModel {
        
        @Published var status: ViewStatus = .data
        @Published var balance: Int = 0 {
            didSet { formattedBalance = "\(balance) Mi" }
        }
        @Published var formattedBalance: String  = ""
        
        func onReload() {
            getBalance()
        }
        
        fileprivate func getBalance() {
            balance = 125
        }
    }

    static var previews: some View {
        BalanceView(viewModel: _BalanceViewModel())
    }
}
