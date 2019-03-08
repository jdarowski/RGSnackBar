//
//  RGMessageSnackBarAnimation.swift
//  RGSnackBar
//
//  Created by Jakub Darowski on 04/09/2017.
//
//

import UIKit
import Stevia

public typealias RGSnackBarAnimationBlock =  
    ((RGMessageSnackBarView, UIView, Bool) -> Void)

/**
 * This is where the fun begins. Instantiate (or extend)this class to define 
 * your very own buttery smooth, candy-like animations for the snackbar.
 */
open class RGMessageSnackBarAnimation: NSObject {

    /// The block that will be executed before animating
    open var preAnimationBlock: RGSnackBarAnimationBlock?

    /// The animation block - will be executed inside UIView.animate(...)
    open var animationBlock: RGSnackBarAnimationBlock

    /// The block that will be executed in the completion block of animate(...)
    open var postAnimationBlock: RGSnackBarAnimationBlock?

    /// The duration of the animation
    open var animationDuration: TimeInterval

    /// States whether the snackbar is off-screen
    open var beginsOffscreen: Bool

    /**
     * The only constructor you'll need.
     *
     * - Parameter preBlock: duh
     * - Parameter animationBlock: double duh
     * - Parameter postBlock: duh
     * - Parameter animationDuration: the duration of just the animation itself.
     * - Parameter beginsOffscreen: whether the snackbar starts offscreen
     */

    public init(preBlock: RGSnackBarAnimationBlock?,
                animationBlock: @escaping RGSnackBarAnimationBlock,
                postBlock: RGSnackBarAnimationBlock?,
                animationDuration: TimeInterval=0.4,
                beginsOffscreen: Bool=false) {
        self.preAnimationBlock = preBlock
        self.animationBlock = animationBlock
        self.postAnimationBlock = postBlock
        self.animationDuration = animationDuration
        self.beginsOffscreen = beginsOffscreen

        super.init()
    }

    /// A predefined zoom-in animation, UIAlertView style
    public static let zoomIn: RGMessageSnackBarAnimation =
        RGMessageSnackBarAnimation(preBlock: { (snackBarView, _, isPresenting)
            in
            if isPresenting {
                snackBarView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
        }, animationBlock: { (snackBarView, parentView, isPresenting) in
            if isPresenting {
                snackBarView.alpha = 1.0
                snackBarView.transform = CGAffineTransform.identity
            } else {
                snackBarView.alpha = 0.0
                snackBarView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
        }, postBlock: nil, animationDuration: 0.2, beginsOffscreen: false)

    /// A predefined slide up animation, system banner style (just opposite)
    public static let slideUp: RGMessageSnackBarAnimation =
        RGMessageSnackBarAnimation(preBlock:
            { (snackBarView, parentView, isPresenting) in
            if isPresenting {
                let height = snackBarView.frame.size.height
                snackBarView.bottomConstraint?.constant =
                    height + snackBarView.bottomMargin
                snackBarView.alpha = 1.0
                parentView.layoutIfNeeded()
                snackBarView.bottomConstraint?.constant =
                    -(snackBarView.bottomMargin)
            } else {
                snackBarView.bottomConstraint?.constant =
                    snackBarView.frame.size.height
        }
        }, animationBlock: { (snackBarView, parentView, isPresenting) in
            parentView.layoutIfNeeded()
        }, postBlock: { (snackBarView, parentView, isPresenting) in
            if !isPresenting {
                snackBarView.alpha = 0.0
            }
        }, animationDuration: 0.2, beginsOffscreen: true)
}
