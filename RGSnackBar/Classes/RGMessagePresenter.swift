//
//  RGMessagePresenter.swift
//  RGSnackBar
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
    func present(_ message: RGMessage)

    /**
     * Dismiss the message in this presenter's specific way.
     * - Parameter message: message to be dismissed
     */
    func dismiss(_ message: RGMessage)
}

/**
 * The delegate that should react to presenter events.
 */
public protocol RGMessagePresenterDelegate: class {
    /**
     * Should be called whenever the presenter finished presenting 
     * (e.g. animating) the message.
     *
     * - Parameter _: the presenter, self
     * - Parameter message: message that was shown
     */
    func presenter(_: RGMessagePresenter, didPresent message: RGMessage)

    /**
     * Should be called whenever the presenter finished dismissing
     * (e.g. animating) the message.
     *
     * - Parameter _: the presenter, self
     * - Parameter message: message that was dismissed
     */
    func presenter(_: RGMessagePresenter, didDismiss message: RGMessage)
}
