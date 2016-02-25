//
//  RecommendViewController.swift
//  Created by 黄人煌 on 15/12/28.
//  Copyright © 2015年 Fjnu. All rights reserved.
//
//  应用推荐

import UIKit

class RecommendViewController: UIViewController {

    private lazy var webView: UIWebView! = {
        let webView = UIWebView(frame: MainBounds)
        let url = NSURL(string: "http://www.jianshu.com/users/5fe7513c7a57/latest_articles")!
        webView.loadRequest(NSURLRequest(URL: url))
        webView.delegate = self
        return webView
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tabBarController!.tabBar.hidden = true
        self.title = "应用推荐"
        view.backgroundColor = theme.SDWebViewBacagroundColor
        view.addSubview(webView)
    }

}

extension RecommendViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(webView: UIWebView) {
       
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {

    }
    
}