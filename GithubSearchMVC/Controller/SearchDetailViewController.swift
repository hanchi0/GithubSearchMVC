//
//  SearchDetailViewController.swift
//  GithubSearchMVC
//
//  Created by 한지민 on 2022/03/17.
//

import UIKit
import WebKit

class SearchDetailViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    var repository: Repository?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = repository?.full_name
        
        if let urlString = repository?.html_url, let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
    }
}
