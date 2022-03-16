//
//  ProductFeatureModel.swift
//  Prometheus
//
//  Created by pyretttt pyretttt on 11.03.2022.
//

import FeatureIntermediate

struct ProductFeatureModel: CollectionCellModelType, Hashable {
    typealias Cell = PlainFeatureCellHorizontal
    
    let id = UUID()
    let name: String
    let description: String
    let image: UIImage
    let actionBlock: () -> Void
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ProductFeatureModel, rhs: ProductFeatureModel) -> Bool {
        lhs.id == rhs.id
    }
}

extension ProductFeatureModel {
    init(name: String,
         description: String,
         imageName: String,
         actionBlock: @escaping () -> Void) {
        self.name = name
        self.description = description
        self.image = ImageSource.init(rawValue: imageName)?.image ??
            UIImage.gradientImage(colors: UIImage.grayGradientColors)
        self.actionBlock = actionBlock
    }
}
