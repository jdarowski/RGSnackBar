//
//  RGMessagePresenter.swift
//  Pods
//
//  Created by Jakub Darowski on 30.08.2017.
//
//

import UIKit

public protocol RGMessagePresenter {
    weak var delegate: RGMessagePresenterDelegate? { get set }
    func present(message: RGMessage)
    func dismiss(message: RGMessage)
}

public protocol RGMessagePresenterDelegate: class {
    func presenter(_: RGMessagePresenter, didPresent message: RGMessage)
    func presenter(_: RGMessagePresenter, didDismiss message: RGMessage)
}
