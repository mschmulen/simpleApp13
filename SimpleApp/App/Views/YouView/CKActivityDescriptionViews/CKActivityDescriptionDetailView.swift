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
    @State private var coverPhotoImage:UIImage?
    
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
    
    
    var body: some View {
        VStack {
            DevMessageView(devMessage: $devMessage)
            Group {
                
                headerView
                
                Text(model.name ?? "~")
                    .font(.system(size: 27, weight: .bold, design: .rounded))
                    .padding()
                
                Text(model.description ?? "~")
                    .font(.system(size: 27, weight: .regular, design: .rounded))
                    .padding()
                
                HStack {
                    Text("\(model.bucks)")
                        .font(.system(size: 27, weight: .bold, design: .rounded))
                    Text("bucks")
                        .font(.system(size: 27, weight: .regular, design: .rounded))
                }
            }
            
            Spacer()
            
            // START Button
            if familyKitAppState.currentPlayerModel?.recordReference != nil {
                NavigationLink(destination: CKActivityActiveDetailView(
                    model: CKActivityModel(
                        descriptionModel: model,
                        playerRecordReference: familyKitAppState.currentPlayerModel!.recordReference!),
                    localActivityStatus: ActivityStatus.active
                )) {
                    
                    LargeTextPillBox( "START THIS ACTIVITY" )
                }
            }
            
            Spacer()
            
            Group {
                Text("\(model.moduleType.rawValue)")
                    .font(.system(size: 27, weight: .regular, design: .rounded))
                Text("\(model.category.rawValue)")
                    .font(.system(size: 27, weight: .regular, design: .rounded))
            }
            
            Spacer()
            
            // Lets move this to Nav bar
            NavigationLink(
                destination: CKActivityDescriptionDetailEditView(
                    model: model
                )
            ) {
                HStack {
                    Text("EDIT THIS ACTIVITY")
                }
                .foregroundColor(.blue)
            }
            Spacer()
        }
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
        }
    }//end body
    
}//end CKActivityDetailView

struct CKChoreDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CKActivityDescriptionDetailView(model: CKActivityDescriptionModel.mock)
            CKActivityDescriptionDetailView(model: CKActivityDescriptionModel.mock)
        }
    }
}
