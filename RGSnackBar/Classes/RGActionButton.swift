//
//  RGMessageButton.swift
//  RGSnackBar
//
//  Created by Jakub Darowski on 01/09/2017.
//
//

import UIKit

/**
 * The snackbar action button.
 *
 * This button has one purpose: perform teh action assigned to it. If you want
 * a custom button, just subclass this. Or edit the layers. Whatever you need.
 */
open class RGActionButton: UIButton {

    /// The action to be performed
    open var action: RGAction

    /**
     * The default constructor. You don't really need another one.
     * 
     * Must be called even when overrided. Otherwise you'll need to add the
     * target to the button manually.
     */
    public init(action: RGAction) {
        self.action = action
        super.init(frame: .zero)

        self.setTitle(action.title, for: UIControlState())
        self.addTarget(self, action: #selector(performAction(_:)), for: .touchUpInside)
    }

    /// This is a stub. Should not be used really yet.
    public required init?(coder aDecoder: NSCoder) {
        self.action = RGAction(title: "", action: nil)
        super.init(coder: aDecoder)
    }

    /// Simply launches the action. Don't touch this please.
    @objc fileprivate func performAction(_ sender: RGActionButton) {
        action.action?(action)
    }

}
