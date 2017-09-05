//
//  RGMessageSnackBarAnimation.swift
//  Pods
//
//  Created by Jakub Darowski on 04/09/2017.
//
//

import UIKit
import SteviaLayout

public typealias RGSnackBarAnimationBlock = ((RGMessageSnackBarView, UIView, Bool) -> Void)

public class RGMessageSnackBarAnimation: NSObject {

    public var preAnimationBlock: RGSnackBarAnimationBlock?
    public var animationBlock: RGSnackBarAnimationBlock
    public var postAnimationBlock: RGSnackBarAnimationBlock?
    public var animationDuration: NSTimeInterval
    public var beginsOffcreen: Bool

    public init(preBlock: RGSnackBarAnimationBlock?, animationBlock: RGSnackBarAnimationBlock, postBlock: RGSnackBarAnimationBlock?, animationDuration: NSTimeInterval=0.4, beginsOffcreen: Bool=false) {
        self.preAnimationBlock = preBlock
        self.animationBlock = animationBlock
        self.postAnimationBlock = postBlock
        self.animationDuration = animationDuration
        self.beginsOffcreen = beginsOffcreen

        super.init()
    }


    public static let zoomIn: RGMessageSnackBarAnimation = RGMessageSnackBarAnimation(preBlock: { (snackBarView, _, isPresenting) in
            if isPresenting {
                snackBarView.transform = CGAffineTransformMakeScale(1.2, 1.2)
            }
        }, animationBlock: { (snackBarView, parentView, isPresenting) in
            if isPresenting {
                snackBarView.alpha = 1.0
                snackBarView.transform = CGAffineTransformIdentity
            } else {
                snackBarView.alpha = 0.0
                snackBarView.transform = CGAffineTransformMakeScale(1.2, 1.2)
            }
        }, postBlock: nil, animationDuration: 0.2, beginsOffcreen: false)

    public static let slideUp: RGMessageSnackBarAnimation = RGMessageSnackBarAnimation(preBlock: { (snackBarView, parentView, isPresenting) in
            if isPresenting {
                let height = snackBarView.frame.size.height
                snackBarView.bottomConstraint?.constant = height + 20.0
                snackBarView.alpha = 1.0
                parentView.layoutIfNeeded()
                snackBarView.bottomConstraint?.constant = -20.0
            } else {
                snackBarView.bottomConstraint?.constant = snackBarView.frame.size.height
        }
        }, animationBlock: { (snackBarView, parentView, isPresenting) in
            parentView.layoutIfNeeded()
        }, postBlock: { (snackBarView, parentView, isPresenting) in
            if !isPresenting {
                snackBarView.alpha = 0.0
            }
        }, animationDuration: 0.2, beginsOffcreen: true)
}
