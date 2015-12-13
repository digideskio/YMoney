//
//  AuthorizationViewController.swift
//  YMoney
//
//  Created by Nikolay Morev on 13/12/15.
//  Copyright © 2015 DMA. All rights reserved.
//

import UIKit

class AuthorizationViewController: UIViewController, UIWebViewDelegate {

    weak var delegate: AuthorizationViewControllerDelegate?

    @IBOutlet weak var authorizationWebView: UIWebView!

    static let clientId = "CBE42B5C0151CE4F2AC277F5A037A45DF265B83F21EB4FF9D61A559D2A73DBF6"
    static let redirectUri = "http://ya.ru"
    static let permissions = "account-info operation-history"

    static var accessToken: String?
    static var session: YMAAPISession?

    override func viewDidLoad() {
        super.viewDidLoad()

        authorizationWebView.delegate = self;

        let additionalParameters = [
            YMAParameterResponseType : YMAValueParameterResponseType,
            YMAParameterRedirectUri : AuthorizationViewController.redirectUri,
            YMAParameterScope : AuthorizationViewController.permissions
        ]

        AuthorizationViewController.session = YMAAPISession()
        guard let authorizationRequest = AuthorizationViewController.session?.authorizationRequestWithClientId(AuthorizationViewController.clientId, additionalParameters: additionalParameters) else {
            return
        }
        authorizationWebView.loadRequest(authorizationRequest)
        print("Loaded")
    }

    // MARK: UIWebViewDelegate protocol

    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        var shouldLoadPage = true
        var authInfo: NSMutableDictionary?

        guard let session = AuthorizationViewController.session else {
            return true;
        }

        do {
            try session.isRequest(request, toRedirectUrl: AuthorizationViewController.redirectUri, authorizationInfo: &authInfo)
            if let authCode = authInfo?["code"] as? String {
                getAccessTokenFor(authCode)
            }
            shouldLoadPage = false
        }
        catch let error {
            authorizationFailed(error: error)
        }

        return shouldLoadPage;
    }

    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }

    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }

    // MARK: -

    func getAccessTokenFor(authCode: String) {
        let additionalParameters = [
            "grant_type" : "authorization_code",
            YMAParameterRedirectUri : AuthorizationViewController.redirectUri
        ]

        AuthorizationViewController.session?.receiveTokenWithCode(authCode, clientId: AuthorizationViewController.clientId, additionalParameters: additionalParameters, completion: { (instanceId, error) -> Void in
            if error == nil && instanceId != nil && instanceId != "" {
                AuthorizationViewController.accessToken = instanceId
                self.performSegueWithIdentifier("LoginSuccess", sender: instanceId)
            }
            else {
                self.authorizationFailed(error: error)
                print("error")
            }
        })
    }

    @IBAction func autorizationSuccess(sender: AnyObject) {
        print("authorization success")
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "LoginSuccess" {

        }
    }

    // Тестовое использование делегата.
    @IBAction func authorizationFailed(sender: AnyObject) {
        authorizationFailed(error: nil)
    }

    func authorizationFailed(error error: ErrorType?) {
        delegate?.authorizationViewController(self, didChooseValue: 5)
    }

}

@objc
protocol AuthorizationViewControllerDelegate : class {

    func authorizationViewController(viewController: AuthorizationViewController, didChooseValue value: Float)

}
