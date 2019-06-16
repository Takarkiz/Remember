//
//  WebViewController.swift
//  ReMember
//
//  Created by 澤田昂明 on 2019/06/16.
//  Copyright © 2019 澤田昂明. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    private var webView: WKWebView!
    var urlString: String = "https://firebasestorage.googleapis.com/v0/b/remember-4ec53.appspot.com/o/mp4%2F1E6ABD01-B50A-491A-B8C0-85689D484A27%2Fout.mp4?alt=media"
    let config = WKWebViewConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config.allowsInlineMediaPlayback = true
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        let url = NSURL(string: encodedUrlString!)
        let request = NSURLRequest(url: url! as URL)
        
        webView.load(request as URLRequest)
        
        self.view.addSubview(webView)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}
