import SwiftUI

struct NewSeedView: View {
    
    @State var words: [String]?
    
    var body: some View {
        NavigationView {
            if let words = words {
                WordsView(words: words)
            } else {
                ProgressView()
            }
        }
    }
}

private struct WordsView: View {
    @State var words: [String]
    var body: some View {
        ScrollView {
            VStack {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
                    ForEach((1...words.count), id: \.self) { i in
                        Text("\(i). \(words[i-1])")
                            .font(.title2.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                    }
                }
                ButtonView(title: "Copy mnemonic", color: .orange) {
                }
                ButtonView(title: "Create wallet", color: .accentColor) {
                }
            }
        }.navigationTitle("Your mnemonic")
    }
}

struct NewSeedView_Previews: PreviewProvider {
    static var previews: some View {
        NewSeedView(words: "clever cross decorate deliver daughter smart evoke clinic furnace quarter wave shine tattoo amazing wrong file dance half obey horror ribbon win person gossip".split(separator: " ").map { String($0) })
    }
}
