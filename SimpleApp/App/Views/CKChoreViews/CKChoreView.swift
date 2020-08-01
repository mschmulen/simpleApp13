//
//  CKChoreView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/1/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit


struct CKChoreRowView: View {
    var categoryName: String
    var items: [CKChoreModel]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(self.categoryName)
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    
                    NavigationLink(
                        destination: CKChoreDetailView(
                            model: CKChoreModel()
                        )
                    ) {
                        CKChoreAddItemView()
                    }
                    
                    ForEach(self.items) { model in
                        NavigationLink(
                            destination: CKChoreDetailView(
                                model: model
                            )
                        ) {
                            CKChoreItemView(model: model)
                        }
                    }
                }
            }
            .frame(height: 185)
        }
    }
}

struct CKChoreAddItemView: View {
    
    var image: Image {
        Image(systemName:"plus")
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            image
                .renderingMode(.original)
                .resizable()
                .frame(width: 155, height: 155)
                .cornerRadius(5)
            Text("NEW Private Chore")
                .foregroundColor(.primary)
                .font(.caption)
        }
        .padding(.leading, 15)
    }
}

struct CKChoreItemView: View {
    var model: CKChoreModel
    
    var image: Image {
        //if let emoji = model.emoji, let uiImage = emoji.image() {
            // return Image(uiImage: uiImage)
        if let emoji = model.emoji {
            return Image(uiImage: emojiToImage(text: emoji))
        } else {
            return ImageStore.shared.image(name: "turtlerock")
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            image
                .renderingMode(.original)
                .resizable()
                .frame(width: 155, height: 155)
                .cornerRadius(5)
            Text(model.name ?? "~")
                .foregroundColor(.primary)
                .font(.caption)
        }
        .padding(.leading, 15)
    }
}

struct CKChoreDetailView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var choreService: CKPublicModelService<CKChoreModel>
    @EnvironmentObject var connectService: CKPublicModelService<CKConnectModel>
    @EnvironmentObject var funService: CKPublicModelService<CKFunModel>
    
    @State var devMessage: String?
    
    @State var model: CKChoreModel
    
    var body: some View {
        List{
            if devMessage != nil {
                Text("\(devMessage!)")
                    .foregroundColor(.red)
                    .onTapGesture {
                        self.devMessage = nil
                }
            }
            
            Button(action:onSave) {
                HStack {
                    Text("Save")
                    Image(systemName: "square.and.arrow.up")
                }
            }
            
            Section(header: Text("Data")) {
                Text("title \(model.title ?? "~")")
                
                TextField("name", text: $model.name ?? "")
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("emoji", text: $model.emoji ?? "")
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("description", text: $model.description ?? "")
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("bucks", value: $model.bucks ?? 2, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("who", text: $model.who ?? "")
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("frequency", text: $model.frequency ?? "")
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("timeofday", text: $model.timeofday ?? "")
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("imageName", text: $model.imageName ?? "")
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
    }
    
    //    private var leadingButton: some View {
    //        HStack {
    //            if self.familyKitAppState.userService.currentUser == nil {
    //                Button(action:onTrailing) { Image(systemName: "person.circle") }
    //            } else {
    //                Text("\(self.familyKitAppState.userService.currentUser!.appleIDProvider_credential_user_givenName ?? "??")")
    //                Button(action:onTrailing) { Image(systemName: "person.circle.fill") }
    //            }
    //        }
    //    }
    //
    //    private var trailingButton: some View {
    //        Button(action:onSave) { Image(systemName: "square.and.arrow.up") }
    //    }
    
    func onSave() {
        choreService.pushUpdateCreate(model: model) { (result) in
            switch result {
            case .failure(let error):
                self.devMessage = "save error\(error.localizedDescription)"
            case .success(let record):
                print( "success \(record)")
                DispatchQueue.main.async {
                    self.presentationMode.wrappedValue.dismiss()
                    self.choreService.fetch { (result) in
                        print( "result")
                    }
                }
            }
        }
        //        }//end switch
    }
    
    func onTrailing() {
        print( "onTrailing")
    }
    
}

import UIKit
extension String {
    func image(size: CGSize = CGSize(width: 300, height: 300) ) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 100)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

func emojiToImage(text: String, size: CGFloat = 300) -> UIImage {
    
    let outputImageSize = CGSize.init(width: size, height: size)
    let baseSize = text.boundingRect(with: CGSize(width: 2048, height: 2048),
                                     options: .usesLineFragmentOrigin,
                                     attributes: [.font: UIFont.systemFont(ofSize: size / 2)], context: nil).size
    let fontSize = outputImageSize.width / max(baseSize.width, baseSize.height) * (outputImageSize.width / 2)
    let font = UIFont.systemFont(ofSize: fontSize)
    let textSize = text.boundingRect(with: CGSize(width: outputImageSize.width, height: outputImageSize.height),
                                     options: .usesLineFragmentOrigin,
                                     attributes: [.font: font], context: nil).size

    let style = NSMutableParagraphStyle()
    style.alignment = NSTextAlignment.center
    style.lineBreakMode = NSLineBreakMode.byClipping

    let attr : [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font : font,
        NSAttributedString.Key.paragraphStyle: style,
        NSAttributedString.Key.backgroundColor: UIColor.clear
    ]
    
    UIGraphicsBeginImageContextWithOptions(outputImageSize, false, 0)
    text.draw(in: CGRect(x: (size - textSize.width) / 2,
                         y: (size - textSize.height) / 2,
                         width: textSize.width,
                         height: textSize.height),
                         withAttributes: attr)
    let image = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
}
