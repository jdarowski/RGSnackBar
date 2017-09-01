//
//  RGAction.swift
//  Pods
//
//  Created by Jakub Darowski on 29/08/2017.
//
//

import UIKit

public typealias RGActionBlock = ((RGAction) -> Void)
public class RGAction: NSObject {


    public var title: String
    public var action: RGActionBlock?

    public init(title: String, action: RGActionBlock?) {
        self.title = title
        self.action = action
        super.init()
    }
}
