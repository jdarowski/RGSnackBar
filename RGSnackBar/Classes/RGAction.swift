//
//  RGAction.swift
//  RGSnackBar
//
//  Created by Jakub Darowski on 29/08/2017.
//
//

import UIKit

public typealias RGActionBlock = ((RGAction) -> Void)

/**
 * Action for the snackbar. Can have a title and an action block. What else would you need?
 */
open class RGAction: NSObject {

    open var title: String
    open var action: RGActionBlock?

    public init(title: String, action: RGActionBlock?) {
        self.title = title
        self.action = action
        super.init()
    }
}
