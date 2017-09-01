//
//  RGMessageButton.swift
//  Pods
//
//  Created by Jakub Darowski on 01/09/2017.
//
//

import UIKit

class RGActionButton: UIButton {

    var action: RGAction

    init(action: RGAction) {
        self.action = action
        super.init(frame: .zero)

        self.setTitle(action.title, forState: .Normal)
        self.addTarget(self, action: #selector(performAction(_:)), forControlEvents: .TouchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        self.action = RGAction(title: "", action: nil)
        super.init(coder: aDecoder)
    }

    func performAction(sender: RGActionButton) {
        action.action?(action)
    }

}
