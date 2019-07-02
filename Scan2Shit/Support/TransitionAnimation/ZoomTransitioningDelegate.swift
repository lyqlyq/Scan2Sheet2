//
//  ZoomTransitioningDelegate.swift
//  PolyArt
//
//  Created by Admin on 7/2/18.
//  Copyright © 2018 HCM. All rights reserved.
//

import UIKit

// sample use:
// viewcontroller.modalPresentationStyle = .custom
// viewcontroller.transitioningDelegate = ZoomTransitioningDelegate.shared
// viewcontroller.present

class ZoomTransitioningDelegate: NSObject {
    static let shared = ZoomTransitioningDelegate()
    
    override init() {
        DLOG("------------------init ZoomTransitioningDelegate----------")
    }
    deinit {
        DLOG("------------------deinit ZoomTransitioningDelegate----------")
    }
}

extension ZoomTransitioningDelegate: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ZoomAnimator(isPresenting: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ZoomAnimator(isPresenting: false)
    }
}

class ZoomAnimator: NSObject {
    
    let isPresenting :Bool
    let duration :TimeInterval = 0.3
    
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        
        super.init()
    }
    
    // MARK: Helper methods
    func animatePresentationWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let presentedController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let presentedControllerView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
                return
        }
        
        // Position the presented view off the top of the container view
        presentedControllerView.frame = transitionContext.finalFrame(for: presentedController)
        presentedControllerView.alpha = 0.5
        presentedControllerView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        transitionContext.containerView.addSubview(presentedControllerView)
        
        // Animate the presented view to it's final position
        UIView.animate(withDuration: self.duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .allowUserInteraction, animations: {
            presentedControllerView.alpha = 1.0
            presentedControllerView.transform = CGAffineTransform.identity
        }, completion: {(completed: Bool) -> Void in
            transitionContext.completeTransition(completed)
        })
    }
    
    func animateDismissalWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let presentedControllerView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            return
        }
        
        // Animate the presented view off the bottom of the view
        UIView.animate(withDuration: self.duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .allowUserInteraction, animations: {
            presentedControllerView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            presentedControllerView.alpha = 0.0
        }, completion: {(completed: Bool) -> Void in
            transitionContext.completeTransition(completed)
        })
    }
}

// MARK: UIViewControllerAnimatedTransitioning
extension ZoomAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)  {
        if isPresenting {
            animatePresentationWithTransitionContext(transitionContext: transitionContext)
        }
        else {
            animateDismissalWithTransitionContext(transitionContext: transitionContext)
        }
    }
}
