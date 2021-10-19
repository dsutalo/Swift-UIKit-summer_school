//
//  ViewController.swift
//  Project4
//
//  Created by Domagoj Sutalo on 29.07.2021..
//

import UIKit
import WebKit

class WebViewController: UIViewController,WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    let websites = ["apple.com", "hackingwithswift.com"]
    
    var selectedPage: String?
    
    
    override func loadView() {
        setupWebView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupURL()
        setupRightBarButton()
        setupToolbar()
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func openPage(action: UIAlertAction){
        guard let actionTitle = action.title else{return}
        guard let url = URL(string: "https://" + actionTitle) else{return}
        webView.load(URLRequest(url:url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title 
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host{
            for website in websites{
                if host.contains(website){
                    decisionHandler(.allow)
                    return
                }
            }
            // block page if it's not in safe websites array
            let ac = UIAlertController(title: "Blocked", message: "Restricted page", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            present(ac, animated: true)
        }
        decisionHandler(.cancel)
    }
    
    func setupWebView(){
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    func setupRightBarButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
    }
    
    @objc func openTapped(){
        
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        for website in websites{
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac,animated: true)
    }
    
    func setupToolbar(){
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        let back = UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack))
        let forward = UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward))
        
        toolbarItems = [progressButton,spacer,refresh,back,forward]
        navigationController?.isToolbarHidden = false
    }
    
    func setupURL(){
        if let website = selectedPage{
            let url = URL(string: "https://" + website)!
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        }
        
    }
}

