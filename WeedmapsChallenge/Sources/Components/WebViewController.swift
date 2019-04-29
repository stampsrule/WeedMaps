//
//  WebViewController.swift
//  WeedmapsChallenge
//
//  Created by Daniel Bell on 4/28/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    var webView: WKWebView!
    private var url: URL?
    
    init(url urlString: String) {
        guard let myURL = URL(string:urlString) else {
            fatalError("url is not valid")
        }
        url = myURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.applicationNameForUserAgent = "Weedmaps Challenge"
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let myURL = url  else { return }
        let myRequest = URLRequest(url: myURL)
        webView.load(myRequest)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "title" {
            if let title = webView.title {
                navigationItem.title = title
            }
        }
    }
}

extension WebViewController: WKUIDelegate {
    
}
