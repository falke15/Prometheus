//
//  DrawingView.swift
//  Record28
//
//  Created by pyretttt pyretttt on 15.03.2022.
//

import UIKit
import FeatureIntermediate

protocol DrawingViewDelegate: AnyObject {
    func drawingView(_ view: DrawingView, didEndDraw image: UIImage?)
}

final class DrawingView: UIView {
    
    private enum Constants {
        static let cornerRadius: CGFloat = 80
    }
    
    weak var delegate: DrawingViewDelegate?
    
    private let lineWidth: CGFloat = 12
    private let lineColor: CGColor = Pallete.Light.white1.cgColor
    
    private var lastLocus: CGPoint = .zero
    private var shouldReset: Bool = true
    
    private var currentContext: CGContext?
    
    private var timer: Timer?
    
    // MARK: - Lifecycle
    
    init(color: UIColor) {
        super.init(frame: .zero)
        backgroundColor = color
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        layer.cornerRadius = Constants.cornerRadius
    }
    
    // MARK: - UIResponder
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        resetTicIfScheduled()
        if shouldReset {
            shouldReset = false
            UIGraphicsBeginImageContext(frame.size)
        }
        currentContext = UIGraphicsGetCurrentContext()
        lastLocus = touch.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let first = touches.first else { return }
        draw(from: lastLocus, to: first.location(in: self))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        startTic()
    }
    
    // MARK: - Actions
    
    private func draw(from: CGPoint, to: CGPoint) {
        guard let context = currentContext else { return }
        context.setStrokeColor(lineColor)
        context.setLineWidth(lineWidth)
        context.setLineCap(.round)
        context.setBlendMode(.normal)
        
        context.move(to: from)
        context.addLine(to: to)
        context.strokePath()
        
        lastLocus = to
        
        layer.contents = UIGraphicsGetImageFromCurrentImageContext()?.cgImage
    }
    
    func startTic() {
        timer = Timer.scheduledTimer(withTimeInterval: 2,
                                     repeats: false,
                                     block: { [weak self] timer in
            guard let self = self else {
                return
            }
            
            self.shouldReset = true
            self.lastLocus = .zero
            self.currentContext = nil
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            let processedImage = self.getCroppedImage(of: image)
            self.delegate?.drawingView(self, didEndDraw: processedImage)
        })
    }
    
    func resetTicIfScheduled() {
        timer?.invalidate()
    }
    
    // MARK: - Image processing
    
    private func getCroppedImage(of image: UIImage?) -> UIImage? {
        guard let image = image, let cgImage = image.cgImage else { return nil }
        
        let croppedRect = calculateInscribedRect(roundedRect: CGRect(origin: .zero, size: image.size),
                                                 cornerRadius: Constants.cornerRadius)
        let croppedImage = cgImage.cropping(to: croppedRect)
        guard let croppedImage = croppedImage else { return nil }
        
        return UIImage(cgImage: croppedImage)
    }
    
    private func calculateInscribedRect(roundedRect: CGRect,
                                        cornerRadius: CGFloat) -> CGRect {
        let upperLeftCircleCenter = roundedRect.origin.applying(.init(translationX: cornerRadius,
                                                                      y: cornerRadius))
        // Дельта для X и Y координат равна при pi/4
        let deltaXYOverCircleCenter = cos(CGFloat.pi / 4) * cornerRadius
        let origin = upperLeftCircleCenter.applying(.init(translationX: -deltaXYOverCircleCenter,
                                                          y: -deltaXYOverCircleCenter))
        let deltaXYOverOrigin = origin.x - roundedRect.origin.x 
        let size = CGSize(width: roundedRect.size.width - 2 * deltaXYOverOrigin,
                          height: roundedRect.size.height - 2 * deltaXYOverOrigin)
        
        return CGRect(origin: origin, size: size)
    }
}
