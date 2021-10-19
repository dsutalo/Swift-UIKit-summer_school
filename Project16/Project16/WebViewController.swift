//
//  WebViewController.swift
//  Project16
//
//  Created by Domagoj Sutalo on 17.08.2021..
//

import UIKit
import WebKit

class WebViewController: UIViewController{
    var webView: WKWebView!
    var capitalCityName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        openURL()
    }
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    func openURL(){
        guard let url = URL(string: "http://wikipedia.org/wiki/" + capitalCityName) else {return}
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
}

