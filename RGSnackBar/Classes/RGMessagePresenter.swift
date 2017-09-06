//
//  RGMessagePresenter.swift
//  Pods
//
//  Created by Jakub Darowski on 30.08.2017.
//
//

import UIKit

/**
 * The protocol that defines the behaviour of a presenter.
 */
public protocol RGMessagePresenter {
    /**
     * The delegate which might (and should) be informed whenever the message
     * has been presented or dismissed.
     */
    weak var delegate: RGMessagePresenterDelegate? { get set }

    /**
     * Present the message in this presenter's specific way.
     * - Parameter message: message to be presented
     */
    func present(message: RGMessage)

    /**
     * Dismiss the message in this presenter's specific way.
     * - Parameter message: message to be dismissed
     */
    func dismiss(message: RGMessage)
}

public protocol RGMessagePresenterDelegate: class {
    func presenter(_: RGMessagePresenter, didPresent message: RGMessage)
    func presenter(_: RGMessagePresenter, didDismiss message: RGMessage)
}
