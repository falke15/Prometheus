//
//  CardsViewController.swift
//  Maya
//
//  Created by pyretttt pyretttt on 06.03.2022.
//

import UIKit

final class CardsViewController: UIViewController {
    
    // MARK: - Visual elements
    
    private lazy var cardsCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: TransformCollectionLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: CardCollectionViewCell.reuseID)
        view.delegate = self
        view.dataSource = self
        
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
        setupUI()
        view.backgroundColor = .systemBlue
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        view.addSubview(cardsCollectionView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cardsCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardsCollectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardsCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            cardsCollectionView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.9)
        ])
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension CardsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.reuseID,
                                                            for: indexPath) as? CardCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.updateInfo(title: "Maya",
                        description: "Awesome collection view to interact with",
                        image: UIImage(named: "transparent") ?? UIImage())
        
        return cell
    }
}
