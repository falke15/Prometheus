//
//  AnimationDelegate.swift
//  FeatureIntermediate
//
//  Created by pyretttt pyretttt on 03.05.2022.
//

import UIKit

public final class AnimationDelegate: NSObject, CAAnimationDelegate {
    let completion: () -> Void
    
    public init(completion: @escaping () -> Void) {
        self.completion = completion
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        completion()
    }
}
