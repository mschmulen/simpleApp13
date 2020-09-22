//
//  UIKitCloudKitSharingButton.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 9/18/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import CloudKit

class ObjectToShare: ObservableObject {
    //var parent: CKRecord
}

struct UIKitCloudKitSharingButton: UIViewRepresentable {
    typealias UIViewType = UIButton

    @ObservedObject
    var toShare: ObjectToShare
    
    @State
    var share: CKShare?
    
    var myContainer: CKContainer
    
    func makeUIView(context: UIViewRepresentableContext<UIKitCloudKitSharingButton>) -> UIButton {
        let button = UIButton()

        button.setImage(UIImage(systemName: "person.crop.circle.badge.plus"), for: .normal)
        button.addTarget(context.coordinator, action: #selector(context.coordinator.pressed(_:)), for: .touchUpInside)

        context.coordinator.button = button
        return button
    }

    func updateUIView(_ uiView: UIButton, context: UIViewRepresentableContext<UIKitCloudKitSharingButton>) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UICloudSharingControllerDelegate {
        var button: UIButton?

        func cloudSharingController(_ csc: UICloudSharingController, failedToSaveShareWithError error: Error) {
            //Handle some errors here.
        }

        func itemTitle(for csc: UICloudSharingController) -> String? {
            //return parent.toShare.name
            return "TODO parent.toShare.name"
        }

        var parent: UIKitCloudKitSharingButton
        
        init(_ parent: UIKitCloudKitSharingButton) {
            self.parent = parent
        }

        @objc func pressed(_ sender: UIButton) {
            
            print( "pressed todo !")
            
//            let sharingController = UICloudSharingController(share: share!, container: myContainer)
//
//            sharingController.delegate = self
//            sharingController.availablePermissions = [.allowReadWrite]
//            if let button = self.button {
//                sharingController.popoverPresentationController?.sourceView = button
//            }
//
//            UIApplication.shared.windows.first?.rootViewController?.present(sharingController, animated: true)
        }
    }
}
