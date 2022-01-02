import SwiftUI

@main
struct IotaWalletApp: App {
    var body: some Scene {
        WindowGroup {
            AccountView(viewModel: AccountViewModel())
        }
    }
}
