//
//  ModalView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 9/10/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit
import CloudKit

struct ModalView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var activityDescriptionService: CKPrivateModelService<CKActivityDescriptionModel>
    @EnvironmentObject var activityService: CKPrivateModelService<CKActivityModel>
    
    @State var message: String = "?"
    
    @State var deepLinkRecordID:String = ""
    @State var recordType:String = ""
    
    @State var showActivityIndicator: Bool = false
    @State var activityIndicatorMessage: String = "Loading"
    
    var body: some View {
        
        VStack {
            Button(action: {
                self.appState.topView = TopView.mainView
            }) {
                Text("dismiss")
            }.onAppear {
                switch self.appState.activeDeepLink {
                case .modalViewRecord(let recordName, let recordType):
                    self.fetchGenericRecord(recordName: recordName, recordType:recordType)
                default:
                    self.showActivityIndicator = false
                    break
                }
                self.appState.activeDeepLink = .none
            }//end onAppear
            ActivityIndicatorView(
                isDisplayed: $showActivityIndicator,
                indicatorMessage: $activityIndicatorMessage
            ) {
                VStack {
                    Text("MODAL VIEW")
                    Spacer()
                    Text("\(self.message)")
                    Text("deepLinkRecordID: \(self.deepLinkRecordID)")
                    Text("recordType: \(self.recordType)")
                    Spacer()
                    Text("END")
                }//end VStack
            }
        }
    }//end body
    
    func fetchGenericRecord( recordName:String, recordType:String ) {
        
        let container = CKContainer(identifier: CKContainerIdentifier)
        self.showActivityIndicator = true
        switch recordType {
        case CKActivityModel.recordName:
            let genericService = CKPrivateModelService<CKActivityModel>(container: CloudKitContainer.CloudContainer(container))
            let ckRecordID = CKRecord.ID(recordName: recordName)
            let recordReference =  CKRecord.Reference(recordID: ckRecordID, action: .none)
            genericService.fetchByReference(modelReference: recordReference) { (result) in
                switch result {
                case .success(let model):
                    print( "found the model \(model)")
                    self.message = "SUCCESS \(model.name ?? "~") "
                case .failure(let error):
                    print( "errors")
                    self.message = "ERROR \(error)"
                }
                self.showActivityIndicator = false
            }
            
        case CKActivityDescriptionModel.recordName:
            let genericService = CKPrivateModelService<CKActivityDescriptionModel>(container: CloudKitContainer.CloudContainer(container))
            let ckRecordID = CKRecord.ID(recordName: recordName)
            let recordReference =  CKRecord.Reference(recordID: ckRecordID, action: .none)
            genericService.fetchByReference(modelReference: recordReference) { (result) in
                switch result {
                case .success(let model):
                    print( "found the model \(model)")
                    self.message = "SUCCESS \(model.name ?? "~")"
                case .failure(let error):
                    print( "errors")
                    self.message = "ERROR \(error)"
                }
                self.showActivityIndicator = false
            }
            
        default:
            print( "some thing bad")
            self.showActivityIndicator = false
            break
        }
    }
}
