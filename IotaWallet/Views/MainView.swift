import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            BalanceView(balance: 256)
                .tabItem {
                    Label("Balance", systemImage: "creditcard")
                }
            ReceiveView()
                .tabItem {
                    Label("Receive", systemImage: "banknote")
                }
            ContentView()
                .tabItem {
                    Label("Send", systemImage: "paperplane")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
