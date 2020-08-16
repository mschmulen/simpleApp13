//
//  FamilyActivityCardView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/13/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI
import FamilyKit

struct FamilyActivityCardView: View {
    
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    var model: CKActivityModel
    
    @State private var coverPhotoImage: Image?
    private let frameHeight: CGFloat = 200
    
    var body: some View {
        VStack {
            ZStack {
                GeometryReader { geo in
                    if self.coverPhotoImage != nil {
                        self.coverPhotoImage!
                            .resizable()
                            //.aspectRatio(contentMode: .fit)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width, height: geo.size.height)
                            .clipped()
                    } else {
                        Rectangle().fill(Color.blue)
                            .frame(width: geo.size.width, height: geo.size.height)
                    }
                    
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                if self.model.kidReference != nil {
                                    Text("\(self.familyKitAppState.findUserForRecord(recordReference: self.model.kidReference!)?.name ?? "~")")
                                        .font(.system(size: 22, weight: .bold, design: .rounded))
                                        .foregroundColor(Color(.white))
                                        .padding()
                                }
                                
                                Spacer()
                                VStack {
                                    Text("\(self.model.status.friendlyName)")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                        .foregroundColor(Color(.white))
                                    Text("\(self.model.moduleType.rawValue)")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                        .foregroundColor(Color(.white))
                                }
                            }
                            Spacer()
                            Text(self.model.title ?? "~")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundColor(Color(.white))
                                .padding()
                        }
                        Spacer()
                    } //end HStack
                } //end Geo
            } //end ZStack
        }//end VStack
            .frame(height: frameHeight)
            .onAppear {
                self.loadCoverPhotoImage()
        }// end onAppear
    }//end body
    
    func loadCoverPhotoImage() {
        
        if let resultAssetImage = self.model.resultAssetImage, let resultAssetImage_fileURL = resultAssetImage.fileURL {
            do {
                let imageData = try Data(contentsOf: resultAssetImage_fileURL)
                if let loadedUIImage = UIImage(data: imageData) {
                    self.coverPhotoImage = Image(uiImage: loadedUIImage)
                    return
                }
            } catch {
                print("Error loading resultAssetImage : \(error)")
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
                print("Error loading coverPhotoAsset : \(error)")
            }
        }
        
        //                        if let emoji = self.model.emoji {
        //                            self.coverPhotoImage =  Image(uiImage: emojiToImage(text: emoji))
        //                        } else {
        //                            return
        //                        }
        
    }
}

