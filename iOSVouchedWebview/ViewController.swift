//
//  ViewController.swift
//  iOSVouchedWebview
//
//  Created by Jay Lorenzo on 4/18/22.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    
    // the handler name injected into the web app for iOS webviews.
    let vouchedHandler = "onVouchedVerify"
    var webView: WKWebView!
    // adjust the url and/or app public key to point to your instance
    let appUrl = "https://static.vouched.id/widget/demo/index.html#/"
    
    override func loadView() {
        let config = WKWebViewConfiguration()
        
        config.userContentController.add(self, name: vouchedHandler)
        config.allowsInlineMediaPlayback = true
        
        webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        
        view = webView

    }
    
    override func viewDidLoad() {
        let url = URL(string: appUrl)!
        webView.load(URLRequest(url: url))
    }
    
    // implements WKScriptMessageHandler. For our callback, we will look
    // for messages sent by the vouchedHandler, and operate on them
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == vouchedHandler {
            
            guard let verifyData =
                    convertResponseToDict(payload: message.body as! String),
                  let results = verifyData["result"] as? [String: AnyObject],
                  let successCode = results["success"] as? Bool  else {
                print("Unable to process verification result")
                return
            }
            // todo: navigate according to success code, and/or results
            print("User was successfully verified: \(successCode)")
            print(results)
        }
    }
    
    // if using the iOS SDK, you can decode the payload into SDK objects,
    // but given we are bridging between two platforms, we'll create a
    // generic dictionary from the payload
    func convertResponseToDict(payload: String) -> [String:AnyObject]? {
        if let data = payload.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Unable to convert verification response")
            }
        }
        return nil
    }

}


