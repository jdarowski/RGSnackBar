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
open class RGMessageSnackBarPresenter: RGMessagePresenter {
    /// Delegate
    weak open var delegate: RGMessagePresenterDelegate?

    /// What should I present?
    open var snackBarView: RGMessageSnackBarView

    /// How should I present it?
    open var animation: RGMessageSnackBarAnimation

    /// Where should I present it?
    var destinationView: UIView

    fileprivate var tapGestureRecognizer: UITapGestureRecognizer?
    fileprivate var timer: Timer?

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

    open func present(_ message: RGMessage) {
        guard Thread.current.isMainThread else {
            DispatchQueue.main.async(execute: {
                self.present(message)
            })
            return
        }
        snackBarView.message = message

        animation.preAnimationBlock?(snackBarView, destinationView, true)
        UIView.animate(withDuration: animation.animationDuration, delay: 0.0, options: .curveEaseOut, animations: {
            self.animation.animationBlock(self.snackBarView, self.destinationView, true)
        }) { (finished) in
            self.animation.postAnimationBlock?(self.snackBarView, self.destinationView, true)
            self.delegate?.presenter(self, didPresent: message)
            self.timer = Timer.scheduledTimer(timeInterval: message.duration, target: self, selector: #selector(self.displayTimer(_:)), userInfo: nil, repeats: false)
        }
    }

    open func dismiss(_ message: RGMessage) {
        guard Thread.current.isMainThread else {
            DispatchQueue.main.async(execute: {
                self.dismiss(message)
            })
            return
        }

        timer?.invalidate()
        animation.preAnimationBlock?(snackBarView, destinationView, false)
        UIView.animate(withDuration: animation.animationDuration, delay: 0.0, options: .curveEaseOut, animations: {
            self.animation.animationBlock(self.snackBarView, self.destinationView, false)
        }) { (finished) in
            self.animation.postAnimationBlock?(self.snackBarView, self.destinationView, false)
            self.snackBarView.message = nil
            self.delegate?.presenter(self, didDismiss: message)
        }
    }

    @objc fileprivate func tapGestureRecognized(_ recognizer: UITapGestureRecognizer) {
        if let message = snackBarView.message {
            dismiss(message)
        }
    }

    @objc fileprivate func displayTimer(_ timer: Timer?) {
        guard Thread.current.isMainThread else {
            DispatchQueue.main.async(execute: {
                self.displayTimer(timer)
            })
            return
        }
        if let message = snackBarView.message {
            self.dismiss(message)
        }
    }
}
