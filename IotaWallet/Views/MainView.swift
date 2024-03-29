import SwiftUI

struct MainView: View {
    
    var titles = ["Balance", "Receive", "Send"]
    @State var selection: Int = 0
    
    var body: some View {
        TabView(selection: $selection) {
            BalanceView(viewModel: BalanceViewModel())
                .tabItem {
                    Label(titles[0], systemImage: "creditcard")
                }
                .tag(0)
            ReceiveView(viewModel: ReceiveViewModel())
                .tabItem {
                    Label(titles[1], systemImage: "banknote")
                }
                .tag(1)
            SendView(viewModel: SendViewModel())
                .tabItem {
                    Label(titles[2], systemImage: "paperplane")
                }
                .tag(2)
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle(titles[selection])
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
