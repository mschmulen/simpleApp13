//
//  NewActivityDescriptionWizardView.swift
//  QFamilyApp14
//
//  Created by Matthew Schmulen on 10/6/20.
//

import SwiftUI
import Combine
import FamilyKit
import SimpleGames

struct NewActivityDescriptionWizardView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var activityDescriptionService: CKPrivateModelService<CKActivityDescriptionModel>
    
    @State var devMessage: String?
    
    @State var model: CKActivityDescriptionModel
    @State private var coverPhotoImage: UIImage?
    
    @State var showActivityIndicator: Bool = false
    @State var activityIndicatorMessage: String = "Saving"
    
    @State var nameString: String = ""
    @State var descriptionString: String = ""
    @State var emojiString: String = ""
    
    var body: some View {
        TabView {
            ActivityDescriptionWizardViewStart(model: $model)
            ActivityDescriptionWizardViewDescription(model: $model)
            ActivityDescriptionWizardViewEmoji(model: $model)
            ActivityDescriptionWizardViewModuleType(model: $model)
            ActivityDescriptionWizardViewCoverPhoto(model: $model)
            ActivityDescriptionWizardViewEnd(model: $model) {
                onSaveAndClose()
            }
        }
        .tabViewStyle(PageTabViewStyle())
        //.indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        //.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // dont show the paging dots
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
        }//end onAppear
    }//end body
    
   
    
    func onSaveAndClose() {
        self.showActivityIndicator = true
        activityDescriptionService.pushUpdateCreate(model: model) { (result) in
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

struct NewActivityDescriptionWizardView_Previews: PreviewProvider {
    static var previews: some View {
        NewActivityDescriptionWizardView(model: CKActivityDescriptionModel())
    }
}
