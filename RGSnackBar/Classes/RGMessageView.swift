//
//  RGMessageView.swift
//  RGSnackBar
//
//  Created by Jakub Darowski on 31/08/2017.
//
//

import UIKit

/**
 * A generic message view. Should **not** be instantiated, but extended.
 *
 * Provides the basic variables and methods as well as some handy utility
 * methods. Base for all potential message-displaying views.
 */
public class RGMessageView: UIView {

    /// The message to be displayed in the view
    public var message: RGMessage? {
        didSet {
            prepareForReuse()
            if let msg = message {
                layoutMessage(msg)
            }
        }
    }

    /**
     * The main constructor.
     *
     * - Parameter frame: the desired frame of the message view
     * - Parameter message: themessage to be displayed or nil
     */
    public init(frame: CGRect = .zero, message msg: RGMessage?) {
        message = msg
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /// Prepare the view for displaying a new message
    public func layoutMessage(message: RGMessage) {}

    /**
     * Apply styles. Should be called whenever style is changed or the view
     * has been changed in any way.
     */
    public func style() {}

    /// Clear the view of any filled-in data
    public func prepareForReuse() {}

    /**
     * A small utility method for disabling autoresizing masks for 
     * autolayout to work properly
     */
    func disableTranslatingAutoresizing(view: UIView?) {
        guard let actualView = view else {
            return
        }
        actualView.translatesAutoresizingMaskIntoConstraints = false
        for subview in subviews {
            if subview.translatesAutoresizingMaskIntoConstraints {
                disableTranslatingAutoresizing(subview)
            }
        }
    }
}
