//
//  YandexMoneyServer.swift
//  YMoney
//
//  Created by Nikolay Morev on 14/12/15.
//  Copyright © 2015 DMA. All rights reserved.
//

import Foundation

class YandexMoneyServer : NSObject {

    static let connectionTimeout: NSTimeInterval = 5
    static let numberOfOperations = "10"

    /// My client id
    static let clientId = "CBE42B5C0151CE4F2AC277F5A037A45DF265B83F21EB4FF9D61A559D2A73DBF6"
    /// URI that the OAuth server sends the authorization result to
    static let redirectUri = "http://ya.ru"
    /// A list of requested permissions
    static let permissions = "account-info operation-history"

    var accessToken: String?
    let session = YMAAPISession()
    // Используем NSSet вместо Set, т.к. не получается добавить Hashable к @objc протоколу
    let observers = NSMutableSet()
    var nextRecord: String?

    init(accessToken: String) {
        self.accessToken = accessToken
    }

    func subscribeOnEvents(observer: YandexServerObserver) {
        observers.addObject(observer)
    }

    func unSubscribeOnEvents(observer: YandexServerObserver) {
        observers.removeObject(observer)
    }

    func performAccountInfoRequest() {
        self.startTimeout()

        let request = YMAAccountInfoRequest();
        print("perfoming account info request")

        session.performRequest(request, token: accessToken) { (request, response, error) -> Void in
            self.stopTimeout()
            if error == nil {
                if let accountInfoResponse = response as? YMAAccountInfoResponse {
                    let accountInfo = accountInfoResponse.accountInfo
                    self.updateAccountInfoData(accountInfo)
                }
            }
            else {
                self.handleError(error.code)
                print("\(error)")
            }
        }
    }

    func performOperationHistoryRequest() {
        self.startTimeout()

        let operationHistoryRequest = YMAHistoryOperationsRequest.operationHistoryWithFilter(.Unknown, label: nil, from: nil, till: nil, startRecord: nil, records: YandexMoneyServer.numberOfOperations)

        session.performRequest(operationHistoryRequest, token: accessToken) { (request, response, error) -> Void in
            if error == nil {
                if let historyOperation = response as? YMAHistoryOperationsResponse {
                    self.updateLastOperationsDetails(historyOperation.operations as! [YMAHistoryOperationModel])
                    self.nextRecord = historyOperation.nextRecord
                }
            }
            else {
                self.handleError(error.code)
                print("\(error)")
            }

            self.stopTimeout()
        }
    }

    func requestNextOperations() {
        self.startTimeout();

        let operationHistoryRequest = YMAHistoryOperationsRequest.operationHistoryWithFilter(.Unknown, label: nil, from: nil, till: nil, startRecord: nextRecord, records: YandexMoneyServer.numberOfOperations)

        session.performRequest(operationHistoryRequest, token: accessToken) { (request, response, error) -> Void in
            if error == nil {
                if let historyOperation = response as? YMAHistoryOperationsResponse {
                    self.onAddOperationsToEnd(historyOperation.operations as! [YMAHistoryOperationModel])
                    self.nextRecord = historyOperation.nextRecord
                }
            }
            else {
                self.handleError(error.code)
                print("\(error)")
            }

            self.stopTimeout()
        }
    }

    func checkAccessToken() {
        self.startTimeout()

        let request = YMAAccountInfoRequest()

        session.performRequest(request, token: accessToken) { (request, response, error) -> Void in
            self.stopTimeout()
            if error == nil {
                self.onTokenAccepted()
            }
            else {
                self.handleError(error.code)
                print("\(error)")
            }
        }
    }

    func getAccessTokenFrom(request: NSURLRequest) {
        var authInfo: NSMutableDictionary?

        do {
            try session.isRequest(request, toRedirectUrl: YandexMoneyServer.redirectUri, authorizationInfo: &authInfo)
//            if authInfo != nil {
//                let authCode = authInfo!["code"]
//            }
        }
        catch let error as NSError {
            self.handleError(error.code)
        }
    }

