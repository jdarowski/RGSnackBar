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
public class RGMessageConsolePresenter: RGMessagePresenter {
    private var _timer: NSTimer?
    private var _message: RGMessage?

    weak public var delegate: RGMessagePresenterDelegate?

    /// There is nothing to initialise, so this is the only constructor.
    public init() {

    }

    public func present(message: RGMessage) {
        show(message)
    }

    public func dismiss(message: RGMessage) {
        dismissTimerUp(nil)
    }

    /// Prints the message and sets up a dismiss timer.
    private func show(message: RGMessage) {
        _message = message
        print("---- \(NSDate().timeIntervalSince1970) - BEGIN RGMESSAGE ----")
        print(message.priority.stringValue + ": " + message.text)
        delegate?.presenter(self, didPresent: message)

        _timer?.invalidate()
        _timer = NSTimer.scheduledTimerWithTimeInterval(message.duration, target: self, selector: #selector(dismissTimerUp(_:)), userInfo: nil, repeats: false)
    }

    /// Prints the end message and tells the delegate that it did.
    @objc public func dismissTimerUp(timer: NSTimer?){
        print("---- \(NSDate().timeIntervalSince1970) -  END RGMESSAGE  ----")
        guard let message = _message else {
            return
        }

        delegate?.presenter(self, didDismiss: message)
        _message = nil
    }
}
