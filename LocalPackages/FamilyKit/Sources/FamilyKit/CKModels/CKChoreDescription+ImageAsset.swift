//
//  File.swift
//  
//
//  Created by Matthew Schmulen on 8/4/20.
//

import Foundation
import SwiftUI

// TODO: Image asset WIP
extension CKChoreDescriptionModel {
    
    /// loadCoverPhoto
    public func loadCoverPhoto(completion: @escaping (_ result: Result<UIImage, Error>) -> ()) {
        DispatchQueue.global(qos: .utility).async {
            
            var image: UIImage?
            
            defer {
                DispatchQueue.main.async {
                    if let image = image {
                        completion(.success(image))
                    } else {
                        completion(.failure(CustomError.unknown))
                    }
                    completion(.failure(CustomError.unknown))
                }
            }
            
            guard
                let coverPhoto = self.coverPhoto,
                let fileURL = coverPhoto.fileURL
                else {
                    return
            }
            let imageData: Data
            do {
                print("fileURL: \(fileURL)")
                imageData = try Data(contentsOf: fileURL)
            } catch let error {
                print( "error \(error)")
                return
            }
            image = UIImage(data: imageData)
        }
    }//end loadCoverPhoto
}

