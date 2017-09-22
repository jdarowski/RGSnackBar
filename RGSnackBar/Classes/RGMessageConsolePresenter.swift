//
//  RGMessageConsolePresenter.swift
//  RGSnackBar
//
//  Created by Jakub Darowski on 04/09/2017.
//
//

import UIKit

/**
 * An RGMessagePresenter that will print all your messages to console. That's
 * all it does. You might use it for debugging or creating log files.
 */
open class RGMessageConsolePresenter: RGMessagePresenter {
    fileprivate var _timer: Timer?
    fileprivate var _message: RGMessage?

    weak open var delegate: RGMessagePresenterDelegate?

    /// There is nothing to initialise, so this is the only constructor.
    public init() {

    }

    open func present(_ message: RGMessage) {
        show(message)
    }

    open func dismiss(_ message: RGMessage) {
        dismissTimerUp(nil)
    }

    /// Prints the message and sets up a dismiss timer.
    fileprivate func show(_ message: RGMessage) {
        _message = message
        print("---- \(Date().timeIntervalSince1970) - BEGIN RGMESSAGE ----")
        print(message.priority.stringValue + ": " + message.text)
        delegate?.presenter(self, didPresent: message)

        _timer?.invalidate()
        _timer = Timer.scheduledTimer(timeInterval: message.duration, target: self, selector: #selector(dismissTimerUp(_:)), userInfo: nil, repeats: false)
    }

    /// Prints the end message and tells the delegate that it did.
    @objc open func dismissTimerUp(_ timer: Timer?){
        print("---- \(Date().timeIntervalSince1970) -  END RGMESSAGE  ----")
        guard let message = _message else {
            return
        }

        delegate?.presenter(self, didDismiss: message)
        _message = nil
    }
}
