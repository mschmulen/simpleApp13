//
//  NewRewardDefinitionWizardView.swift
//  QFamilyApp14
//
//  Created by Matthew Schmulen on 10/6/20.
//

import SwiftUI
import Combine
import FamilyKit
import SimpleGames

struct NewRewardDefinitionWizardView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var storeItemDefinitionService: CKPrivateModelService<CKBuckRewardDefinitionModel>
    @EnvironmentObject var storeItemPurchaseService: CKPrivateModelService<CKBuckRewardModel>
    
    @State var devMessage: String?
    
    @State var model: CKBuckRewardDefinitionModel
    @State private var coverPhotoImage: UIImage?
    
    @State var showActivityIndicator: Bool = false
    @State var activityIndicatorMessage: String = "Saving"
    
    @State var nameString: String = ""
    @State var descriptionString: String = ""
    @State var emojiString: String = ""
    
    var body: some View {
        TabView {
            RewardDefinitionWizardViewStart(model: $model)
            RewardDefinitionWizardViewInfo(model: $model)
            RewardDefinitionWizardViewEnd(model: $model) {
                onSaveAndClose()
            }
        }
        .tabViewStyle(PageTabViewStyle())
        //.indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        //.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // dont show the paging dots
        .onAppear {
            
        }//end onAppear
    }
    
    func onSaveAndClose() {
        self.showActivityIndicator = true
        storeItemDefinitionService.pushUpdateCreate(model: model) { (result) in
            switch result {
            case .failure(let error):
                self.devMessage = "save error\(error.localizedDescription)"
                self.showActivityIndicator = false
            case .success(_):
                self.showActivityIndicator = false
                DispatchQueue.main.async {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }        
    }//end onSaveAndClose
    
}

struct NewRewardDefinitionWizardView_Previews: PreviewProvider {
    static var previews: some View {
        NewRewardDefinitionWizardView(model: CKBuckRewardDefinitionModel())
    }
}
