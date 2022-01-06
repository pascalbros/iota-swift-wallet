import SwiftUI

struct AddSeedView: View {
    @State var words: [String] = Array(repeating: "", count: 24)
    
    var body: some View {
        NavigationView {
            VStack {
                List(words.indices) { index in
                    HStack {
                        Text("\(index+1)")
                            .font(.title3)
                            .foregroundColor(.gray)
                            .frame(width: 30, alignment: .leading)
                        TextField("", text: $words[index])
                            .font(.title3)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                }
                ButtonView(title: "Paste all words", color: .orange) {
                    pasteWords()
                }
                ButtonView(title: "Continue", color: .accentColor) {
                    
                }.disabled(areWordsValid)
            }
            .navigationTitle("Mnemonic phrase")
            
        }
    }
    
    private var areWordsValid: Bool {
        return words.contains("") && words.count == Set(words).count
    }
    
    private func pasteWords() {
        for i in 0..<words.count {
            words[i] = "\(i)"
        }
    }
}

struct AddSeedView_Previews: PreviewProvider {
    static var previews: some View {
        AddSeedView()
    }
}
