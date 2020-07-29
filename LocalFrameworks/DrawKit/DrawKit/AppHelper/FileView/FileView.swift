//
//  FileView.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import Combine

struct FileView : View {
    
    let fileService: FileService
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var drawPadService: DrawPadService
    
    @Binding var isShown: Bool
    
    @State var fileSaveName:String = "test"
    
    let defaultFileExtension = "json"
    
    var body: some View {
        Form{
            Text("FileView")
            Section() {
                Button(action: {
                    self.close()
                }) {
                    CloseButtonView()
                }
            }
            
            Section(header: Text("info")) {
                Text("File View")
                Text("available files \(fileService.allFilesInFolder().count)")
            }
            
            Section(header: Text("operations")) {
                TextField("save as", text: $fileSaveName)
                Button(action: {
                    let result = self.drawPadService.saveToFile(shortFileName: "\(self.fileSaveName).\(self.defaultFileExtension)")
                    switch result {
                    case .success:
                        self.close()
                    case .failure:
                        self.close()
                    }
                }) {
                    Text("Save as \"\(fileSaveName).\(defaultFileExtension)\" ")
                }
                Button(action: {
                    _ = self.fileService.removeAllFromFolder()
                }) {
                    Text("delete all \(fileService.allFilesInFolder().count) files")
                }
            }//end section info

            Section(header: Text("export")) {
                Button(action: {
                    let result = self.drawPadService.exportToFile(shortFileName: "yack.png")
//                    switch result {
//                    case .success:
//                        self.close()
//                    case .failure:
//                        self.close()
//                    }
                }) {
                    Text("WIP Export to a flat image file")
                }
                
                Button(action: {
                    let result = self.drawPadService.exportToClipBoard()
//                    switch result {
//                    case .success:
//                        self.close()
//                    case .failure:
//                        self.close()
//                    }
                }) {
                    Text("WIP Copy Image to clipboard")
                }
            }//end section export
            
            Section(header: Text("files")) {
                ForEach(fileService.allFilesInFolder(), id: \.self) { fileName in
                    //Text(location).tag(location)
                    Button(action: {
                        let result = self.drawPadService.loadFromFile(shortFileName: fileName)
                        switch result {
                        case .success:
                            self.close()
                        case .failure:
                            self.close()
                        }
                    }) {
                        Text(fileName)
                    }
                }
            }
        }
        //.navigationBarHidden(false)
        //        .navigationBarTitle("File Service")
    }//end body
    
    func close() {
        self.presentationMode.wrappedValue.dismiss()
        self.isShown = false
    }
    
}//end FileView


//final class FileViewStoreContainer: ObservableObject {
//
//    public let objectWillChange = PassthroughSubject<Void,Never>()
//
//    func someFileOp() {
//        //defer {
//        //DispatchQueue.main.async {
//            objectWillChange.send()
//        //}
//        //}
//    }
//
//}


