import SwiftUI

struct BalanceView: View {
    @State var balance: Int
    var body: some View {
        CardView(title: "Balance", details: BalanceView.getBalance(balance))
    }
                 
    fileprivate static func getBalance(_ value: Int) -> String {
        "\(value) Mi"
    }
}

struct CardView: View {
    @State var title: String
    @State var details: String
    
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
        }
        .padding(20)
        .frame(height: 200, alignment: .center)
    }
}

struct BalanceView_Previews: PreviewProvider {
    static var previews: some View {
        BalanceView(balance: 256)
    }
}
