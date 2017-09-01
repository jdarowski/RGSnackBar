//
//  RGMessageView.swift
//  Pods
//
//  Created by Jakub Darowski on 31/08/2017.
//
//

import UIKit

class RGMessageView: UIView {
    public var message: RGMessage? {
        didSet {
            prepareForReuse()
            if let msg = message {
                layoutMessage(msg)
            }
        }
    }

    init(frame: CGRect=CGRectZero, message msg: RGMessage?) {
        message = msg
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func layoutMessage(message: RGMessage) {

    }

    public func prepareForReuse() {

    }

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
