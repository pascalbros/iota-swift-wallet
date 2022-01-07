import SwiftUI

struct NewAccountView: View {
    var body: some View {
        VStack(spacing: 50) {
            ButtonView(title: "I need to generate a new one", color: Color.orange) {
                
            }
            ButtonView(title: "I have a mnemonic phrase", color: Color.accentColor) {
                
            }
        }
        .padding(30)
        .navigationTitle("Seed")
    }
}

struct NewAccountView_Previews: PreviewProvider {
    static var previews: some View {
        NewAccountView().previewDevice("iPhone 12").preferredColorScheme(.light)
    }
}
