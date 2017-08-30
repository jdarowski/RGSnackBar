//
//  RGMessageQueue.swift
//  Pods
//
//  Created by Jakub Darowski on 30.08.2017.
//
//

import UIKit
import SwiftPriorityQueue

/**
 *  A delegate protocol for the message queue
 */
public protocol RGMessageQueueDelegate : class {
    func animationDuration(message: RGMessage, from queue: RGMessageQueue) -> NSTimeInterval
    func show(message: RGMessage, from queue: RGMessageQueue) -> Bool
    func dismissMessage(from queue: RGMessageQueue) -> Bool
}

public class RGMessageQueue: NSObject {
    private var _messages = PriorityQueue<RGMessage>()
    private var _showingTimer: NSTimer?
    private var _hidingTimer: NSTimer?
    private var _messageBeingShown: RGMessage?
    private var _waitingQueue: dispatch_queue_t = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
    weak var delegate: RGMessageQueueDelegate?
    
    func push(message: RGMessage) {
        _messages.push(message)
        
        guard _messageBeingShown == nil else {
            // Already showing a message. Nothing to do here.
            return
        }
        showNextMessage()
    }
    
    func showNextMessage() {
        if let message = _messages.pop() {
            show(message)
        }
    }
    
    func show(message: RGMessage) {
        if let del = delegate {
            let totalTime = del.animationDuration(message, from: self) + message.duration
            if del.show(message, from: self) {
                _messageBeingShown = message
                _showingTimer?.invalidate()
                _showingTimer = NSTimer.scheduledTimerWithTimeInterval(totalTime, target: self, selector: #selector(messageShowingTimeUp(_:)), userInfo: nil, repeats: false)
            } else {
                print("ERROR: message showing failed")
            }
        } else {
            print("No delegate")
        }
    }
    
    func hideMessage() {
        guard let del = delegate else {
            print("No delegate")
            return
        }
        guard let message = _messageBeingShown else {
            print ("No message")
            return
        }
        guard del.dismissMessage(from: self) else {
            print("Couldn't dismiss message")
            return
        }
    }
    
    func messageShowingTimeUp(timer: NSTimer) {
        guard let del = delegate else {
            print("No delegate")
            return
        }
        guard let message = _messageBeingShown else {
            print ("No message")
            return
        }
        let time = del.animationDuration(message, from: self)
        hideMessage()
        if time > 0.0 {
            _hidingTimer?.invalidate()
            _hidingTimer = NSTimer(timeInterval: time, target: self, selector: #selector(messageHidingTimeUp(_:)), userInfo: nil, repeats: false)
        } else {
            messageHidingTimeUp(nil)
        }
    }
    
    func messageHidingTimeUp(timer: NSTimer?) {
        _messageBeingShown = nil
        showNextMessage()
    }
}
