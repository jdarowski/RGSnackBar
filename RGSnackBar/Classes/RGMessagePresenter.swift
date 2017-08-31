//
//  RGMessagePresenter.swift
//  Pods
//
//  Created by Jakub Darowski on 30.08.2017.
//
//

import UIKit

public protocol RGMessagePresenter {
    weak var delegate: RGMessagePresenterDelegate? { get set }
    func present(message: RGMessage)
}

public protocol RGMessagePresenterDelegate: class {
    func presenter(_: RGMessagePresenter, didPresent message: RGMessage)
    func presenter(_: RGMessagePresenter, didDismiss message: RGMessage)
}

public class RGMessageConsolePresenter: RGMessagePresenter {
    private var _timer: NSTimer?
    private var _message: RGMessage?

    weak public var delegate: RGMessagePresenterDelegate?

    public init() {
        
    }

    public func present(message: RGMessage) {
        show(message)
    }
    
    private func show(message: RGMessage) {
        _message = message
        print("---- \(NSDate().timeIntervalSince1970) - BEGIN RGMESSAGE ----")
        print(message.priority.stringValue + ": " + message.text)
        delegate?.presenter(self, didPresent: message)

        _timer?.invalidate()
        _timer = NSTimer.scheduledTimerWithTimeInterval(message.duration, target: self, selector: #selector(dismissTimerUp(_:)), userInfo: nil, repeats: false)
    }


    @objc public func dismissTimerUp(timer: NSTimer?){
        print("---- \(NSDate().timeIntervalSince1970) -  END RGMESSAGE  ----")
        guard let message = _message else {
            return
        }

        delegate?.presenter(self, didDismiss: message)
        _message = nil
    }
}




