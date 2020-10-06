//
//  AudioActivitySubView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/14/20.
//  Copyright © 2020 jumptack. All rights reserved.
//


import SwiftUI
import FamilyKit
import SimpleGames
import DrawingKit
import AVFoundation

struct AudioActivitySubView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    @EnvironmentObject var activityService: CKPrivateModelService<CKActivityModel>
    
    @State var devMessage: String? = nil
    
    @Binding var model: CKActivityModel
    @Binding var showActivityIndicator: Bool
    @Binding var activityIndicatorMessage:String
    
    @State var avAudioRecorder: AVAudioRecorder?
    
    @State var isRecording = false
    @State var isPlaying = false
    
    @State var audioRecording: AudioRecording?
    @State var audioFileNamePrefix: String?
    

    var audioView: some View {
        VStack {
            if audioRecording != nil {
                AudioRecordingPlayerView(audioURL: audioRecording!.fileURL)
            } else {
                Text("RECORD A MESSAGE ")
            }
            
            if familyKitAppState.isCurrentPlayerOwnerOrEmpty(model: model) {
                if isRecording == false {
                    Button(action: {
                        self.startRecording(audioFileNamePrefix: UUID().uuidString)
                    }) {
                        ZStack {
                            Image(systemName: "circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipped()
                                .foregroundColor(.red)
                                .padding(.bottom, 40)
                            Text("RECORD")
                                .foregroundColor(.white)
                        }
                    }
                } else {
                    Button(action: {
                        self.stopRecording()
                    }) {
                        ZStack {
                            Image(systemName: "stop.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipped()
                                .foregroundColor(.red)
                                .padding(.bottom, 40)
                            Text("STOP")
                                .foregroundColor(.white)
                        }
                    }
                }
            }//end if
            Text("~")
        }
    }
    
    var body: some View {
        VStack {
            
            DevMessageView(devMessage: $devMessage)
            
            audioView
            
//            if audioRecording != nil {
//                AudioRecordingPlayerView(audioURL: audioRecording!.fileURL)
//            } else {
//                Text("RECORD A MESSAGE ")
//            }
//
//            if familyKitAppState.isCurrentPlayerOwnerOrEmpty(model: model) {
//                if isRecording == false {
//                    Button(action: {
//                        self.startRecording(audioFileNamePrefix: UUID().uuidString)
//                    }) {
//                        ZStack {
//                            Image(systemName: "circle.fill")
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: 100, height: 100)
//                                .clipped()
//                                .foregroundColor(.red)
//                                .padding(.bottom, 40)
//                            Text("RECORD")
//                                .foregroundColor(.white)
//                        }
//                    }
//                } else {
//                    Button(action: {
//                        self.stopRecording()
//                    }) {
//                        ZStack {
//                            Image(systemName: "stop.fill")
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: 100, height: 100)
//                                .clipped()
//                                .foregroundColor(.red)
//                                .padding(.bottom, 40)
//                            Text("STOP")
//                                .foregroundColor(.white)
//                        }
//                    }
//                }
//            }//end if
//            Text("~")
        }//end VStack
        .onAppear {
            //self.loadLocalRecording()
            self.loadReacordingFromTheServer()
        }
    }//end body
    
    func startRecording( audioFileNamePrefix:String ) {
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            devMessage = "Failed to set up recording session"
        }
        self.audioFileNamePrefix = audioFileNamePrefix
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentPath.appendingPathComponent("\(audioFileNamePrefix).m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            avAudioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            avAudioRecorder?.record()
            isRecording = true
        } catch {
            devMessage = "Could not start recording"
        }
    }
    
    func stopRecording() {
        avAudioRecorder?.stop()
        isRecording = false
        loadLocalRecording()
        saveRecordingToServer()
    }
    
    func loadLocalRecording() {
        if let audioFileNamePrefix = audioFileNamePrefix {
            audioRecording = nil
            let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let audioFileURL = documentPath.appendingPathComponent("\(audioFileNamePrefix).m4a")
            let recording = AudioRecording(fileURL: audioFileURL, createdAt: getCreationDate(for: audioFileURL))
            audioRecording = recording
        }
    }
    
    func saveRecordingToServer() {
        
        guard let audioRecording = audioRecording else {
            return
        }
        
        // automatically push to status .completed
        //self.model.status = .completed
        
        showActivityIndicator = true
        activityIndicatorMessage = "Saving recording"
        
        self.activityService.uploadAudioAsset(
            model: model,
            audioRecording: audioRecording,
            assetPropertyName: "activityAsset"
        ) { (result) in
            switch result {
            case .failure( let error):
                DispatchQueue.main.async {
                    self.devMessage = "There was an error uploading \(error)"
                    //self.showActivityIndicator = false
                }
                self.showActivityIndicator = false
            case .success(let updatedModel):
                DispatchQueue.main.async {
                    //self.showActivityIndicator = false
                    if let resultActivityAsset = updatedModel.activityAsset {
                        self.model.activityAsset = resultActivityAsset
                    }
                    self.presentationMode.wrappedValue.dismiss()
                }
                self.showActivityIndicator = false
            }
        }
    }
    
    func loadReacordingFromTheServer() {
        
        guard let remoteRecodingActivityAsset = model.activityAsset else {
            return
        }
        
        activityIndicatorMessage = "Loading"
        self.showActivityIndicator = true
        if let resultAssetAudio_fileURL = remoteRecodingActivityAsset.fileURL {
            audioRecording = AudioRecording(
                fileURL: resultAssetAudio_fileURL,
                createdAt: getCreationDate(for: resultAssetAudio_fileURL)
            )
        }
        self.showActivityIndicator = false
    }
    
    func getCreationDate(for file: URL) -> Date {
        if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
            let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
            return creationDate
        } else {
            return Date()
        }
    }
}

struct AudioActivitySubView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AudioActivitySubView(
                model: .constant(CKActivityModel.mock),
                showActivityIndicator: .constant(false),
                activityIndicatorMessage: .constant("some update message")
            )
        }
    }
}
