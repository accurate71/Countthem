//
//  AppStoreReviewManager.swift
//  Countthem
//
//  Created by Accurate on 16/06/2019.
//  Copyright © 2019 Kirill Pushkarskiy. All rights reserved.
//

import Foundation
import StoreKit

enum AppStoreReviewManager {
    
    static func requestReviewIfAppropriate() {
        SKStoreReviewController.requestReview()
    }
}
