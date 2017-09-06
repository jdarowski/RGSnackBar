//
//  RGMessage.swift
//  Pods
//
//  Created by Jakub Darowski on 29/08/2017.
//
//

import UIKit

/// A human-readable message priority.
public enum RGMessagePriority: Int {
    case verbose    = -200
    case info       = -100
    case standard   = 0 // wanted default, but swiftc doesn't like it :(
    case warning    = 100
    case error      = 1000
    case critical   = 1000000
    
    var stringValue: String {
        switch self {
        case .verbose:
            return "VERBOSE"
        case .info:
            return "INFO---"
        case .standard:
            return "STD----"
        case .warning:
            return "WARN---"
        case .error:
            return "ERR----"
        case .critical:
            return "CRIT---"
        }
    }
}

/// Pre-defined durations. Use `custom` if pou want a
public enum RGMessageDuration: NSTimeInterval {
    /// Custom duration. Set `customDuration` in the constructor!
    case custom = -1.0 // to be used with a provided duration
    /// 2 seconds. Enough for 2-3 word messages
    case short = 2.0
    /// 4 seconds. Enough for a whole sentence.
    case long = 4.0
    /// 8 seconds. Enough for a couple of sentences.
    case extraLong = 8.0
    /**
     * 1,000,000,000 seconds. A billion seconds is close enough
     * to eternity, right? To be used when user interaction is encouraged.
     */
    case eternal = 1e9
}

/**
 * The message itself. Besides carryin texs it has priority and actions.
 * You probably won't achieve much by subclassing this, but go ahead
 * if you want to
 */
public class RGMessage: NSObject, Comparable {
    /// An optional image to be displayed along the message. Like a tick or sth.
    var image: UIImage?
    /// The message's message ( ͡° ͜ʖ ͡°)
    var text: String
    /// Message priority.
    var priority: RGMessagePriority

    private var _duration: RGMessageDuration
    private var _customDuration: NSTimeInterval
    private var _actions = [RGAction]()

    /// Get your actions here
    public var actions: [RGAction] {
        get {
            return _actions
        }
    }

    /// The designated initializer. Takes in all you need.
    public init?(text: String,
         image: UIImage?=nil,
         actions: [RGAction]?=nil,
         priority: RGMessagePriority=RGMessagePriority.standard,
         duration: RGMessageDuration,
         customDuration: NSTimeInterval?=nil) {
        self.text = text
        self.image = image
        self.priority = priority
        if let actns = actions {
            self._actions = actns
        }
        self._duration = duration
        if _duration == .custom {
            if customDuration == nil{
                return nil
            } else {
                _customDuration = customDuration!
            }
        } else {
            _customDuration = 0.0
        }
        

        super.init()
    }

    /**
     * Add an action
     * - Parameter action: action
     */
    func add(action: RGAction) {
        _actions.append(action)
    }

    /**
     * Insert an action where you want it
     * - Parameter action: action
     * - Parameter at: index at which to insert
     */
    func insert(action: RGAction, at index: Int) {
        if index >= _actions.count {
            _actions.append(action)
        } else if index < 0 {
            _actions.insert(action, atIndex: 0)
        } else {
            _actions.insert(action, atIndex: index)
        }
    }

    /**
     * Remove an action
     * - Parameter action: action
     */
    func remove(action: RGAction) {
        if let index = _actions.indexOf(action) {
            _actions.removeAtIndex(index)
        }
    }

    /**
     * Remove an action at index
     * - Parameter at: index to remove from
     */
    func removeAction(at index: Int) {
        if index>=0 && index < _actions.count {
            _actions.removeAtIndex(index)
        }
    }

    /// The actual duration for displaying the message
    var duration: NSTimeInterval {
        if _duration == .custom {
            return _customDuration
        } else {
            return _duration.rawValue
        }
    }
}

public func <(lhs: RGMessage, rhs: RGMessage) -> Bool {
    return lhs.priority.rawValue < rhs.priority.rawValue
}

public func >(lhs: RGMessage, rhs: RGMessage) -> Bool {
    return lhs.priority.rawValue > rhs.priority.rawValue
}
