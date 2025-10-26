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
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 17, height: 22)
                                .foregroundStyle(.primary)
                        }
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
