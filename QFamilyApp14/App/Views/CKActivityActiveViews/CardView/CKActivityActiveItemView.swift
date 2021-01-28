//
//  CKActivityActiveItemView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/2/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit
import CloudKit

struct CKActivityActiveItemView: View {
    
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    var model: CKActivityModel
    
    @State var coverPhotoImage: Image?
    
    let cardHeight: CGFloat = 200
    
    let showEmoji = false
    
    @State var chatMessageCount: Int = 0
    
    var chatBadgeCountView: some View {
        ZStack {
            Circle()
                .foregroundColor(.red)
            Text("\(chatMessageCount)")
                .foregroundColor(.white)
                .font(Font.system(size: 12))
        }
        .frame(width: 15, height: 15)
        .offset(x: (cardHeight/2) - 10, y: (cardHeight/2) - 10)
        // .offset(x: ( ( 2 * self.badgePosition) - 0.95 ) * ( geometry.size.width / ( 2 * self.tabsCount ) ) + 2, y: -25)
        .opacity(self.chatMessageCount == 0 ? 0 : 1.0)
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            ZStack {
                Rectangle()
                    .fill(SemanticAppColor.random)
                    .frame(height: cardHeight)
                    .frame(minWidth: cardHeight, maxWidth: .infinity, minHeight: cardHeight, maxHeight: cardHeight)
                    .cornerRadius(5)
                
                if coverPhotoImage != nil {
                    coverPhotoImage!
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFill()
                        .frame(height: cardHeight)
                        .frame(minWidth: cardHeight, maxWidth: .infinity, minHeight: cardHeight, maxHeight: cardHeight)
                        .cornerRadius(5)
                }
                
                VStack {
                    if model.kidReference != nil {
                        Text("\(familyKitAppState.findPlayerModelForRecord(recordReference: model.kidReference!)?.name ?? "~")")
                            .lineLimit(1)
                            .modifier(PrimarySmallBoldLabel(color: .white))
                            .padding()
                    }
                    Text(model.title ?? "~")
                        .lineLimit(3)
                        .modifier(PrimarySmallRegularLabel(color: .white))
                        .padding()
                }
                
                if showEmoji {
                    VStack {
                        HStack {
                            Spacer()
                            Text(model.moduleType.emoji)
                        }
                        Spacer()
                    }
                }
                
                chatBadgeCountView
                
            }//end ZStack
            
        }//end VStack
        .cornerRadius(5)
        .shadow(radius: 10)
        .padding()
        .onAppear {
            self.loadCoverImage()
            self.updateChatCount()
        }
    }
    
    func loadCoverImage() {
        
        if let resultAssetImage = self.model.resultAssetImage, let resultAssetImage_fileURL = resultAssetImage.fileURL {
            do {
                let imageData = try Data(contentsOf: resultAssetImage_fileURL)
                if let loadedUIImage = UIImage(data: imageData) {
                    self.coverPhotoImage = Image(uiImage: loadedUIImage)
                    return
                }
            } catch {
                print("Error loading image : \(error)")
                return
            }
        }
        
        if let coverPhotoAsset = self.model.coverPhoto, let coverPhotoAsset_fileURL = coverPhotoAsset.fileURL {
            do {
                let imageData = try Data(contentsOf: coverPhotoAsset_fileURL)
                if let loadedUIImage = UIImage(data: imageData) {
                    self.coverPhotoImage = Image(uiImage: loadedUIImage)
                    return
                }
            } catch {
                print("Error loading image : \(error)")
                return
            }
        }
        
        if let emoji = self.model.emoji {
            self.coverPhotoImage =  Image(uiImage: emojiToImage(text: emoji, size:60))
        }
    }
    
    @State private var chatService: ChatService = ChatService(container: CKContainer(identifier: CKContainerIdentifier))
    @State var chatSessionModel: CKChatSessionModel?
    
    func updateChatCount() {
        if let chatSession = model.chatSession {
            chatService.findOrMakeSession(model:model) { result in
                switch result {
                case .success(let sessionModel):
                    self.chatSessionModel = sessionModel
                    self.chatService.chatSessionModel = self.chatSessionModel
                    //self.chatService.onStartUp()
                    self.chatMessageCount = self.chatService.chatMessages.count
                    print( "self.chatMessageCount \(self.chatMessageCount)")
                case .failure(let error):
                    print( "error! \(error)")
                }
            }
        } else {
            self.chatMessageCount = 0
        }
    }
}//end struct

#if DEBUG
struct CKActivityActiveItemView_Previews: PreviewProvider {
    static var previews: some View {
        CKActivityActiveItemView( model: CKActivityModel.mock)
            .previewLayout(.fixed(width: 200, height: 200))
    }
}
#endif
