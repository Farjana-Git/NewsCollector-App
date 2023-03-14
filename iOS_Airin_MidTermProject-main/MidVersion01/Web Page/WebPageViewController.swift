//
//  WebPageViewController.swift
//  MidVersion01
//
//  Created by Bjit on 18/1/23.
//

import UIKit
import WebKit

class WebPageViewController: UIViewController {
    
    var url: String = "https://www.google.com/"
    
    
    @IBOutlet weak var WKWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let request = URLRequest(url: URL(string: url)!)
        self.WKWebView.load(request)
    }
    
}
