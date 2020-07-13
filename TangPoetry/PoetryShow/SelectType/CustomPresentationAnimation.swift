//
//  CustomPresentationAnimation.swift
//  TangPoetry
//
//  Created by huahuahu on 2020/5/10.
//  Copyright © 2020 huahuahu. All rights reserved.
//

//swiftlint:disable multiple_closures_with_trailing_closure
import UIKit

enum CutsomTransition {
    class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
        func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return PresentAnimator(presenting: true)
        }
        
        func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return PresentAnimator(presenting: false)
        }
        
        //        func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        //            return PercentDrivenInteractiveTransition()
        //        }
        //
        //        func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        //            return PercentDrivenInteractiveTransition()
        //        }
        func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
            return PresentationController.init(presentedViewController: presented, presenting: presenting)
        }
    }
    
    class PresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
        let presenting: Bool
        
        init(presenting: Bool) {
            self.presenting = presenting
            super.init()
        }
        
        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.9
        }
        
        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            // Get the set of relevant objects.
            let containerView = transitionContext.containerView
            let fromVC = transitionContext.viewController(forKey: .from)
            let toVC = transitionContext.viewController(forKey: .to)
            
            let toView = transitionContext.view(forKey: .to)!
            let fromView = transitionContext.view(forKey: .from)
            
            // Set up some variables for the animation.
            let containerFrame = containerView.frame
            var toViewStartFrame = transitionContext.initialFrame(for: toVC!)
            let toViewFinalFrame = transitionContext.finalFrame(for: toVC!)
            var fromViewFinalFrame = transitionContext.finalFrame(for: fromVC!)
            
            // Set up the animation parameters.
            if self.presenting {
                // Modify the frame of the presented view so that it starts
                // offscreen at the lower-right corner of the container.
                toViewStartFrame.origin.x = containerFrame.size.width
                toViewStartFrame.origin.y = containerFrame.size.height
            } else {
                // Modify the frame of the dismissed view so it ends in
                // the lower-right corner of the container view.
                fromViewFinalFrame = .init(x: containerFrame.size.width,
                                           y: containerFrame.size.height,
                                           width: toView.frame.size.width,
                                           height: toView.frame.size.height)
            }
            
            // Always add the "to" view to the container.
            // And it doesn't hurt to set its start frame.
            containerView.addSubview(toView)
            toView.frame = toViewStartFrame
            
            // Animate using the animator's own duration value.
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
                if self.presenting {
                    toView.frame = toViewFinalFrame
                } else {
                    fromView?.frame = fromViewFinalFrame
                }
            }) { _ in
                let success = !transitionContext.transitionWasCancelled
                // After a failed presentation or successful dismissal, remove the view.
                if (self.presenting && !success) || (!self.presenting &&  success) {
                    toView.removeFromSuperview()
                }
                
                // Notify UIKit that the transition has finished
                transitionContext.completeTransition(success)
            }
        }
        
        func animationEnded(_ transitionCompleted: Bool) {
            print("\(#function): \(transitionCompleted)")
        }
    }
    
    class PercentDrivenInteractiveTransition: UIPercentDrivenInteractiveTransition {
        private var contextData: UIViewControllerContextTransitioning!
        private var panGesture: UIPanGestureRecognizer!
        
        override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
            super.startInteractiveTransition(transitionContext)
            
            // Save the transition context for future reference.
            self.contextData = transitionContext
            
            // Create a pan gesture recognizer to monitor events.
            self.panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(handleSwipeUpdate(gestureRecognizer:)))
            self.panGesture.maximumNumberOfTouches = 1
            
            // Add the gesture recognizer to the container view.
            let container = transitionContext.containerView
            container.addGestureRecognizer(panGesture)
        }
        
        @objc func handleSwipeUpdate(gestureRecognizer: UIGestureRecognizer) {
            let container = contextData.containerView
            
            if gestureRecognizer.state == .began {
                // Reset the translation value at the beginning of the gesture.
                panGesture.setTranslation(.zero, in: container)
            } else if gestureRecognizer.state == .changed {
                let translation = panGesture.translation(in: container)
                // Compute how far the gesture has travelled vertically,
                //  relative to the height of the container view.
                let percentage = abs(translation.y / container.bounds.height)
                print(percentage)
                update(percentage)
            } else if gestureRecognizer.state.rawValue >= UIGestureRecognizer.State.ended.rawValue {
                finish()
                contextData.containerView.removeGestureRecognizer(panGesture)
            }
        }
    }
    
    class PresentationController: UIPresentationController {
        private let dimmingView: UIView
        
        override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
            dimmingView = UIView()
            super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
            dimmingView.backgroundColor = .init(white: 0.0, alpha: 0.4)
            dimmingView.alpha = 0.0
        }
        
        override var frameOfPresentedViewInContainerView: CGRect {
            var presentedViewFrame = CGRect.zero
            let containerBounds = containerView!.bounds
            
            presentedViewFrame.size = CGSize(
                width: CGFloat(floorf(Float((CGFloat(containerBounds.size.width) / 2.0)))),
                height: containerBounds.size.height
            )
            presentedViewFrame.origin.x = containerBounds.size.width -
                presentedViewFrame.size.width
            return presentedViewFrame
        }
        
        override func presentationTransitionWillBegin() {
            // Get critical information about the presentation.
            let containerView = self.containerView!
            // Set the dimming view to the size of the container's
            // bounds, and make it transparent initially.
            dimmingView.frame = containerView.bounds
            dimmingView.alpha = 0
            
            // Insert the dimming view below everything else.
            containerView.insertSubview(dimmingView, at: 0)
            // Set up the animations for fading in the dimming view.
            if let transitionCoordinator = presentedViewController.transitionCoordinator {
                transitionCoordinator.animate(alongsideTransition: { _ in
                    self.dimmingView.alpha = 1.0
                }) { _ in
                    
                }
            } else {
                dimmingView.alpha = 1.0
            }
        }
        
        override func presentationTransitionDidEnd(_ completed: Bool) {
            if !completed {
                dimmingView.removeFromSuperview()
            }
        }
    }
}
