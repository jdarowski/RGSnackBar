//
//  RGMessageSnackBarPresenter.swift
//  RGSnackBar
//
//  Created by Jakub Darowski on 04/09/2017.
//
//

import UIKit

/**
 * The main presenter class for this library.
 *
 * This presenter shows the message in a snackbar using the given animation.
 */
public class RGMessageSnackBarPresenter: RGMessagePresenter {
    /// Delegate
    weak public var delegate: RGMessagePresenterDelegate?

    /// What should I present?
    var snackBarView: RGMessageSnackBarView

    /// How should I present it?
    var animation: RGMessageSnackBarAnimation

    /// Where should I present it?
    var destinationView: UIView

    private var tapGestureRecognizer: UITapGestureRecognizer?
    private var timer: NSTimer?

    /**
     * The main constructor for the snackbar. It has some values predefined,
     * but you may customise them as you please.
     *
     * - Parameter view: the destination view (or window)
     * - Parameter bottomMargin: the distance between the `view`'s bottom
     *   and the snackbar's bottom.
     * - Parameter sideMargins: the distance between the `view`'s 
     *   and the snackbar's sides.
     * - Parameter cornerRadius: how round should the snackbar's corners be
     */
    public init(view: UIView,
                animation: RGMessageSnackBarAnimation=RGMessageSnackBarAnimation.slideUp,
                bottomMargin: CGFloat=20.0,
                sideMargins: CGFloat=8.0,
                cornerRadius: CGFloat=8.0) {
        destinationView = view
        snackBarView = RGMessageSnackBarView(message: nil, containerView: view, bottomMargin: bottomMargin, sideMargins: sideMargins, cornerRadius: cornerRadius)
        self.animation = animation

        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognized(_:)))
        tapGestureRecognizer?.numberOfTapsRequired = 1
        tapGestureRecognizer?.numberOfTouchesRequired = 1
        snackBarView.addGestureRecognizer(tapGestureRecognizer!)
        snackBarView.presenter = self
        snackBarView.alpha = 0.0
    }

    public func present(message: RGMessage) {
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

    @objc private func tapGestureRecognized(recognizer: UITapGestureRecognizer) {
        if let message = snackBarView.message {
            dismiss(message)
        }
    }

    @objc private func displayTimer(timer: NSTimer?) {
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
