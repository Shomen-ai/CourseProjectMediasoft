import UIKit
import WebKit

class WebKitVC: UIViewController {

    let url = APIService().prepareUrlForAuth()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(webView)
        webViewConstraints()
        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))
    }

    weak var webView: WKWebView! = {
        let view = WKWebView()
        return view
    }()

    func webViewConstraints() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension WebKitVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let url = webView.url?.absoluteString else {return }
        if url.prefix(49) == "https://unsplash.com/oauth/authorize/native?code=" {
            print(url.dropFirst(49))
            AuthViewVC().code = String(url.dropFirst(49))
            self.dismiss(animated: true, completion: nil)
        }
    }
}
