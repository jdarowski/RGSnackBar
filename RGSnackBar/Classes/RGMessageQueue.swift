//
//  RGMessageQueue.swift
//  RGSnackBar
//
//  Created by Jakub Darowski on 30.08.2017.
//
//

import UIKit
import SwiftPriorityQueue


/**
 * A priority queue for RGMessages. It accepts messages and later passes
 * them on to the specified presenter in the proper order.
 */

open class RGMessageQueue: NSObject {
    fileprivate var _messages = PriorityQueue<RGMessage>()
    fileprivate var _messageBeingShown: RGMessage?
    fileprivate var _operationQueue = OperationQueue()
    fileprivate static var instanceCounter: UInt = 0

    /// The RGMessagePresenter to be used for presenting messages
    open var presenter: RGMessagePresenter

    /// TODO: say something meaningful
    public init(presenter: RGMessagePresenter) {
        self.presenter = presenter
        _operationQueue.qualityOfService = .background
        _operationQueue.name = "com.wearerealitygames.rgsnackbar.messagequeue.\(RGMessageQueue.instanceCounter)"
        _operationQueue.maxConcurrentOperationCount = 1
        super.init()
        self.presenter.delegate = self
        RGMessageQueue.instanceCounter += 1
    }

    /**
     * Enqueues the `message` and presents it if none is being presented.
     *
     * - Parameter message: message to be pushed
     */
    open func push(_ message: RGMessage) {
        _operationQueue.addOperation({
            self._messages.push(message)

            guard self._messageBeingShown == nil else {
                // Already showing a message. Nothing to do here.
                return
            }
            self.showNextMessage()
        })
    }

    /// Present next message if there is one.
    func showNextMessage() {
        guard let queue = OperationQueue.current, queue == _operationQueue else {
            _operationQueue.addOperation({ self.showNextMessage() })
            return
        }
        if let message = _messages.pop() {
            _messageBeingShown = message
            DispatchQueue.main.async(execute: { 
                self.presenter.present(message)
            })
        }
    }
}

extension RGMessageQueue: RGMessagePresenterDelegate {
    public func presenter(_: RGMessagePresenter, didPresent message: RGMessage) {
        _messageBeingShown = message
    }

    public func presenter(_: RGMessagePresenter, didDismiss message: RGMessage) {
        _messageBeingShown = nil
        showNextMessage()
    }
}
