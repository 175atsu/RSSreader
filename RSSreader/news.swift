//
//  news.swift
//  RSSreader
//
//  Created by 飯野敦博 on 2018/09/14.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class WKViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string:"https://www.apple.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }}
