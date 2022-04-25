//
//  ViewController.swift
//  iOSVouchedWebview
//
//  Created by Jay Lorenzo on 4/18/22.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    
    var webView: WKWebView!
    // adjust the url and app public key to point to your instance
    static let appKey: String = "YOUR_APP_KEY_HERE"
    let appUrl: String =  "https://static.vouched.id/widget/demo/index.html#/demo?recognizeIDThreshold=0.81&cardIDThreshold=0.2&generalThreshold=0.9&glareQualityThreshold=0.6&qualityThreshold=0.6&selfieThreshold=0&holdSteadyIntervalFace=1250&detectorRunFrameInterval=2&stepTitles%5BFrontId%5D=Upload%20ID&stepTitles%5BFace%5D=Upload%20Headshot&stepTitles%5BDone%5D=Finished&stepTitles%5BID_Captured%5D=ID%20Captured&stepTitles%5BFace_Captured%5D=Face%20Captured&stepTitles%5BStart%5D=Start&stepTitles%5BBackId%5D=ID%20%28Back%29&content%5BcrossDeviceShowOff%5D=true&showUploadFirst=true&showProgressBar=true&appId=\(appKey)&testingUri=https%3A%2F%2Fverify.vouched.id%2F&crossDeviceQRCode=false&crossDeviceHandoff=false&crossDevice=false&crossDeviceSMS=false&id=both&face=both&liveness=straight&enableEyeCheck=false&debug=true&showFPS=false&sandbox=false&theme%5Bname%5D=verbose&theme%5Bfont%5D=Arial%2C%20Helvetica%2C%20sans-serif&theme%5BfontColor%5D=%23333&theme%5BiconLabelColor%5D=%23333&theme%5BbgColor%5D=%23FFF&theme%5BbaseColor%5D=%232E159F&theme%5BnavigationDisabledBackground%5D=rgba%28203%2C%20203%2C%20203%2C%200.15%29&theme%5BnavigationDisabledText%5D=%23888&theme%5BbaseColorLight%5D=rgb%28232%2C244%2C252%29&theme%5BprogressIndicatorTextColor%5D=%23000&type=id&survey=true&includeBackId=true&includeBarcode=true&disableCssBaseline=false&showTermsAndPrivacy=false&maxRetriesBeforeNext=0&idShowNext=0&handoffView%5BonlyShowQRCode%5D=false&locale=en&userConfirmation%5BconfirmData%5D=false&userConfirmation%5BconfirmImages%5D=false&isStage=true&manualCaptureTimeout=35000"
    
    override func loadView() {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        
        webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self

        view = webView
        
        // optional: inject JS to capture console.log output for debugging needs.
        // Alternatively, use Safari on your development system to view output,
        // by attaching to your ios device when running
        let jsLoggingSrc = "function captureLog(msg) { window.webkit.messageHandlers.logHandler.postMessage(msg); } window.console.log = captureLog;"
        let logScript = WKUserScript(source: jsLoggingSrc, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        
        webView.configuration.userContentController.addUserScript(logScript)
        webView.configuration.userContentController.add(self, name: "logHandler")
    }
    
    override func viewDidLoad() {
        let url = URL(string: appUrl)!
        webView.load(URLRequest(url: url))
    }
    
    // optional, implements WKScriptMessageHandler to see debug output
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "logHandler" {
            print("Vouched Webview: \(message.body)")
        }
    }


}

