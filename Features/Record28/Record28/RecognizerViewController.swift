//
//  RecognizerViewController.swift
//  Record28
//
//  Created by pyretttt pyretttt on 14.03.2022.
//

import UIKit
import FeatureIntermediate

final class RecognizerViewController: UIViewController {
    
    private enum Constants {
        static let xxLargeSpacing: CGFloat = NumericValues.xxLarge
        static let largeSpacing: CGFloat = NumericValues.xLarge
        
        static let drawnImageSize: CGFloat = 96
    }
    
    // MARK: - Visual elements
    
    private lazy var canvasView: DrawingView = {
        let view = DrawingView(color: Pallete.Light.white2)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        
        return view
    }()
    
    private var animationLayer: CALayer {
        let layer = CALayer()
        layer.cornerRadius = Constants.largeSpacing
        layer.masksToBounds = true
        layer.backgroundColor = Pallete.Gray.gray1.cgColor
        layer.frame = CGRect(origin: .zero,
                             size: CGSize(width: Constants.drawnImageSize, height: Constants.drawnImageSize))
        layer.position = canvasView.center
        layer.opacity = 0

        return layer
    }
    
    private lazy var drawnImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = Constants.largeSpacing
        view.clipsToBounds = true
        
        return view
    }()
    
    // MARK: - Lifecycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("Deelted")
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Pallete.Black.black3
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = Pallete.Utility.transparent
        appearance.titleTextAttributes = [.foregroundColor: Pallete.Light.white1]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = Pallete.Light.white1
        navigationItem.title = "Recognize"
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        let views = [canvasView, drawnImageView]
        views.forEach { view.addSubview($0) }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            canvasView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            canvasView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -Constants.xxLargeSpacing),
            canvasView.heightAnchor.constraint(equalTo: canvasView.widthAnchor),
            canvasView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: Constants.xxLargeSpacing),
            
            drawnImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            drawnImageView.widthAnchor.constraint(equalToConstant: Constants.drawnImageSize),
            drawnImageView.heightAnchor.constraint(equalTo: drawnImageView.widthAnchor),
            drawnImageView.topAnchor.constraint(equalTo: canvasView.bottomAnchor,
                                                 constant: Constants.largeSpacing)
        ])
    }
}

extension RecognizerViewController: DrawingViewDelegate {
    func drawingView(_ view: DrawingView, didEndDraw image: UIImage?) {
        snapshotAppearingAnimation(with: image, completion: nil)
    }
    
    private func snapshotAppearingAnimation(with image: UIImage?,
                                            completion: (() -> Void)?) {
        guard let image = image, let cgImage = image.cgImage else { return }
        
        // Preparation
        drawnImageView.image = nil
        let snapshotLayer = animationLayer
        let imageLayer = animationLayer
        imageLayer.contents = cgImage
        let scaleXY = canvasView.frame.size.width / Constants.drawnImageSize + 0.15
        [snapshotLayer, imageLayer].forEach {
            $0.transform = CATransform3DMakeScale(scaleXY, scaleXY, 1)
            view.layer.addSublayer($0)
        }
        
        // Animations
        var elapsedTime: TimeInterval = .zero
    
        let flashAnimationDuration = 0.3
        let flashAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        flashAnimation.duration = flashAnimationDuration
        flashAnimation.toValue = 1
        flashAnimation.beginTime = CACurrentMediaTime()
        
        elapsedTime += flashAnimationDuration
                
        let blockAnimationDuration = 0.7
        let transformAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
        transformAnimation.duration = blockAnimationDuration
        transformAnimation.toValue = CATransform3DIdentity
        transformAnimation.isRemovedOnCompletion = false
        transformAnimation.fillMode = .forwards
        transformAnimation.beginTime = CACurrentMediaTime() + elapsedTime
        
        let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacityAnimation.duration = blockAnimationDuration / 2
        opacityAnimation.toValue = 1
        opacityAnimation.isRemovedOnCompletion = false
        opacityAnimation.fillMode = .forwards
        opacityAnimation.beginTime = CACurrentMediaTime() + elapsedTime

        let positionAnimation = CASpringAnimation(keyPath: #keyPath(CALayer.position))
        positionAnimation.delegate = AnimationDelegate { [weak self] in
            guard let self = self else { return }
            [imageLayer, snapshotLayer].forEach { $0.removeFromSuperlayer() }
            self.drawnImageView.image = image
            completion?()
        }
        positionAnimation.damping = 9.5
        positionAnimation.mass = 0.75
        positionAnimation.stiffness = 50.0
        positionAnimation.duration = positionAnimation.settlingDuration
        positionAnimation.toValue = drawnImageView.center
        positionAnimation.beginTime = CACurrentMediaTime() + elapsedTime
        positionAnimation.isRemovedOnCompletion = false
        opacityAnimation.fillMode = .forwards
        
        snapshotLayer.add(flashAnimation, forKey: nil)
        [transformAnimation, opacityAnimation, positionAnimation].forEach {
            imageLayer.add($0, forKey: nil)
        }
    }
}

extension RecognizerViewController {
    
    /// Простой делегат для анимаций с возможность прокинуть колбек
    class AnimationDelegate: NSObject, CAAnimationDelegate {
        
        private let completion: () -> Void
        
        init(completion: @escaping () -> Void) {
            self.completion = completion
        }
        
        // MARK: - CAAnimationDelegate
        
        func animationDidStop(_ anim: CAAnimation,
                              finished flag: Bool) {
            if flag { completion() }
        }
    }
}
