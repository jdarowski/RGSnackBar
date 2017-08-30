//
//  RGMessage.swift
//  Pods
//
//  Created by Jakub Darowski on 29/08/2017.
//
//

import UIKit

class RGMessage: NSObject {
    var image: UIImage?
    var message: String
    private var actions = [RGAction]()

    init(message: String, image: UIImage?=nil, actions: [RGAction]?=nil) {
        self.message = message
        self.image = image
        
        super.init()
    }

    func addAction(action: RGAction)
}
