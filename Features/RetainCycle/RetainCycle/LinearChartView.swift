//
//  LinearChartView.swift
//  RetainCycle
//
//  Created by Pyretttt on 12.12.2021.
//

import FeatureIntermediate
import QuartzCore

final class LinearChartView: UIView {
	
	private enum Constants {
		static let maxXPoints: Int = 100
		static let largeOffset: CGFloat = NumericValues.large
		
		static let backgroundColor: UIColor = Pallete.Black.black3
		static let lineColor: UIColor = Pallete.Light.white1
	}
	
    private let formatter: Formatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.none
        formatter.roundingMode = NumberFormatter.RoundingMode.halfUp
        formatter.maximumFractionDigits = 1
        
        return formatter
    }()
    
	var coordinates: [OrdinatePoint] = []
    
	private lazy var abscissaEndFilter: ClosedRange<Int> = (coordinates.count - Constants.maxXPoints)...(coordinates.count - 1)
	private var abscissaBasis: CGFloat {
		axisInsetedFrame.width / CGFloat(Constants.maxXPoints)
	}
	
	private var axisInsetedFrame: CGRect {
		let insetedFrame = CGRect(x: 24,
								  y: 32,
								  width: bounds.width - 24,
								  height: bounds.height - 64)
		return insetedFrame
	}
	
	// MARK: - Current Scene state
    
    // Scrolling
	private lazy var currentAbscissaFilter: ClosedRange<Int> = abscissaEndFilter
	private var currentMinY: CGFloat = .nan
	private var currentMaxY: CGFloat = .nan
	private var currentAdjustedCoordinates: [OrdinatePoint] = []
	private var currentOrdinateBasis: CGFloat = 0
	private var currentAbscissaOffset: CGFloat = 0
    
    // Tracking
    private var isTrackingCurrently: Bool = false
    private var currentTrackingX: CGFloat = 0
    private var currentTrackingY: CGFloat = 0
	
	// MARK: - Visual elements
	
	private let graphShape: CAShapeLayer = {
		let layer = CAShapeLayer()
		layer.lineWidth = 1
		layer.strokeColor = Constants.lineColor.cgColor
		layer.fillColor = Pallete.Utility.transparent.cgColor

		return layer
	}()
	
	private let abscissaShape: CAShapeLayer = {
		let layer = CAShapeLayer()
		layer.lineWidth = 1
		layer.strokeColor = Constants.lineColor.cgColor
		layer.fillColor = Pallete.Utility.transparent.cgColor

		return layer
	}()
    
    private let verticalShapeLine: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 1
        layer.strokeColor = Constants.lineColor.cgColor
        layer.fillColor = Pallete.Utility.transparent.cgColor
        layer.isHidden = false

        return layer
    }()
    
    private let circleShape: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 1
        layer.strokeColor = Constants.lineColor.cgColor
        layer.fillColor = Constants.lineColor.cgColor
        layer.isHidden = false

        return layer
    }()
	
	private lazy var maxValueLabel = valueLabel
	private lazy var averageValueLabel = valueLabel
	private lazy var minValueLabel = valueLabel
    private lazy var currentValueLabel = { () -> UILabel in
        let view = valueLabel
        view.font = TextFont.base.withSize(16)
        
        return view
    }()
	private var valueLabel: UILabel {
		let view = UILabel()
		view.font = TextFont.base.withSize(8)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.textColor = Constants.lineColor
		view.textAlignment = .center
		view.backgroundColor = Constants.backgroundColor
		
		return view
	}
    
    // MARK: - Gestures
    
    private var scrollGesture = UIPanGestureRecognizer()
    private var observeTrackingGesture = UILongPressGestureRecognizer()
	
	// MARK: - Lifecycle
	
	init() {
		super.init(frame: .zero)
		setupUI()
		setupActions()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
        arrangeVisualElements()
	}
	
	// MARK: - Setup UI
	
	private func setupUI() {
		backgroundColor = Constants.backgroundColor
		layer.masksToBounds = true
		
        [abscissaShape, graphShape, verticalShapeLine, circleShape].forEach {
            layer.addSublayer($0)
        }
		
		[maxValueLabel, averageValueLabel, minValueLabel, currentValueLabel].forEach { addSubview($0) }
		NSLayoutConstraint.activate([
			maxValueLabel.topAnchor.constraint(equalTo: topAnchor, constant: 36),
			maxValueLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 32),
			maxValueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
			
			averageValueLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 32),
			averageValueLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
			averageValueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
			
			minValueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
			maxValueLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 32),
			minValueLabel.topAnchor.constraint(equalTo: bottomAnchor, constant: -36),
            
            currentValueLabel.topAnchor.constraint(equalTo: topAnchor),
            currentValueLabel.heightAnchor.constraint(equalToConstant: 24),
            currentValueLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
		])
	}
    
    private func arrangeVisualElements() {
        updateGraphInfo()
        arrangeAbscissaShape()
        arrangeGraphShape()
        updateLabels()
        
        arrangeVerticalShapeLine()
        arrangeCicleShape()
    }
	
	private func arrangeAbscissaShape() {
		abscissaShape.frame = bounds
		let path = UIBezierPath()
		path.move(to: .init(x: 0, y: bounds.height - 24))
		path.addLine(to: .init(x: bounds.width, y: bounds.height - 24))
		abscissaShape.path = path.cgPath
	}
    
    private func arrangeVerticalShapeLine() {
        if !isTrackingCurrently {
            verticalShapeLine.isHidden = true
            return
        }
        
        verticalShapeLine.isHidden = false
        verticalShapeLine.frame = axisInsetedFrame
        let path = UIBezierPath()
        path.move(to: .init(x: currentTrackingX, y: 0))
        path.addLine(to: .init(x: currentTrackingX, y: verticalShapeLine.frame.height))
        verticalShapeLine.path = path.cgPath
    }
    
    private func arrangeCicleShape() {
        if !isTrackingCurrently {
            circleShape.isHidden = true
            return
        }
        
        circleShape.isHidden = false
        circleShape.frame = axisInsetedFrame
        let frame = CGRect(x: currentTrackingX - 3, y: currentTrackingY - 3, width: 6, height: 6)
        let path = UIBezierPath(roundedRect: frame,
                                byRoundingCorners: .allCorners,
                                cornerRadii: CGSize(width: 3, height: 3))
        circleShape.path = path.cgPath
    }
	
	private func arrangeGraphShape() {
		graphShape.frame = axisInsetedFrame
		let path = UIBezierPath()
        for (idx, coordinate) in currentAdjustedCoordinates.enumerated() {
			let point = CGPoint(x: CGFloat(idx) * abscissaBasis,
                                y: axisInsetedFrame.height - coordinate.relativeY * currentOrdinateBasis)
//			print("\(point) with \(coordinate.relativeX) \(coordinate.relativeY)")
			if idx == 0 {
				path.move(to: point)
				continue
			}
			
			path.addLine(to: point)
		}
		graphShape.path = path.cgPath
	}
	
	private func updateLabels() {
		let labels = [maxValueLabel, averageValueLabel, minValueLabel]
		if currentMinY == .nan || currentMaxY == .nan {
			labels.forEach { $0.isHidden = true }
			return
		}
		
		let average = (currentMaxY + currentMinY) / 2
		maxValueLabel.text = formatter.string(for: currentMaxY)
		minValueLabel.text = formatter.string(for: currentMinY)
		averageValueLabel.text = formatter.string(for: average)
		
		labels.forEach { $0.isHidden = false }
	}

	// MARK: - Actions
	
	private func setupActions() {
        scrollGesture = UIPanGestureRecognizer(target: self, action: #selector(didScrollHorizontal(sender:)))
		scrollGesture.maximumNumberOfTouches = 1
        scrollGesture.delegate = self
        
        observeTrackingGesture = UILongPressGestureRecognizer(target: self, action: #selector(didStartObserveTracking(sender:)))
        observeTrackingGesture.minimumPressDuration = 0.35
        observeTrackingGesture.delegate = self
        observeTrackingGesture.delaysTouchesBegan = false
        
		let gestures = [scrollGesture, observeTrackingGesture]
		gestures.forEach { addGestureRecognizer($0) }
	}
	
	@objc
	private func didScrollHorizontal(sender: UIPanGestureRecognizer) {
        if isTrackingCurrently {
            handleTrackAction(sender: sender)
        } else {
            handleAbscissaScrollAction(sender: sender)
        }
	}
    
    private func handleAbscissaScrollAction(sender: UIPanGestureRecognizer) {
        let offsetX = sender.translation(in: self).x
        currentAbscissaOffset -= offsetX
        currentAbscissaOffset = min(0, currentAbscissaOffset)
        currentAbscissaOffset = max(currentAbscissaOffset, -abscissaBasis * CGFloat(coordinates.count - Constants.maxXPoints))
        
        let abscissaShift = Int(currentAbscissaOffset / abscissaBasis)
        currentAbscissaFilter = computeCurrentFilter(shiftFactor: abscissaShift)
        
        arrangeVisualElements()
        
        sender.setTranslation(.zero, in: self)
    }
    
    private func handleTrackAction(sender: UIPanGestureRecognizer) {
        isTrackingCurrently = true
        switch sender.state {
        case .changed, .began:
            // 24 point'a отступ у графика
            let offsetX = sender.location(in: self).x - 24
            
            var pointsFromStart = Int(offsetX / abscissaBasis)
            pointsFromStart = max(0, min(pointsFromStart, currentAdjustedCoordinates.count - 1))
            let point = currentAdjustedCoordinates[pointsFromStart]
            currentTrackingX = CGFloat(pointsFromStart) * abscissaBasis
            currentTrackingY = axisInsetedFrame.height - point.relativeY * currentOrdinateBasis
            
            currentValueLabel.text = formatter.string(for: point.absoluteY)
        default:
            isTrackingCurrently = false
            currentTrackingX = 0
            currentTrackingY = 0
            currentValueLabel.text = ""
        }
        
        arrangeVisualElements()
    }
    
    @objc
    private func didStartObserveTracking(sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            isTrackingCurrently = true
        default:
            isTrackingCurrently = false
        }
    }
	
	// MARK: - Data
	
	private func computeCurrentFilter(shiftFactor: Int) -> ClosedRange<Int> {
		var currentFilter = abscissaEndFilter.shifted(shiftFactor)
		if currentFilter.upperBound > abscissaEndFilter.upperBound {
			currentFilter = abscissaEndFilter
		} else if currentFilter.lowerBound < 0 {
			currentFilter = abscissaEndFilter.shifted(-abscissaEndFilter.lowerBound)
		}
		
		return currentFilter
	}
	
	func update(with coordinates: [OrdinatePoint]) {
        self.coordinates = coordinates
        arrangeVisualElements()
	}
	
	private func updateGraphInfo() {
        guard coordinates.count > currentAbscissaFilter.count else { return }
        
		var result = coordinates[currentAbscissaFilter]
		currentMinY = result
			.map { $0.absoluteY }
            .min() ?? .nan
		currentMaxY = result
			.map { $0.absoluteY }
            .max() ?? .nan
		
		for idx in result.indices {
			result[idx].relativeY = result[idx].absoluteY - currentMinY
		}
		currentAdjustedCoordinates = Array(result)
		
		currentOrdinateBasis = axisInsetedFrame.size.height / (currentMaxY - currentMinY)
	}
}

// MARK: - UIGestureRecognizerDelegate

extension LinearChartView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let gestures = [scrollGesture, observeTrackingGesture]
        if gestures.contains(gestureRecognizer) && gestures.contains(otherGestureRecognizer) {
            return true
        }

        return false
    }
}

extension LinearChartView {
    /// Модель для ординаты. Относительные величины опциональны
	struct OrdinatePoint {
        var absoluteY: CGFloat
		var relativeY: CGFloat = 0
	}
}
