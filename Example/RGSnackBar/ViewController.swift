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
    
    var messagePresenter = RGMessageConsolePresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func enqueueButtonPressed(sender: AnyObject) {
        var duration: RGMessageDuration
        switch lengthControl.selectedSegmentIndex {
        case 1:
            duration = .long
        case 2:
            duration = .extraLong
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
        
        if let rgmessage = RGMessage(text: message, priority: priority, duration: duration) {
            messagePresenter.enqueue(rgmessage)
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

