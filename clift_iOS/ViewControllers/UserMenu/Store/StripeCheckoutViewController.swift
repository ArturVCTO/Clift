//
//  StripeCheckoutViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 2/3/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class StripeCheckoutViewController: UIViewController,WKUIDelegate, WKNavigationDelegate, UIWebViewDelegate {
        var webView: WKWebView!
        var checkoutSessionId = ""
        var successUrl = ""
        override func viewDidLoad() {
            super.viewDidLoad()
            let webConfiguration = WKWebViewConfiguration()
            let myProjectBundle:Bundle = Bundle.main
            let myUrl = myProjectBundle.url(forResource: "stripeRedirect", withExtension: "html")!
            let script =    """
                            var script = document.createElement('script');
                            script.src = 'https://js.stripe.com/v3/';
                            script.type = 'text/javascript';
                            document.getElementById("submit").innerHTML = "IR A PAGO";
                            document.querySelector('#submit').addEventListener('click', function(evt) { stripe.redirectToCheckout({sessionId: '\(checkoutSessionId)'}).then(function(result) {});});
                            document.addEventListener('DOMContentLoaded',function(event){ stripe.redirectToCheckout({sessionId: '\(checkoutSessionId)'}).then(function(result) {})});
                            document.getElementsByTagName('head')[0].appendChild(script);
                            """
            let userScript = WKUserScript(source: script, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
            webConfiguration.userContentController.addUserScript(userScript)
            webView = WKWebView(frame: .zero, configuration: webConfiguration)
            webView.uiDelegate = self
            webView.navigationDelegate = self
            view = webView
            webView.loadFileURL(myUrl, allowingReadAccessTo: myUrl)
        }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(navigationAction.request.url!)
        print("hello")
        decisionHandler(.allow)
        if ( self.webView!.url?.absoluteString == "https://clift.axented.com" || self.webView!.url?.absoluteString == successUrl)
        {
            self.webView!.stopLoading()
             if #available(iOS 13.0, *) {
                 let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "paymentConfirmationVC") as! PaymentConfirmationViewController
                 self.navigationController?.pushViewController(vc, animated: true)
             } else {
                 let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "paymentConfirmationVC") as! PaymentConfirmationViewController
                 self.navigationController?.pushViewController(vc, animated: true)
             }
        }
    }
}
