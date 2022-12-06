//
//  ViewController.swift
//  iOSVouchedWebview
//
//  Created by Jay Lorenzo on 4/18/22.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    
    // the handler name injected into the web app for iOS webviews.
    let vouchedHandler = "onVouchedVerify"
    var webView: WKWebView!
    var navBar: UIToolbar!
    // adjust the url and/or app public key to point to your instance
    let appUrl = "https://static.vouched.id/widget/demo/index.html#/"
    
    override func loadView() {
        let config = WKWebViewConfiguration()
        
        config.userContentController.add(self, name: vouchedHandler)
        config.allowsInlineMediaPlayback = true
        
        webView = WKWebView(frame: .zero, configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        view = webView
        setNavBar()

    }
    
    override func viewDidLoad() {
        let url = URL(string: appUrl)!
        webView.load(URLRequest(url: url))
    }
    
    // implements WKScriptMessageHandler. In this demo, we will look
    // for callbacks sent by vouchedHandler, and operate on them
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
    
    // uncomment this section to allow web links to be used, if they are targeting
    // this webview. Note: Make sure to limit this action to only operate on URLs
    // you deem trustworthy
    // thanks to https://dev.to/nemecek_f/how-to-open-blank-links-in-wkwebview-in-ios-24a
    /*
     func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if let frame = navigationAction.targetFrame,
                frame.isMainFrame {
                return nil
            }
            webView.load(navigationAction.request)
            // reveal a toolbar to allow user to navigate back to plugin
            navBar.isHidden = false
            return nil
    }
     */
    
    fileprivate func setNavBar() {
        let screenWidth = self.view.bounds.width
        // take up all the space on the right of the back button. To center, add
        // another flexspace to the left of the back button
        let flexSpaceR = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //let flexSpaceL = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let backButton = UIBarButtonItem(title: "Back", style:.plain, target: self, action: #selector(goBack))
        navBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        navBar.isTranslucent = false
        navBar.translatesAutoresizingMaskIntoConstraints = false
        // center the back button
        navBar.items = [backButton, flexSpaceR]
        webView.addSubview(navBar)
        navBar.sizeToFit()
        // align to bottom of the webview programmatically
        navBar.bottomAnchor.constraint(equalTo: webView.bottomAnchor, constant: 0).isActive = true
        navBar.leadingAnchor.constraint(equalTo: webView.leadingAnchor, constant: 0).isActive = true
        navBar.trailingAnchor.constraint(equalTo: webView.trailingAnchor, constant: 0).isActive = true
        navBar.isHidden = true
      }
      @objc private func goBack() {
          if webView.canGoBack {
              webView.goBack()
              navBar.isHidden = true
          }
      }

}


