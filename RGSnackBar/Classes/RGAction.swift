//
//  RGAction.swift
//  Pods
//
//  Created by Jakub Darowski on 29/08/2017.
//
//

import UIKit

public class RGAction: NSObject {

    typealias RGActionBlock = ((RGAction) -> Void)
    var title: String
    var action: RGActionBlock?

    init(title: String, action: RGActionBlock?) {
        self.title = title
        self.action = action
        super.init()
    }
}
