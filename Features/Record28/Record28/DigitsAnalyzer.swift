//
//  DigitsAnalyzer.swift
//  Record28
//
//  Created by pyretttt pyretttt on 25.03.2022.
//

import Vision
import UIKit

struct DigitsAnalyzer {
    
    enum RecognitionError: Error {
        case unknown
        case recognitionError
        case invalidImage
    }
    
    private let model: VNCoreMLModel = {
        do {
            let coreMLModel = try DigitsMnist(configuration: MLModelConfiguration())
            let model = try VNCoreMLModel(for: coreMLModel.model)
            
            return model
        } catch {
            fatalError("ML model can't be created")
        }
    }()
    
    func predict(_ image: UIImage,
                 completion: @escaping (Result<(digit: String, confidence: Float), RecognitionError>) -> Void) {
        guard let image = image.cgImage else {
            completion(.failure(.invalidImage))
            return
        }
    
        let request = VNCoreMLRequest(model: model) { request, error in
            if error != nil {
                completion(.failure(.unknown))
            }
            
            let results = getResults(observations: request.results)
            switch results {
            case .success(let prediction):
                completion(.success(prediction))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        request.imageCropAndScaleOption = .scaleFill
        
        let handler = VNImageRequestHandler(cgImage: image)
        do {
            try handler.perform([request])
        } catch {
            assertionFailure("Failed to perform prediction")
        }
    }
    
    private func getResults(observations: [VNObservation]?) -> Result<(String, Float), RecognitionError> {
        guard let observations = observations as? [VNClassificationObservation],
                !observations.isEmpty else {
            return .failure(.recognitionError)
        }
        
        let bestPrediction = (observations[0].identifier, observations[0].confidence)
        
        return .success(bestPrediction)
    }
}
