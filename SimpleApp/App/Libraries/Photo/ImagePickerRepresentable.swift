//
//  ImagePicker.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/4/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

// TODO: Rename ImagePicker to PhotoPicker
struct ImagePickerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    
    var imageSourceType: ImagePickerSourceType
    
    public enum ImagePickerSourceType {
        case camera
        case photoLibrary
        case savedPhotosAlbum
        
        var sourceType: UIImagePickerController.SourceType {
            switch self {
            case .camera:
                return UIImagePickerController.SourceType.camera
            case .photoLibrary:
                return UIImagePickerController.SourceType.photoLibrary
            case .savedPhotosAlbum:
                return UIImagePickerController.SourceType.savedPhotosAlbum
            }
        }
    }
}

extension ImagePickerRepresentable : UIViewControllerRepresentable {
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerRepresentable>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        picker.sourceType = imageSourceType.sourceType
        // picker.mediaTypes = ["public.image"]
        //picker.imageSourceType =
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

