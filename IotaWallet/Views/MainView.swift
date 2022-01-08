import SwiftUI

struct MainView: View {
    
    var titles = ["Balance", "Receive", "Send"]
    @State var selection: Int = 0
    
    var body: some View {
        TabView(selection: $selection) {
            BalanceView(balance: 256)
                .tabItem {
                    Label(titles[0], systemImage: "creditcard")
                }
                .tag(0)
            ReceiveView()
                .tabItem {
                    Label(titles[1], systemImage: "banknote")
                }
                .tag(1)
            ContentView()
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
