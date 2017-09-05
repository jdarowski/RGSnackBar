//
//  RGMessageSnackBarPresenter.swift
//  Pods
//
//  Created by Jakub Darowski on 04/09/2017.
//
//

import UIKit

public class RGMessageSnackBarPresenter: RGMessagePresenter {
    weak public var delegate: RGMessagePresenterDelegate?

    var animation: RGMessageSnackBarAnimation
    var destinationView: UIView
    var snackBarView: RGMessageSnackBarView

    var tapGestureRecognizer: UITapGestureRecognizer?
    private var timer: NSTimer?

    public init(view: UIView, animation: RGMessageSnackBarAnimation) {
        destinationView = view
        snackBarView = RGMessageSnackBarView(message: nil, containerView: view)
        self.animation = animation

        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognized(_:)))
        tapGestureRecognizer?.numberOfTapsRequired = 1
        tapGestureRecognizer?.numberOfTouchesRequired = 1
        snackBarView.addGestureRecognizer(tapGestureRecognizer!)
        snackBarView.presenter = self
        snackBarView.alpha = 0.0
    }

    public func present(message: RGMessage) {
        //        show(message)
        guard NSThread.currentThread().isMainThread else {
            dispatch_async(dispatch_get_main_queue(), {
                self.present(message)
            })
            return
        }
        snackBarView.message = message

        animation.preAnimationBlock?(snackBarView, destinationView, true)
        UIView.animateWithDuration(animation.animationDuration, delay: 0.0, options: .CurveEaseOut, animations: {
            self.animation.animationBlock(self.snackBarView, self.destinationView, true)
        }) { (finished) in
            self.animation.postAnimationBlock?(self.snackBarView, self.destinationView, true)
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
        animation.preAnimationBlock?(snackBarView, destinationView, false)
        UIView.animateWithDuration(animation.animationDuration, delay: 0.0, options: .CurveEaseOut, animations: {
            self.animation.animationBlock(self.snackBarView, self.destinationView, false)
        }) { (finished) in
            self.animation.postAnimationBlock?(self.snackBarView, self.destinationView, false)
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
