//
//  ViewController.swift
//  RGSnackBar
//
//  Created by jdarowski on 08/29/2017.
//  Copyright (c) 2017 jdarowski. All rights reserved.
//

import UIKit
import RGSnackBar

class ViewController: UIViewController {

    @IBOutlet weak var lengthControl: UISegmentedControl!
    @IBOutlet weak var prorityControl: UISegmentedControl!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var enqueueButton: UIButton!

    var messageQueue: RGMessageQueue!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if let window = UIApplication.sharedApplication().keyWindow {
            messageQueue = RGMessageQueue(presenter: RGMessageSnackBarPresenter(view: view, animation: RGMessageSnackBarAnimation.slideUp, bottomMargin: 20.0, sideMargins: 8.0, cornerRadius: 8.0))
        } else {
            messageQueue = RGMessageQueue(presenter: RGMessageSnackBarPresenter(view: view, animation: RGMessageSnackBarAnimation.zoomIn))
        }
    }

    @IBAction func enqueueButtonPressed(sender: AnyObject) {
        var duration: RGMessageDuration
        switch lengthControl.selectedSegmentIndex {
        case 1:
            duration = .long
        case 2:
            duration = .extraLong
        case 3:
            duration = .eternal
        default:
            duration = .short
        }
        var priority: RGMessagePriority
        switch prorityControl.selectedSegmentIndex {
        case 0:
            priority = .verbose
        case 1:
            priority = .info
        case 3:
            priority = .warning
        case 4:
            priority = .error
        case 5:
            priority = .critical
        default:
            priority = .standard
        }
        let message = messageTextField.text ?? "Empty message wtf"
        
        let actions = [RGAction(title: "Try again", action: { print($0.title) })
            , RGAction(title: "hax", action: { print($0.title)})
        ]

        if let rgmessage = RGMessage(text: message, image: UIImage(named: "warning"), priority: priority, actions: actions, duration: duration) {
            messageQueue.push(rgmessage)
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let newText = text.stringByReplacingCharactersInRange(range, withString: string)
            if newText != "" {
                enqueueButton.enabled = true
            } else {
                enqueueButton.enabled = false
            }
        }
        return true
    }
}

