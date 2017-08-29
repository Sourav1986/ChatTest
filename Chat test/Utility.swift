//
//  Utility.swift
//  Chat test
//
//  Created by Sourav Basu Roy on 29/08/17.
//  Copyright © 2017 beas. All rights reserved.
//

import Foundation
import UIKit

func shakeAnimation(view:UIView) -> Void {
    let animation = CABasicAnimation(keyPath: "position")
    animation.duration = 0.05
    animation.repeatCount = 5
    animation.autoreverses = true
    animation.fromValue = NSValue(cgPoint: CGPoint(x:view.center.x - 2.0, y:view.center.y))
    animation.toValue = NSValue(cgPoint: CGPoint(x:view.center.x + 2.0, y:view.center.y))
    view.layer.add(animation, forKey: "position")
}
