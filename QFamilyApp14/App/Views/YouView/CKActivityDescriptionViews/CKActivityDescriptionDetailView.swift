//
//  CKActivityDescriptionDetailView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/2/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import Combine
import FamilyKit
import SimpleGames

struct CKActivityDescriptionDetailView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var activityDescriptionService: CKPrivateModelService<CKActivityDescriptionModel>
    
    @State var devMessage: String?
    
     @State var model: CKActivityDescriptionModel
//    @ObservedObject var model: CKActivityDescriptionModel
    
    @State private var coverPhotoImage:UIImage?
    
    var body: some View {
        
// model.update()
        
        return VStack {
            DevMessageView(devMessage: $devMessage)
            Group {
                headerView
                
                Text(model.name ?? "~")
                    .modifier(PrimaryLargeBoldLabel(color: .black))
                    .padding()
                
                Text(model.description ?? "~")
                    .modifier(PrimaryLargeRegularLabel(color: .black))
                    .padding()
                
                HStack {
                    Text("\(model.bucks)")
                        .modifier(PrimaryLargeBoldLabel(color: .black))
                    Text("bucks !")
                        .modifier(PrimaryLargeRegularLabel(color: .black))
                }
            }
            
            Spacer()
            
            // START Button
            if familyKitAppState.currentPlayerModel?.recordReference == nil {
                 LargeTextPillBox( "NO USER" )
            } else {
                NavigationLink(destination: CKActivityActiveDetailView(
                    model: CKActivityModel(
                        descriptionModel: model,
                        playerRecordReference: familyKitAppState.currentPlayerModel!.recordReference!
                    ),
                    localActivityStatus: ActivityStatus.active
                )) {
                    LargeTextPillBox( "START THIS ACTIVITY" )
                }
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Text("\(model.moduleType.rawValue)")
                    .modifier(PrimaryLargeRegularLabel(color: .black))
                Spacer()
                Text("\(model.category.rawValue)")
                    .modifier(PrimaryLargeRegularLabel(color: .black))
                Spacer()
            }
            Spacer()
        }// end VStack
        .onAppear {
            // try and download the image
            if self.model.coverPhoto != nil {
                self.model.loadCoverPhoto { (result) in
                    switch result {
                    case .failure(_):
                        break
                    case .success(let image):
                        self.coverPhotoImage = image
                    }
                }
            }
        }//end .onAppear
    }//end body
    
    var headerView: some View {
        Group {
            if coverPhotoImage == nil {
                if model.emoji != nil {
                    Text(model.emoji!)
                } else {
                    Text("~")
                }
            } else {
                VStack {
                    Image(uiImage: coverPhotoImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                        .clipped()
                }
            }
        }
    }
    
    
}//end CKActivityDetailView

import CloudKit

struct CKChoreDetailView_Previews: PreviewProvider {
    
    static let container = CKContainer(identifier: CKContainerIdentifier)
    
    static var previews: some View {
        Group {
            CKActivityDescriptionDetailView(
                model: CKActivityDescriptionModel.mock
            )
                .environmentObject(AppState())
                .environmentObject((FamilyKitAppState(container: CloudKitContainer.MockContainer(container))))
                .environmentObject(CKPrivateModelService<CKActivityDescriptionModel>(container: CloudKitContainer.MockContainer(container)))
                .environmentObject(CKPrivateModelService<CKActivityModel>(container: CloudKitContainer.MockContainer(container)))
        }
    }
}
