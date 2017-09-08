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
    @IBOutlet weak var animationControl: UISegmentedControl!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var enqueueButton: UIButton!

    @IBOutlet weak var numberOfActionsTextField: UITextField!
    @IBOutlet weak var numberOfActionsStepper: UIStepper!

    @IBOutlet weak var bottomMarginSlider: UISlider!
    @IBOutlet weak var sideMarginsSlider: UISlider!
    @IBOutlet weak var cornerRadiusSlider: UISlider!
    @IBOutlet weak var buttonFontSizeSlider: UISlider!
    @IBOutlet weak var labelFontSizeSlider: UISlider!

    @IBOutlet weak var bottomMarginTextField: UITextField!
    @IBOutlet weak var sideMarginsTextField: UITextField!
    @IBOutlet weak var cornerRadiusTextField: UITextField!
    @IBOutlet weak var buttonFontSizeTextField: UITextField!
    @IBOutlet weak var labelFontSizeTextField: UITextField!

    let textFieldNumberFormatter = NSNumberFormatter()

    @IBOutlet weak var scrollView: UIScrollView?

    var tapGestureRecognizer: UITapGestureRecognizer!


    var messageQueue: RGMessageQueue!
    var presenter: RGMessageSnackBarPresenter?

    var numberOfActions: Int = 1

    var randomActionNames = [
        "Retry",
        "Reload",
        "Okay",
        "Cancel",
        "Save",
        "Jump",
        "Mate",
        "Feed",
        "Survive",
        "Sleep",
        "Wake up",
        "Grab",
        "Put",
        "A little",
        "Make up"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldNumberFormatter.allowsFloats = true
        textFieldNumberFormatter.maximumFractionDigits = 2
        // Do any additional setup after loading the view, typically from a nib.
        tapGestureRecognizer =
            UITapGestureRecognizer(target: self,
                                   action: #selector(scrollTapped(_:)))
        scrollView?.addGestureRecognizer(tapGestureRecognizer)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        stepperValueChanged(numberOfActionsStepper)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if let window = UIApplication.sharedApplication().keyWindow {
            presenter = RGMessageSnackBarPresenter(view: window,
                                                   animation: RGMessageSnackBarAnimation.slideUp,
                                                   bottomMargin: 20.0,
                                                   sideMargins: 8.0,
                                                   cornerRadius: 4.0)
            messageQueue = RGMessageQueue(presenter: presenter!)
        } else {
            messageQueue = RGMessageQueue(presenter: RGMessageSnackBarPresenter(view: view, animation: RGMessageSnackBarAnimation.slideUp))
        }

        sliderValueChanged(bottomMarginSlider)
        sliderValueChanged(sideMarginsSlider)
        sliderValueChanged(cornerRadiusSlider)
        sliderValueChanged(buttonFontSizeSlider)
        sliderValueChanged(labelFontSizeSlider)
        animationControlValueChanged(animationControl)
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    @IBAction func animationControlValueChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            presenter?.animation = RGMessageSnackBarAnimation.zoomIn
        default:
            presenter?.animation = RGMessageSnackBarAnimation.slideUp
        }
    }

    @IBAction func enqueueButtonPressed(sender: AnyObject) {

        randomActionNames.shuffleInPlace()
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

        var actions = [RGAction]()
        for i in 0..<numberOfActions {
            actions.append(RGAction(title: randomActionNames[i], action: { print($0.title) }))
        }

        if let rgmessage = RGMessage(text: message, image: nil, priority: priority, actions: actions, duration: duration) {
            messageQueue.push(rgmessage)
        }
    }

    @IBAction func stepperValueChanged(sender: UIStepper) {
        numberOfActions = Int(sender.value)
        numberOfActionsTextField.text = "\(numberOfActions)"
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }

    @IBAction func sliderValueChanged(sender: UISlider) {
        let value = CGFloat(sender.value)
        switch sender {
        case bottomMarginSlider:
            presenter?.snackBarView.bottomMargin = value
            bottomMarginTextField.text = textFieldNumberFormatter.stringFromNumber(value)
        case sideMarginsSlider:
            presenter?.snackBarView.sideMargins = value
            sideMarginsTextField.text = textFieldNumberFormatter.stringFromNumber(value)
        case cornerRadiusSlider:
            presenter?.snackBarView.cornerRadius = value
            cornerRadiusTextField.text = textFieldNumberFormatter.stringFromNumber(value)
        case buttonFontSizeSlider:
            presenter?.snackBarView.buttonFontSize = value
            buttonFontSizeTextField.text = textFieldNumberFormatter.stringFromNumber(value)
        case labelFontSizeSlider:
            presenter?.snackBarView.textFontSize = value
            labelFontSizeTextField.text = textFieldNumberFormatter.stringFromNumber(value)
        default:
            print("Unknown slider ;o")
        }
    }

    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height

        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animationCurve = UIViewAnimationCurve(rawValue:(userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue)!

        if var insets = self.scrollView?.contentInset {
            insets.bottom += keyboardHeight
            self.scrollView?.contentInset = insets
        }

        UIView.setAnimationCurve(animationCurve)
        UIView.animateWithDuration(animationDuration, animations: { 
            if var offset = self.scrollView?.contentOffset {
                offset.y += keyboardHeight

                if let contentSize = self.scrollView?.contentSize {
                    if self.view.frame.size.height - keyboardHeight + offset.y > contentSize.height {
                        offset.y = abs(self.view.frame.size.height - keyboardHeight - contentSize.height)
                    }
                }
                self.scrollView?.contentOffset = offset
            }
            })

        self.view.layoutIfNeeded()
    }

    func keyboardWillHide(notification: NSNotification) {

        let userInfo = notification.userInfo!
        let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height

        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animationCurve = UIViewAnimationCurve(rawValue:(userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue)!

        if var insets = self.scrollView?.contentInset {
            insets.bottom -= keyboardHeight
            self.scrollView?.contentInset = insets
        }

        UIView.setAnimationCurve(animationCurve)
        UIView.animateWithDuration(animationDuration, animations: {
            if var offset = self.scrollView?.contentOffset {
                offset.y -= keyboardHeight
                if offset.y < 0.0 { offset.y = 0.0 }
                self.scrollView?.contentOffset = offset
            }
        })

        self.view.layoutIfNeeded()
    }

    func scrollTapped(recognizer: UIGestureRecognizer) {
        self.view.endEditing(true)
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

