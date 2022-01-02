import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            BalanceView(balance: 256)
                .tabItem {
                    Label("Balance", systemImage: "creditcard")
                }
            ContentView()
                .tabItem {
                    Label("Receive", systemImage: "banknote")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
