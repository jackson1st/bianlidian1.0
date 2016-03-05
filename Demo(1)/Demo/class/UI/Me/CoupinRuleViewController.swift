//
//  CoupinRuleViewController.swift
//  Demo
//
//  Created by 黄人煌 on 16/3/3.
//  Copyright © 2016年 Fjnu. All rights reserved.
//

import UIKit

class CoupinRuleViewController: BaseViewController {
    
    private let webView = UIWebView(frame: CGRectMake(0, 0, AppWidth, AppHeight))
    private let loadProgressAnimationView: LoadProgressAnimationView = LoadProgressAnimationView(frame: CGRectMake(0, NavigationH, AppWidth, 3))
    var loadURLStr: String? {
        didSet {
            webView.loadRequest(NSURLRequest(URL: NSURL(string: loadURLStr!)!))
        }
    }
    
    var navTitle: String? {
        didSet {
            navigationItem.title = navTitle
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        buildWebView()
        webView.addSubview(loadProgressAnimationView)
    }
    
    private func buildWebView() {
        webView.delegate = self
        webView.backgroundColor = UIColor.whiteColor()
        view.addSubview(webView)
    }
}

extension CoupinRuleViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(webView: UIWebView) {
        loadProgressAnimationView.startLoadProgressAnimation()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        loadProgressAnimationView.endLoadProgressAnimation()
    }
}

