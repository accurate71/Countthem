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
    
}
