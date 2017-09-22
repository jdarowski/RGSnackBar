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

    let textFieldNumberFormatter = NumberFormatter()

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        stepperValueChanged(numberOfActionsStepper)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let window = UIApplication.shared.keyWindow {
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
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    @IBAction func animationControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            presenter?.animation = RGMessageSnackBarAnimation.zoomIn
        default:
            presenter?.animation = RGMessageSnackBarAnimation.slideUp
        }
    }

    @IBAction func enqueueButtonPressed(_ sender: AnyObject) {

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

        if let rgmessage = RGMessage(text: message, image: nil, actions: actions, priority: priority, duration: duration) {
            messageQueue.push(rgmessage)
        }
    }

    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        numberOfActions = Int(sender.value)
        numberOfActionsTextField.text = "\(numberOfActions)"
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let value = sender.value
        let numberValue = NSNumber(value: value)
        let cgFloatValue = CGFloat(value)
        switch sender {
        case bottomMarginSlider:
            presenter?.snackBarView.bottomMargin = cgFloatValue
            bottomMarginTextField.text = textFieldNumberFormatter.string(from: numberValue)
        case sideMarginsSlider:
            presenter?.snackBarView.sideMargins = cgFloatValue
            sideMarginsTextField.text = textFieldNumberFormatter.string(from: numberValue)
        case cornerRadiusSlider:
            presenter?.snackBarView.cornerRadius = cgFloatValue
            cornerRadiusTextField.text = textFieldNumberFormatter.string(from: numberValue)
        case buttonFontSizeSlider:
            presenter?.snackBarView.buttonFontSize = cgFloatValue
            buttonFontSizeTextField.text = textFieldNumberFormatter.string(from: numberValue)
        case labelFontSizeSlider:
            presenter?.snackBarView.textFontSize = cgFloatValue
            labelFontSizeTextField.text = textFieldNumberFormatter.string(from: numberValue)
        default:
            print("Unknown slider ;o")
        }
    }

    func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height

        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animationCurve = UIViewAnimationCurve(rawValue:(userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue)!

        if var insets = self.scrollView?.contentInset {
            insets.bottom += keyboardHeight
            self.scrollView?.contentInset = insets
        }

        UIView.setAnimationCurve(animationCurve)
        UIView.animate(withDuration: animationDuration, animations: { 
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

    func keyboardWillHide(_ notification: Notification) {

        let userInfo = notification.userInfo!
        let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height

        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animationCurve = UIViewAnimationCurve(rawValue:(userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue)!

        if var insets = self.scrollView?.contentInset {
            insets.bottom -= keyboardHeight
            self.scrollView?.contentInset = insets
        }

        UIView.setAnimationCurve(animationCurve)
        UIView.animate(withDuration: animationDuration, animations: {
            if var offset = self.scrollView?.contentOffset {
                offset.y -= keyboardHeight
                if offset.y < 0.0 { offset.y = 0.0 }
                self.scrollView?.contentOffset = offset
            }
        })

        self.view.layoutIfNeeded()
    }

    func scrollTapped(_ recognizer: UIGestureRecognizer) {
        self.view.endEditing(true)
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let newText = text.replacingCharacters(in: range, with: string)
            if newText != "" {
                enqueueButton.isEnabled = true
            } else {
                enqueueButton.isEnabled = false
            }
        }
        return true
    }
}

