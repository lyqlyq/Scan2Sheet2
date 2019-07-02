//
//  Created by Pete Callaway on 26/06/2014.
//  Copyright (c) 2014 Dative Studios. All rights reserved.
//

import UIKit


class CustomPresentationController: UIPresentationController {

    lazy var dimmingView :UIView = {
        let view = UIView(frame: self.containerView!.bounds)
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        view.alpha = 0.0
        return view
    }()
    
    var presentedSize: CGSize = .zero

    // MARK: override UIPresentationController
    override func presentationTransitionWillBegin() {

		guard
			let containerView = containerView,
            let presentedView = presentedView
		else {
			return
		}

        // Add the dimming view and the presented view to the heirarchy
        dimmingView.frame = containerView.bounds
        containerView.addSubview(dimmingView)
        presentedView.layer.masksToBounds = true
        presentedView.layer.cornerRadius = 10
        containerView.addSubview(presentedView)

        // Fade in the dimming view alongside the transition
        if let transitionCoordinator = self.presentingViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: {(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.dimmingView.alpha = 1.0
            }, completion:nil)
        }
    }

    override func presentationTransitionDidEnd(_ completed: Bool)  {
        // If the presentation didn't complete, remove the dimming view
        if !completed {
            self.dimmingView.removeFromSuperview()
        }
    }

    override func dismissalTransitionWillBegin()  {
        // Fade out the dimming view alongside the transition
        if let transitionCoordinator = self.presentingViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: {(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.dimmingView.alpha  = 0.0
            }, completion:nil)
        }
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        // If the dismissal completed, remove the dimming view
        if completed {
            self.dimmingView.removeFromSuperview()
        }
    }

    override var frameOfPresentedViewInContainerView: CGRect {

		guard
			let containerView = containerView
		else {
			return CGRect()
		}

        // We don't want the presented view to fill the whole container view, so inset it's frame
        var frame = containerView.bounds
        if presentedSize == .zero {
            frame = frame.insetBy(dx: 20, dy: 100)
        }
        else {
            let dx = (frame.width - presentedSize.width)/2
            let dy = (frame.height - presentedSize.height)/2
            frame = frame.insetBy(dx: dx, dy: dy)
        }
        return frame
    }

    // MARK: override UIContentContainer
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

		guard
			let containerView = containerView
		else {
			return
		}

        coordinator.animate(alongsideTransition: {(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            self.dimmingView.frame = containerView.bounds
        }, completion:nil)
    }
}
