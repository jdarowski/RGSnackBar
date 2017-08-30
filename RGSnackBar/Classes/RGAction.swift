//
//  RGAction.swift
//  Pods
//
//  Created by Jakub Darowski on 29/08/2017.
//
//

import UIKit

enum RGActionPriority: Int {
    case verbose    = -200
    case info       = -100
    case `default`  = 0
    case warning    = 100
    case error      = 1000
    case critical   = 1000000
}

class RGAction: NSObject {

    typealias RGActionBlock = ((RGAction) -> Void)
    var title: String
    var action: RGActionBlock?

    init(title: String, action: RGActionBlock?) {
        self.title = title
        self.action = action
        super.init()
    }
}
