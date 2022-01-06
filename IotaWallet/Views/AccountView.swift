import SwiftUI

struct AccountView<VM>: View where VM: IAccountViewModel {
    @StateObject var viewModel: VM
    var body: some View {
        switch viewModel.status {
        case .loading:
            ProgressView()
        default:
            if let account = viewModel.account {
                SingleAccountView(title: account.name) {
                    print("Selected \(account.name)")
                }
            } else {
                NoAccountView() {
                    viewModel.createAccount()
                }
            }
        }
    }
}

struct SingleAccountView: View {
    @State var title: String
    var onSelected: () -> Void
    var body: some View {
        NavigationView {
            GenericAccountView(title: title,
                               label: AnyView(
                                    Text(String(title.first ?? "-"))
                                    .font(.title.weight(.bold))
                                    .foregroundColor(.white)),
                               onSelected: onSelected)
                                    .navigationTitle("Accounts")
        }
    }
}

struct NoAccountView: View {
    var onSelected: () -> Void
    var body: some View {
        GenericAccountView(title: "Add an account",
                           label: AnyView(
                                    Image(systemName: "plus")
                                        .renderingMode(.template)
                                        .font(.title.weight(.bold))
                                        .foregroundColor(.white)),
                           onSelected: onSelected)
    }
}

struct GenericAccountView: View {
    @State var title: String
    @State var label: AnyView
    var onSelected: () -> Void
    var body: some View {
        VStack {
            Button(action: onSelected, label: {
                label
            })
            .frame(width: UIScreen.main.bounds.width*0.3, height: UIScreen.main.bounds.width*0.3, alignment: .center)
            .background(Color.accentColor)
            .clipShape(Circle())
            .shadow(color: .appText.opacity(0.4), radius: 30, x: 0, y: 0)
            Text(title)
                .foregroundColor(.appText)
                .font(.title)
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    
    class _AccountViewModel: IAccountViewModel {
        var account: Account? = Account(name: "Pascal")
        var status: ViewStatus = .data
        func createAccount() { }
    }
    static var previews: some View {
        AccountView(viewModel: _AccountViewModel()).preferredColorScheme(.light)
    }
}
