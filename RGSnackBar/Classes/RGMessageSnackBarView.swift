//
//  RGMessageSnackBarView.swift
//  RGSnackBar
//
//  Created by Jakub Darowski on 31/08/2017.
//
//

import UIKit
import Stevia

/**
 * The generic snack bar.
 *
 *
 */
open class RGMessageSnackBarView: RGMessageView {

    fileprivate var imageView = UIImageView()
    fileprivate var messageLabel = UILabel()
    fileprivate var blurView = UIVisualEffectView()
    fileprivate var actionStack = UIStackView()

    /// The view in which the message will be displayed
    var parentView: UIView

    /// A reference to the presenter which is presenting the snackbar
    var presenter: RGMessagePresenter?

    // ---- BEGIN STYLES -------------------------------------------------------
    /// The distance between the snackbar's and `parentView`'s bottoms
    open var bottomMargin: CGFloat { didSet { style() } }

    /// The distance between the snackbar's and `parentView`'s sides
    open var sideMargins: CGFloat { didSet { style() } }

    /// Amount of curviness you desire
    open var cornerRadius: CGFloat { didSet { style() } }

    /// Font size for the message label
    open var textFontSize: CGFloat = 17.0 { didSet { style() } }

    /// Font size for the action buttons
    open var buttonFontSize: CGFloat = 17.0 { didSet { style() } }

    /// Font color for the message label
    open var textFontColor: UIColor = UIColor.white {
        didSet { style() }
    }

    /// Font color for the action buttons
    open var buttonFontColor: UIColor = UIColor.orange {
        didSet { style() }
    }

    /// Background blur effect
    open var backgroundBlurEffect = UIBlurEffect(style: .dark) {
        didSet { style() }
    }
    
    open var padding: UIEdgeInsets {
        didSet { style() }
    }

    // ----  END STYLES  -------------------------------------------------------

    /**
     * The main constructor
     *
     * - Parameter message: the message to be displayed
     * - Parameter containerView: The view in which the snackbar should be
     *   displayed
     * - Parameter bottomMargin: the margin between the snackbar's
     *   and the `containerView`'s bottoms
     * - Parameter sideMargins: the margins between the snackbar's
     *   and the `containerView`'s sides
     * - Parameter cornerRadius: 
     */
    public init(message: RGMessage?,
                containerView: UIView,
                bottomMargin: CGFloat=20.0,
                sideMargins: CGFloat=8.0,
                cornerRadius: CGFloat=8.0,
                padding: UIEdgeInsets=UIEdgeInsets(top: 8.0,
                                                   left: 20.0,
                                                   bottom: 8.0,
                                                   right: 20.0)) {
        parentView = containerView
        self.bottomMargin = bottomMargin
        self.sideMargins = sideMargins
        self.cornerRadius = cornerRadius
        self.padding = padding
        super.init(frame: containerView.frame, message: message)

        self.backgroundColor = UIColor.clear

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
        padding = .zero

        super.init(coder: aDecoder)
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
        self.layoutMainView()
    }

    /// Lays out the main snackbar view
    func layoutMainView() {

        sv(messageLabel, imageView, actionStack)
        
        self.bottom(bottomMargin)

        parentView.layout(
            |-sideMargins-self-sideMargins-|
        )

        messageLabel.top(padding.top)

        if #available(iOS 11.0, *) {
            messageLabel.Bottom == safeAreaLayoutGuide.Bottom - padding.bottom
        } else {
            messageLabel.Bottom == Bottom - padding.bottom
        }

        self.layout(
            |-padding.left-imageView-messageLabel-actionStack-padding.right-|
        )

        sv(blurView)

        messageLabel.numberOfLines = 0
        messageLabel.textColor = UIColor.white
        messageLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 0), for: .horizontal)

        imageView.contentMode = .scaleAspectFit
        imageView.top(>=padding.top).bottom(>=padding.bottom)

        actionStack.top(padding.top)
        actionStack.alignment = .center
        actionStack.axis = .horizontal
        actionStack.distribution = .equalSpacing
        actionStack.spacing = 10.0
        actionStack.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 900),
                                                        for: .horizontal)

        if #available(iOS 11.0, *) {
            actionStack.Bottom == safeAreaLayoutGuide.Bottom - padding.bottom
        } else {
            actionStack.Bottom == Bottom - padding.bottom
        }

        blurView.frame = self.frame
        blurView.top(0).bottom(0).left(0).right(0)
        sendSubviewToBack(blurView)
    }

    override open func layoutMessage(_ message: RGMessage) {
        messageLabel.text = message.text
        imageView.image = message.image
        let imageDimension: CGFloat = imageView.image == nil ? 0.0 : 25.0
        imageView.width(imageDimension).height(imageDimension)

        if message.text.lengthOfBytes(using: String.Encoding.utf8) > 30
            || message.actions.count > 2 {
            actionStack.axis = .vertical
        } else {
            actionStack.axis = .horizontal
        }
        for action in message.actions {
            let button = RGActionButton(action: action)
            button.addTarget(self,
                             action: #selector(actionTapped(_:)),
                             for: .touchUpInside)
            button.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000),
                                                           for: .horizontal)
            actionStack.addArrangedSubview(button)
        }
        style()
        layoutIfNeeded()
    }

    override open func style() {

        // Buttons
        for button in actionStack.arrangedSubviews where button is UIButton {
            guard let butt = button as? UIButton else { // 😏
                continue
            }
            butt.setTitleColor(buttonFontColor,
                                 for: UIControl.State())
            var newFont: UIFont
            if let font = butt.titleLabel?.font {
                newFont = font.withSize(buttonFontSize)
            } else {
                newFont = UIFont.systemFont(ofSize: buttonFontSize)
            }
            butt.titleLabel?.font = newFont
        }
        // Image
        imageView.topConstraint?.constant = padding.top
        imageView.bottomConstraint?.constant = padding.bottom
        imageView.leftConstraint?.constant = padding.left

        // Message
        messageLabel.font = messageLabel.font.withSize(textFontSize)
        messageLabel.textColor = textFontColor
        messageLabel.topConstraint?.constant = padding.top
        messageLabel.bottomConstraint?.constant = -padding.bottom

        // Constraints
        self.bottomConstraint?.constant = -(bottomMargin)
        self.leftConstraint?.constant = sideMargins
        self.rightConstraint?.constant = -(sideMargins)
        
        // Actions
        actionStack.topConstraint?.constant = padding.top
        actionStack.bottomConstraint?.constant = -padding.bottom
        actionStack.rightConstraint?.constant = -padding.right

        // Corners
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = cornerRadius > 0.0

        // Background
        blurView.effect = backgroundBlurEffect

        // Tell UIKit what you want!
        setNeedsLayout()
        superview?.layoutIfNeeded()
    }

    override open func prepareForReuse() {
        messageLabel.text = nil
        imageView.image = nil
        for view in actionStack.arrangedSubviews {
            view.removeFromSuperview()
        }
    }

    @objc fileprivate func actionTapped(_ sender: RGActionButton?) {
        if let msg = self.message {
            presenter?.dismiss(msg)
        }
    }

}
