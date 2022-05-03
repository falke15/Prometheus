//
//  SpashScreenViewController.swift
//  Prometheus
//
//  Created by pyretttt pyretttt on 03.05.2022.
//

import UIKit
import FeatureIntermediate

private extension String {
    static let codes = [
        "0xFF", "Matrix", "Transform", "Coffee", "Socket",
        "C++", "Backdoor", "Ethereum", "Unix", "Proxy",
        "Undo", "Register", "Unity", "Fiber", "3D",
        "Doom", "Gitlab", "Admin", "Password", "Mr.Robot"
    ]
}

/// Сплэш скрин
final class SpashScreenViewController: UIViewController, RouteChainLink {
    
    private enum Constants {
        static let primaryColor = UIColor(red: 51 / 255, green: 1, blue: 51 / 255, alpha: 1)
    }
    
    // MARK: - RouteChainLink
    
    var prevLink: RouteChainLink? = nil
    var nextLink: RouteChainLink?
    
    // MARK: - Visual elements
    
    private lazy var textLayer: CATextLayer = {
        let layer = CATextLayer()
        layer.string = String.codes.max(by: { $0.count < $1.count })
        layer.alignmentMode = .center
        layer.fontSize = 36
        layer.foregroundColor = Constants.primaryColor.cgColor
        layer.frame.size = layer.preferredFrameSize()
        layer.string = "Prometheus"
        
        return layer
    }()
    
    // MARK: - Lifecycle
    
    init(nextLink: RouteChainLink) {
        self.nextLink = nextLink
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.layer.addSublayer(textLayer)
    }
    
    override func viewDidLayoutSubviews() {
        textLayer.position = view.center
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        runChainOfTransitions(animatedLayer: textLayer,
                              times: 7,
                              contents: String.codes) { [weak self] in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.3) {
                self.view.backgroundColor = Pallete.Light.white1
            }
            let animation = self.makeScaleAnimation(factor: 5)
            animation.delegate = AnimationDelegate { [weak self] in
                self?.nextLink?.route(navigationController: nil)
            }
            self.textLayer.add(animation, forKey: "endAnimations")
        }
    }
    
    // MARK: - Animations
    
    private func runChainOfTransitions<V>(animatedLayer: CATextLayer,
                                          times: Int,
                                          contents: [V],
                                          completion: (() -> Void)?) {
        var runs = 0
        
        func r() {
            let animation = CATransition()
            animation.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
            animation.type = CATransitionType.fade
            animation.delegate = AnimationDelegate { [weak animatedLayer] in
                while runs < times {
                    r()
                    runs += 1
                    return
                }
                animatedLayer?.removeAllAnimations()
                completion?()
            }
            animation.duration = 0.2
            animatedLayer.add(animation, forKey: CATransitionType.fade.rawValue)
            animatedLayer.string = contents.randomElement()
        }
        r()
    }
    
    private func makeScaleAnimation(factor: CGFloat) -> CAAnimation {
        let scale = CATransform3DMakeScale(factor, factor, 1)
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
        animation.duration = 0.3
        animation.fromValue = CATransform3DIdentity
        animation.toValue = scale
        
        return animation
    }
}

extension SpashScreenViewController {
    func route(navigationController: UINavigationController?) {
        navigationController?.pushViewController(self, animated: true)
    }
}
