import SwiftUI

struct QuoteCardPreview: View {

    let text: String
    let author: String
    let style: BackgroundStyle
    let fontSize: CGFloat
    let alignment: TextAlignment
    let isSquare: Bool

    var body: some View {
        VStack {
            Text("“\(text)”")
                .font(.system(size: fontSize, weight: .medium))
                .foregroundColor(.white)
                .multilineTextAlignment(alignment)
                .padding()

            Text(author)
                .foregroundColor(.teal)
                .font(.caption)
        }
        .frame(
            width: isSquare ? 300 : nil,
            height: isSquare ? 300 : nil
        )
        .background(style.background)
        .cornerRadius(20)
    }
}
