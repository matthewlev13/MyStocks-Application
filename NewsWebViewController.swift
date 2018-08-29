//
//  NewsWebViewController.swift
//  MyStocks
//
//  Created by Matthew  Levis on 7/16/18.
//  Copyright © 2018 Matthew  Levis. All rights reserved.
//
//  NewsWebViewController brings up url source of article and inherits from UIWebViewDelegate and WKUIDelegate


import UIKit
import WebKit

class NewsWebViewController: UIViewController, UIWebViewDelegate, WKUIDelegate {
    
    var article: Article!                           // reference to article just tapped
    @IBOutlet var webView: WKWebView!
    @IBOutlet var newsNavigationBar: UINavigationBar!
    
    
    // Launches the url in a web view
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView()
        let newsUrl = URL(string: article.url!)
        let request = URLRequest(url: newsUrl!)
        self.navigationItem.title = article.headline
        webView.load(request)
        view = webView
    }
}
