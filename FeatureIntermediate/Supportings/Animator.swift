//
//  Animator.swift
//  FeatureIntermediate
//
//  Created by pyretttt pyretttt on 16.03.2022.
//

import Foundation

public struct Animator {
    private enum Constants {
        static let defaultDuration: CGFloat = 0.4
        static let defaultSpringDamping: CGFloat = 0.8
        static let defaultSpringVelocity: CGFloat = 1.75
        static let defaultOptions: UIView.AnimationOptions = [.curveEaseInOut, .beginFromCurrentState, .allowUserInteraction]
    }
    
    public typealias Animations = () -> Void
    public typealias Completion = (Bool) -> Void
    
    let perform: (@escaping Animations, Completion?) -> Void
}

public extension Animator {
    static let defaultSpringAnimator = Animator { animations, completion in
        UIView.animate(
            withDuration: Constants.defaultDuration,
            delay: 0,
            usingSpringWithDamping: Constants.defaultSpringDamping,
            initialSpringVelocity: Constants.defaultSpringVelocity,
            options: Constants.defaultOptions,
            animations: animations,
            completion: completion
        )
    }
    
    static let `default` = Animator { animations, completion in
        UIView.animate(
            withDuration: Constants.defaultDuration,
            delay: 0,
            options: Constants.defaultOptions,
            animations: animations,
            completion: completion
        )
    }
}

public extension UIView {
    static func animate(with animator: Animator,
                        animations: @escaping Animator.Animations,
                        completion: Animator.Completion? = nil) {
        animator.perform(animations, completion)
    }
}
