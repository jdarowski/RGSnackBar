//
//  RGMessagePresenter.swift
//  Pods
//
//  Created by Jakub Darowski on 30.08.2017.
//
//

import UIKit

public protocol RGMessagePresenter: RGMessageQueueDelegate {
    var messageQueue: RGMessageQueue { get }
    
    func enqueue(message: RGMessage)
}

public class RGMessageConsolePresenter: RGMessagePresenter {
    private var _messageQueue: RGMessageQueue
    public var messageQueue: RGMessageQueue { return _messageQueue }
    
    public init(queue: RGMessageQueue=RGMessageQueue()) {
        _messageQueue = queue
        _messageQueue.delegate = self
    }
    
    public func enqueue(message: RGMessage) {
        messageQueue.push(message)
    }
    
    public func animationDuration(message: RGMessage, from queue: RGMessageQueue) -> NSTimeInterval {
        return 0.0
    }
    
    public func show(message: RGMessage, from queue: RGMessageQueue) -> Bool {
        print("---- \(NSDate().timeIntervalSince1970) - BEGIN RGMESSAGE ----")
        print(message.priority.stringValue + ": " + message.text)
        return true
    }
    
    public func dismissMessage(from queue: RGMessageQueue) -> Bool {
        print("---- \(NSDate().timeIntervalSince1970) -  END RGMESSAGE  ----")
        return true
    }
}




