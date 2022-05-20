import SwiftUI

@main
struct IotaWalletApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                PasswordView(viewModel: PasswordViewModel())
            }
        }
    }
}
