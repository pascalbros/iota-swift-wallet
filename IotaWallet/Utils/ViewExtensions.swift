import SwiftUI
import UIKit

struct ButtonView: View {
    @State var title: String
    @State var color: Color
    @State var height: CGFloat = 60
    var onSelected: () -> Void
    var body: some View {
        Button(action: onSelected)
        {
            HStack {
                Spacer()
                Text(title)
                Spacer()
            }
        }
        .font(.system(size: 17, weight: Font.Weight.bold))
        .frame(minWidth: 100, maxWidth: .infinity, minHeight: height, alignment: .center)
        .foregroundColor(.white)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
    }
}
