import SwiftUI
import WebKit

struct AgreementWebView: View {
    let urlString: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            WebContainer(urlString: urlString)
                .navigationTitle("Пользовательское соглашение")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        BackChevron()
                            .padding(.leading, -8)
                    }
                }
                .background(.ypWhite)
        }
        .background(.ypWhite)
    }
}

private struct WebContainer: UIViewRepresentable {
    let urlString: String

    func makeUIView(context: Context) -> WKWebView { WKWebView() }

    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let url = URL(string: urlString) else { return }
        if webView.url != url {
            webView.load(URLRequest(url: url))
        }
    }
}
