import SwiftUI
import UIKit

struct ButtonView: View {
    @State var title: String
    @State var color: Color
    var onSelected: () -> Void
    var body: some View {
        Button(title, action: onSelected)
            .font(.system(size: 17, weight: Font.Weight.bold))
            .frame(minWidth: 100, maxWidth: .infinity, minHeight: 60, alignment: .center)
            .foregroundColor(.white)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
    }
}
