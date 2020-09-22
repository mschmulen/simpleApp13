//
//  ShareInviteView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 9/22/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit

struct ShareInviteView: View {
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @State var name: String = ""
    @State var emailString: String = ""
    
    var objectToShare:ObjectToShare = ObjectToShare()
    var share: CKShare
    var rootRecord: CKRecord
    
    @State var isShowing: Bool = false
    
    var body: some View {
        VStack {
            Text("INVITE")
            
//            TextField("email", text: $emailString)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
            
//            Button(action: {
//                print( "invite")
//                self.familyKitAppState.shareService.sendInvite()
//            }) {
//                Text("SEND INVITE")
//            }
            
            Button(action: {
                self.isShowing = true
                //self.familyKitAppState.shareService.removeInvite()
            }) {
                Text("Show Cloud Sharing")
            }
            
            CloudSharingController(
                toShare: objectToShare,
                share: share,
                rootRecord: rootRecord,
                container: familyKitAppState.container,
                isShowing: $isShowing
            )
            
        }
    }
}

import CloudKit

/*
struct UIKitCloudKitSharingButton: UIViewRepresentable {
    typealias UIViewType = UIButton

    @ObservedObject
    var toShare: ObjectToShare
    @State
    var share: CKShare?

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
            return parent.toShare.name
        }

        var parent: UIKitCloudKitSharingButton

        init(_ parent: UIKitCloudKitSharingButton) {
            self.parent = parent
        }

        @objc func pressed(_ sender: UIButton) {
            //Pre-Create the CKShare record here, and assign to parent.share...

            let sharingController = UICloudSharingController(share: share, container: myContainer)

            sharingController.delegate = self
            sharingController.availablePermissions = [.allowReadWrite]
            if let button = self.button {
                sharingController.popoverPresentationController?.sourceView = button
            }

            UIApplication.shared.windows.first?.rootViewController?.present(sharingController, animated: true)
        }
    }
}

struct CloudSharingController: UIViewControllerRepresentable {
    @EnvironmentObject var store: CloudStore
    @Binding var isShowing: Bool

    func makeUIViewController(context: Context) -> CloudControllerHost {
        let host = CloudControllerHost()
        host.rootRecord = store.noteRecord
        host.container = store.container
        return host
    }

    func updateUIViewController(_ host: CloudControllerHost, context: Context) {
        if isShowing, host.isPresented == false {
            host.share()
        }
    }
}


final class CloudControllerHost: UIViewController {
    var rootRecord: CKRecord? = nil
    var container: CKContainer = .default()
    var isPresented = false

    func share() {
        let sharingController = shareController
        isPresented = true
        present(sharingController, animated: true, completion: nil)
    }

    lazy var shareController: UICloudSharingController = {
        let controller = UICloudSharingController { [weak self] controller, completion in
            guard let self = self else { return completion(nil, nil, CloudError.controllerInvalidated) }
            guard let record = self.rootRecord else { return completion(nil, nil, CloudError.missingNoteRecord) }

            let share = CKShare(rootRecord: record)
            let operation = CKModifyRecordsOperation(recordsToSave: [record, share], recordIDsToDelete: [])
            operation.modifyRecordsCompletionBlock = { saved, _, error in
                if let error = error {
                    return completion(nil, nil, error)
                }
                completion(share, self.container, nil)
            }
            self.container.privateCloudDatabase.add(operation)
        }
        controller.delegate = self
        controller.popoverPresentationController?.sourceView = self.view
        return controller
    }()
}
*/
