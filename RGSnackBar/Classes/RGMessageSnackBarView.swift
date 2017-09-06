//
//  RGMessageSnackBarView.swift
//  Pods
//
//  Created by Jakub Darowski on 31/08/2017.
//
//

import UIKit
import SteviaLayout

public class RGMessageSnackBarView: RGMessageView {

    private var imageView = UIImageView()
    private var messageLabel = UILabel()
    private var blurView = UIVisualEffectView()
    private var actionStack = UIStackView()
    var parentView: UIView
    var presenter: RGMessagePresenter?

    public var bottomMargin: CGFloat
    public var sideMargins: CGFloat
    public var cornerRadius: CGFloat

    public init(message: RGMessage?, containerView: UIView, bottomMargin: CGFloat=20.0, sideMargins: CGFloat=8.0, cornerRadius: CGFloat=8.0) {
        parentView = containerView
        self.bottomMargin = bottomMargin
        self.sideMargins = sideMargins
        self.cornerRadius = cornerRadius
        super.init(frame: containerView.frame, message: message)

        blurView.effect = UIBlurEffect(style: .Dark)
        self.backgroundColor = UIColor.clearColor()

        self.alpha = 0.0
        parentView.addSubview(self)
        layoutMainView()
        disableTranslatingAutoresizing(self)
        layoutIfNeeded()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        parentView = UIView()
        bottomMargin = 0.0
        sideMargins = 0.0
        cornerRadius = 0.0

        super.init(coder: aDecoder)
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        self.layoutMainView()
    }

    func layoutMainView() {

        sv(messageLabel, imageView, actionStack)

        self.bottom(bottomMargin)

        parentView.layout(
            |-sideMargins-self-sideMargins-|
        )

        messageLabel.top(8).bottom(8)

        self.layout(
            |-imageView-messageLabel-actionStack-|
        )
//        messageLabel.backgroundColor = UIColor.yellowColor().colorWithAlphaComponent(0.5)

        sv(blurView)

        messageLabel.numberOfLines = 0
        messageLabel.textColor = UIColor.whiteColor()
        messageLabel.setContentHuggingPriority(0, forAxis: .Horizontal)
//        messageLabel.setContentCompressionResistancePriority(1000, forAxis: .Horizontal)

        imageView.contentMode = .ScaleAspectFit
        imageView.top(>=8).bottom(>=8)

        actionStack.top(8.0).bottom(8.0)
        actionStack.alignment = .Center
        actionStack.axis = .Horizontal
        actionStack.distribution = .EqualSpacing
        actionStack.spacing = 10.0
        actionStack.setContentCompressionResistancePriority(900, forAxis: .Horizontal)

        blurView.frame = self.frame
        blurView.top(0).bottom(0).left(0).right(0)
        sendSubviewToBack(blurView)
        layer.masksToBounds = true
        layer.cornerRadius = self.cornerRadius
    }

    override public func layoutMessage(message: RGMessage) {
        messageLabel.text = message.text
        imageView.image = message.image
        let imageDimension: CGFloat = imageView.image == nil ? 0.0 : 25.0
        imageView.width(imageDimension).height(imageDimension)

        if message.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 30  {
            actionStack.axis = .Vertical
        } else {
            actionStack.axis = .Horizontal
        }
        for action in message.actions {
            let button = RGActionButton(action: action)
            button.setTitleColor(UIColor.orangeColor(), forState: .Normal)
            button.addTarget(self, action: #selector(actionTapped(_:)), forControlEvents: .TouchUpInside)
            button.setContentCompressionResistancePriority(1000, forAxis: .Horizontal)
            actionStack.addArrangedSubview(button)
        }
        layoutIfNeeded()
    }

    override public func prepareForReuse() {
        messageLabel.text = nil
        imageView.image = nil
        for view in actionStack.arrangedSubviews {
            view.removeFromSuperview()
        }
    }

    func actionTapped(sender: RGActionButton?) {
        if let msg = self.message {
            presenter?.dismiss(msg)
        }
    }

}
