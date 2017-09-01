//
//  RGMessage.swift
//  Pods
//
//  Created by Jakub Darowski on 29/08/2017.
//
//

import UIKit

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

public enum RGMessageDuration: NSTimeInterval {
    case custom = -1.0 // to be used with a provided duration
    case short = 2.0
    case long = 4.0
    case extraLong = 8.0
    case eternal = 1e9 // a billion seconds is close enough to eternity, right?
}

public class RGMessage: NSObject, Comparable {
    var image: UIImage?
    var text: String
    var priority: RGMessagePriority

    private var _duration: RGMessageDuration
    private var _customDuration: NSTimeInterval
    private var _actions = [RGAction]()

    public var actions: [RGAction] {
        get {
            return _actions
        }
    }

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

    func add(action: RGAction) {
        _actions.append(action)
    }

    func insert(action: RGAction, at index: Int) {
        if index >= _actions.count {
            _actions.append(action)
        } else if index < 0 {
            _actions.insert(action, atIndex: 0)
        } else {
            _actions.insert(action, atIndex: index)
        }
    }
    
    func remove(action: RGAction) {
        if let index = _actions.indexOf(action) {
            _actions.removeAtIndex(index)
        }
    }
    
    func removeAction(at index: Int) {
        if index>=0 && index < _actions.count {
            _actions.removeAtIndex(index)
        }
    }
    
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
