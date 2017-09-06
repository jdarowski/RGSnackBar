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

public class RGMessageQueue: NSObject {
    private var _messages = PriorityQueue<RGMessage>()
    private var _messageBeingShown: RGMessage?
    private var _operationQueue = NSOperationQueue()
    private static var instanceCounter: UInt = 0

    /// The RGMessagePresenter to be used for presenting messages
    public var presenter: RGMessagePresenter

    /// TODO: say something meaningful
    public init(presenter: RGMessagePresenter) {
        self.presenter = presenter
        _operationQueue.qualityOfService = .Background
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
    public func push(message: RGMessage) {
        _operationQueue.addOperationWithBlock({
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
        guard let queue = NSOperationQueue.currentQueue() where queue == _operationQueue else {
            _operationQueue.addOperationWithBlock({ self.showNextMessage() })
            return
        }
        if let message = _messages.pop() {
            _messageBeingShown = message
            dispatch_async(dispatch_get_main_queue(), { 
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
