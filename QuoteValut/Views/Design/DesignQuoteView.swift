import SwiftUI

struct DesignQuoteView: View {

    // MARK: - Inputs
    let quote: Quote

    // MARK: - Environment
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authVM: AuthViewModel
    @State private var shareImage: UIImage?
    @State private var showShare = false

    // MARK: - ViewModels
    @StateObject private var designVM = DesignQuoteViewModel()

    // MARK: - Design State
    @State private var selectedStyle: BackgroundStyle = .minimalist
    @State private var fontSize: CGFloat = 24
    @State private var alignment: TextAlignment = .center
    @State private var isSquare: Bool = true
    @State private var editableText: String

    // MARK: - Init
    init(quote: Quote) {
        self.quote = quote
        _editableText = State(initialValue: quote.text)
    }

    // MARK: - Body
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {

                    header
                    quotePreview
                    editableTextEditor
                    formatToggle
                    backgroundStyles
                    alignmentPicker
                    fontSizeSlider
                    actions
                }
                .padding()
            }
        }
    }
}

// MARK: - Subviews
private extension DesignQuoteView {

    // MARK: Header
    var header: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
            }

            Spacer()

            Text("Design Quote")
                .foregroundColor(.white)
                .font(.headline)

            Spacer()

            Image(systemName: "ellipsis")
                .foregroundColor(.white)
        }
    }

    // MARK: Quote Preview (Rendered Card)
    var quotePreview: some View {
        QuoteCardPreview(
            text: editableText,
            author: quote.author,
            style: selectedStyle,
            fontSize: fontSize,
            alignment: alignment,
            isSquare: isSquare
        )
    }

    // MARK: Editable Text
    var editableTextEditor: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("EDIT TEXT")
                .foregroundColor(.gray)
                .font(.caption)

            TextEditor(text: $editableText)
                .frame(minHeight: 120)
                .padding()
                .foregroundColor(.white)
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
        }
    }

    // MARK: Format Toggle
    var formatToggle: some View {
        HStack(spacing: 16) {
            toggleButton("Square", isActive: isSquare) { isSquare = true }
            toggleButton("Story", isActive: !isSquare) { isSquare = false }
        }
    }

    func toggleButton(_ title: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(isActive ? .black : .white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(isActive ? Color.teal : Color.white.opacity(0.1))
                .cornerRadius(16)
        }
    }

    // MARK: Background Styles
    var backgroundStyles: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("BACKGROUND STYLE")
                .foregroundColor(.gray)
                .font(.caption)

            HStack(spacing: 12) {
                ForEach(BackgroundStyle.allCases) { style in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(style.background)
                        .frame(width: 60, height: 60)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(style == selectedStyle ? Color.teal : .clear, lineWidth: 2)
                        )
                        .onTapGesture {
                            selectedStyle = style
                        }
                }
            }
        }
    }

    // MARK: Alignment Picker
    var alignmentPicker: some View {
        HStack {
            Text("ALIGNMENT")
                .foregroundColor(.gray)
                .font(.caption)

            Spacer()

            alignmentButton(.leading, "text.alignleft")
            alignmentButton(.center, "text.aligncenter")
            alignmentButton(.trailing, "text.alignright")
        }
    }

    func alignmentButton(_ align: TextAlignment, _ icon: String) -> some View {
        Button {
            alignment = align
        } label: {
            Image(systemName: icon)
                .foregroundColor(alignment == align ? .teal : .white)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
        }
    }

    // MARK: Font Size
    var fontSizeSlider: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("FONT SIZE")
                    .foregroundColor(.gray)
                    .font(.caption)

                Spacer()

                Text("\(Int(fontSize)) px")
                    .foregroundColor(.teal)
                    .font(.caption)
            }

            Slider(value: $fontSize, in: 16...40)
                .tint(.teal)
        }
    }

    // MARK: Actions
    var actions: some View {
        VStack(spacing: 12) {

            Button {
                guard let userId = authVM.userId else { return }

                Task {
                    await designVM.saveDesignedQuote(
                        userId: userId,
                        quote: quote,
                        style: selectedStyle,
                        fontSize: fontSize,
                        alignment: alignment,
                        isSquare: isSquare
                    )
                }
            } label: {
                Label("Save Design", systemImage: "tray.and.arrow.down")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PrimaryButtonStyle())

            Button {
                shareText()
            } label: {
                Label("Share Text", systemImage: "square.and.arrow.up")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            Button {
                shareImage = renderImage()
                showShare = true
            } label: {
                Label("Share Image", systemImage: "photo")
            }
            .buttonStyle(.bordered)
            .sheet(isPresented: $showShare) {
                if let image = shareImage {
                    ShareSheet(items: [image])
                }
            }        }
    }
}

// MARK: - Helpers
private extension DesignQuoteView {
    
    func renderImage() -> UIImage {
        let renderer = ImageRenderer(
            content:
                QuoteCardPreview(
                    text: editableText,
                    author: quote.author,
                    style: selectedStyle,
                    fontSize: fontSize,
                    alignment: alignment,
                    isSquare: isSquare
                )
                .frame(width: 300, height: isSquare ? 300 : 500)
        )
        
        renderer.scale = UIScreen.main.scale
        return renderer.uiImage!
    }
    func shareText() {
        let text = """
        "\(editableText)"
        — \(quote.author)
        """

        shareImage = nil
        showShare = true
    }
    
    
    // MARK: - Button Style
    struct PrimaryButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding()
                .background(Color.teal)
                .foregroundColor(.white)
                .cornerRadius(16)
                .opacity(configuration.isPressed ? 0.7 : 1)
        }
    }
}
