//
//  AppAnimationHelper.swift
//  Countthem
//
//  Created by Accurate on 21/05/2019.
//  Copyright © 2019 Kirill Pushkarskiy. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit

class AppAnimationHelper {
    
    func animationDeleting(for view: UIView) {
        
        // Setup an animation
        let transition = CATransition()
        transition.type = CATransitionType.fade
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        
        // Add the animation
        view.layer.add(transition, forKey: nil)
    }
    
    func clickButton(view: UIView, color1: UIColor, color2: UIColor, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        let groups = CAAnimationGroup()
        
        let animBackgoundColor = CABasicAnimation(keyPath: "backgroundColor")
        animBackgoundColor.fromValue = color1.cgColor
        animBackgoundColor.toValue = color2.cgColor
        animBackgoundColor.duration = 0.1
        animBackgoundColor.autoreverses = true
        
        let animPosition = CABasicAnimation(keyPath: "position.y")
        animPosition.fromValue = view.center.y
        animPosition.toValue = view.center.y + 5.0
        animPosition.duration = 0.1
        animPosition.autoreverses = true
        
        CATransaction.setCompletionBlock(completion)
        view.layer.add(animBackgoundColor, forKey: nil)
        view.layer.add(animPosition, forKey: nil)
        CATransaction.commit()
    }
    
    func shakeError(view: UIView) {
        print("shaking")
        let shakeAnim = CASpringAnimation(keyPath: "position.x")
        shakeAnim.fromValue = view.center.x
        shakeAnim.toValue = view.center.x + 10
        shakeAnim.damping = 2.0
        shakeAnim.duration = shakeAnim.settlingDuration
        view.layer.add(shakeAnim, forKey: "viewShaking")
    }
    
}
