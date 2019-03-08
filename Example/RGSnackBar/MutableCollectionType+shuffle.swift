//
//  MutableCollectionType+shuffle.swift
//  RGSnackBar
//
//  Created by Jakub Darowski on 07/09/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

extension MutableCollection where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in startIndex ..< endIndex - 1 {
            let j = Int(arc4random_uniform(UInt32(endIndex - i))) + i
            if i != j {
                swapAt(i, j)
            }
        }
    }
}

extension Collection {
    /// Return a copy of `self` with its elements shuffled.
    func shuffle() -> [Iterator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}
