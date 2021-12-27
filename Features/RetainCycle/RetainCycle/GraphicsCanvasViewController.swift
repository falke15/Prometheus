//
//  GraphicsCanvasViewController.swift
//  RetainCycle
//
//  Created by Pyretttt on 08.12.2021.
//

import FeatureIntermediate

final class GraphicsCanvasViewController: UIViewController {
	
	// MARK: - Visual elements
	
	private let linearGraphView: LinearChartView = {
		let view = LinearChartView()
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	// MARK: - Lifecycle
	
	init() {
		super.init(nibName: nil, bundle: nil)
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = Pallete.Light.white2
		setupUI()
        linearGraphView.update(with: LinearChartView.mock)
	}
	
	// MARK: - Setup UI
	
	private func setupUI() {
		let views = [linearGraphView]
		views.forEach { view.addSubview($0) }
		
		setupConstraints()
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			linearGraphView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
												 constant: NumericValues.default),
			linearGraphView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
													 constant: NumericValues.default),
			linearGraphView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
													  constant: -NumericValues.default),
			linearGraphView.heightAnchor.constraint(equalToConstant: 300)
		])
	}
	
}
