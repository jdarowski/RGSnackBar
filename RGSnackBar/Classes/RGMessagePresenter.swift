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
    func dismiss(message: RGMessage)
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

    public func dismiss(message: RGMessage) {
        dismissTimerUp(nil)
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

public class RGMessageSnackBarPresenter: RGMessagePresenter {
    weak public var delegate: RGMessagePresenterDelegate?

    var destinationView: UIView
    var snackBarView: RGMessageSnackBarView

    var transformRatio: CGFloat = 1.2
    var showTransform: CGAffineTransform
    var halfTransform: CGAffineTransform

    let animationDuration: NSTimeInterval = 0.2
    var tapGestureRecognizer: UITapGestureRecognizer?
    private var timer: NSTimer?

    public init(view: UIView) {
        destinationView = view
        snackBarView = RGMessageSnackBarView(message: nil, containerView: view)
        showTransform = CGAffineTransformMakeScale(transformRatio, transformRatio)
        let halfRatio = transformRatio - ((transformRatio - 1.0) * 0.5)
        halfTransform = CGAffineTransformMakeScale(halfRatio, halfRatio)

        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognized(_:)))
        tapGestureRecognizer?.numberOfTapsRequired = 1
        tapGestureRecognizer?.numberOfTouchesRequired = 1
        snackBarView.addGestureRecognizer(tapGestureRecognizer!)
        snackBarView.presenter = self
    }

    public func present(message: RGMessage) {
//        show(message)
        guard NSThread.currentThread().isMainThread else {
            dispatch_async(dispatch_get_main_queue(), { 
                self.present(message)
            })
            return
        }
        snackBarView.transform = showTransform
        snackBarView.message = message
        UIView.animateWithDuration(self.animationDuration, delay: 0.0, options: .CurveEaseOut, animations: {
                self.snackBarView.alpha = 1.0
                self.snackBarView.transform = CGAffineTransformIdentity
            }) { (finished) in
                self.delegate?.presenter(self, didPresent: message)
                self.timer = NSTimer.scheduledTimerWithTimeInterval(message.duration, target: self, selector: #selector(self.displayTimer(_:)), userInfo: nil, repeats: false)
        }
    }

    public func dismiss(message: RGMessage) {
        guard NSThread.currentThread().isMainThread else {
            dispatch_async(dispatch_get_main_queue(), {
                self.dismiss(message)
            })
            return
        }

        timer?.invalidate()
        UIView.animateWithDuration(self.animationDuration, delay: 0.0, options: .CurveEaseOut, animations: {
            self.snackBarView.alpha = 0.0
            self.snackBarView.transform = self.showTransform
        }) { (finished) in
            self.snackBarView.message = nil
            self.delegate?.presenter(self, didDismiss: message)
        }
    }

    @objc func tapGestureRecognized(recognizer: UITapGestureRecognizer) {
        if let message = snackBarView.message {
            dismiss(message)
        }
    }

    @objc func displayTimer(timer: NSTimer?) {
        guard NSThread.currentThread().isMainThread else {
            dispatch_async(dispatch_get_main_queue(), {
                self.displayTimer(timer)
            })
            return
        }
        if let message = snackBarView.message {
            self.dismiss(message)
        }
    }
}
