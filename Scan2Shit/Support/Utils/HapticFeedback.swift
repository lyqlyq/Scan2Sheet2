//
//  HapticFeedback.swift
//  PolyArt
//
//  Created by Admin on 7/16/18.
//  Copyright © 2018 HCM. All rights reserved.
//

import UIKit

// https://medium.com/@sdrzn/make-your-ios-app-feel-better-a-comprehensive-guide-over-taptic-engine-and-haptic-feedback-724dec425f10
// AudioServicesPlaySystemSound(1521)
// AudioServicesPlaySystemSound(1520)

enum HapticFeedbackType {
    case ImpactFeedback
    case SelectionFeedback
    case NotificationFeedback
}

@available(iOS 10.0, *)
class HapticFeedback: NSObject {
    
    private var feedbackGenerator: NSObject
    private var hapticType: HapticFeedbackType
    private var subType: UINotificationFeedbackGenerator.FeedbackType!
    
    init(impactType: UIImpactFeedbackGenerator.FeedbackStyle) {
        feedbackGenerator = UIImpactFeedbackGenerator(style: impactType)
        hapticType = .ImpactFeedback
    }
    override init() {
        feedbackGenerator = UISelectionFeedbackGenerator()
        hapticType = .SelectionFeedback
    }
    init(notificationType: UINotificationFeedbackGenerator.FeedbackType) {
        feedbackGenerator = UINotificationFeedbackGenerator()
        hapticType = .NotificationFeedback
        subType = notificationType
    }
    func prepare() {
        (feedbackGenerator as? UIFeedbackGenerator)?.prepare()
    }
    func fire() {
        switch hapticType {
        case .ImpactFeedback:
            (feedbackGenerator as? UIImpactFeedbackGenerator)?.impactOccurred()
        case .SelectionFeedback:
            (feedbackGenerator as? UISelectionFeedbackGenerator)?.selectionChanged()
        case .NotificationFeedback:
            (feedbackGenerator as? UINotificationFeedbackGenerator)?.notificationOccurred(subType)
        }
    }
}
