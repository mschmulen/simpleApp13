//
//  ImagePicker.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/4/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct ImagePickerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    
    var imageSourceType:ImagePickerSourceType = .camera
    
    public enum ImagePickerSourceType {
        case camera
        case library
        
        var sourceType: UIImagePickerController.SourceType {
            switch self {
            case .camera:
                return UIImagePickerController.SourceType.camera
            case .library:
                return UIImagePickerController.SourceType.photoLibrary
            }
        }
    }
}

extension ImagePickerRepresentable : UIViewControllerRepresentable {
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerRepresentable>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = imageSourceType.sourceType
        return picker
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePickerRepresentable>) {

    }
}

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let parent: ImagePickerRepresentable
    
    init(_ parent: ImagePickerRepresentable) {
        self.parent = parent
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let uiImage = info[.originalImage] as? UIImage {
            parent.image = uiImage
        }

        parent.presentationMode.wrappedValue.dismiss()
    }
}