    static func checkAccessToken(accessToken: String, forObserver observer: YandexServerObserver) {
        let session = YMAAPISession();
        
        // Swift автоматически распознает соглашения для именования factory методов.
        // Будет вызван +[YMAAccountInfoRequest accountInfoRequest]
        let request = YMAAccountInfoRequest();

        session.performRequest(request, token: accessToken) { (request, response, error) -> Void in
            if error == nil {
                observer.onTokenAccepted()
            }
            else {
                observer.onNeedToRefreshToken()
                print("\(error)")
            }
        }
    }

    // MARK: Private

    func getAccessTokenFor(authCode: String) {
        let additionalParameters = [
            "grant_type" : "authorization_code",
            YMAParameterRedirectUri : YandexMoneyServer.redirectUri
        ]

        self.startTimeout()

        session.receiveTokenWithCode(authCode, clientId: YandexMoneyServer.clientId, additionalParameters: additionalParameters) { (instanceId, error) -> Void in
            self.stopTimeout()

            if error == nil && instanceId != nil && instanceId != "" {
                self.accessToken = instanceId
                self.onConfirmToken(self.accessToken!)
            }
            else {
                self.handleError(error.code)
            }
        }
    }

    func updateAccountInfoData(accountInfo: YMAAccountInfoModel) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            for observer in self.observers {
                observer.onReceiveAccountInfo(accountInfo)
            }
        }
    }

    func updateLastOperationsDetails(operations: [YMAHistoryOperationModel]) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            for observer in self.observers {
                observer.onReceiveLastOperations(operations)
            }
        }
    }

    func onAddOperationsToEnd(operations: [YMAHistoryOperationModel]) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            for observer in self.observers {
                observer.onReceiveNextOperations(operations)
            }
        }
    }

    func handleError(error: Int) {
        if error < 0 {
            self.onConnectionLost()
        }
        else if error == YandexServerErrors.InvalidToken.rawValue {
            self.onBadToken()
        }
        else {
            self.onUnexpectedError()
        }
    }

    func onConnectionTimeout() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            print("Connection timeout")
            for observer in self.observers {
                observer.onInternetConnectionLost()
            }
        }
    }

    func onConnectionLost() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            print("Connection lost")
            for observer in self.observers {
                observer.onInternetConnectionLost()
            }
        }
    }

    func onConfirmToken(accessToken: String) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            print("Access token is confirmed")
            for observer in self.observers {
                observer.onReceiveAccessToken(accessToken)
            }
        }
    }

    func onTokenAccepted() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            print("Access token is accepted")
            for observer in self.observers {
                observer.onTokenAccepted()
            }
        }
    }

    func onBadToken() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            print("Need to refresh token")
            for observer in self.observers {
                observer.onNeedToRefreshToken()
            }
        }
    }

    func onUnexpectedError() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            print("Unexpected error")
        }
    }

    // MARK: Timeout

    static var connectionTimeoutThread: NSThread?

    func startTimeout() {
        YandexMoneyServer.connectionTimeoutThread?.cancel()
        YandexMoneyServer.connectionTimeoutThread = NSThread(target: self, selector: "timeoutThread", object: nil)
        YandexMoneyServer.connectionTimeoutThread?.start()
    }

    func timeoutThread() {
        let timeStamp: NSTimeInterval = 0.1
        var currentTime: NSTimeInterval = 0
        while currentTime < YandexMoneyServer.connectionTimeout {
            if NSThread.currentThread().cancelled {
                return
            }
            NSThread.sleepForTimeInterval(timeStamp)
            currentTime = currentTime + timeStamp
            print("\(currentTime)")
        }
        self.onConnectionTimeout()
    }

    func stopTimeout() {
        YandexMoneyServer.connectionTimeoutThread?.cancel()
    }

}

@objc
protocol YandexServerObserver {

    func onInternetConnectionLost();
    func onReceiveAccountInfo(accountInfo: YMAAccountInfoModel);
    func onReceiveLastOperations(lastOperations: [YMAHistoryOperationModel]);
    func onReceiveNextOperations(nextOperations: [YMAHistoryOperationModel]);
    func onNeedToRefreshToken();
    func onReceiveAccessToken(accessToken: String);
    func onTokenAccepted();

}

enum YandexServerErrors : Int {
    case InvalidToken = 401
}
