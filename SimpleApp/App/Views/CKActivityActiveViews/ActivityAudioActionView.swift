//
//  ActivityAudioActionView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/9/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit
import SimpleGames
import DrawingKit
import AVFoundation

struct ActivityAudioActionView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var privateActiveChoreService: CKPrivateModelService<CKActivityModel>
    
    @State var devMessage: String? = nil
    
    @Binding var model: CKActivityModel
    
    var enableRecording: Bool
    
    @State var avAudioRecorder: AVAudioRecorder?
    
    @State var isRecording = false
    @State var isPlaying = false
    
    @State var audioRecording: AudioRecording?
    @State var audioFileNamePrefix: String?
        
    var body: some View {
        VStack {
            
            if devMessage != nil {
                Text("\(devMessage!)")
                    .foregroundColor(.red)
                    .onTapGesture {
                        self.devMessage = nil
                }
            }
            
            Text("RECORD")
            
            if audioRecording != nil {
                AudioRecordingRow(audioURL: audioRecording!.fileURL)
            }
            
            
            // Recording feature
            if enableRecording == true {
                if isRecording == false {
                    Button(action: {
                        self.startRecording(audioFileNamePrefix: UUID().uuidString)
                    }) {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipped()
                            .foregroundColor(.red)
                            .padding(.bottom, 40)
                    }
                } else {
                    Button(action: {
                        self.stopRecording()
                    }) {
                        Image(systemName: "stop.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipped()
                            .foregroundColor(.red)
                            .padding(.bottom, 40)
                    }
                }
            }
            
        }.onAppear {
            print( "check for the file name ")
            //self.audioFilename = "XXX"
            self.fetchRecording()
        }
    }
    
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
        //let audioFilename = documentPath.appendingPathComponent("\(Date().toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss")).m4a")
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
        fetchRecording()
        pushRecording()
    }
    
    func pushRecording() {
        guard let audioRecording = audioRecording else {
            return
        }
        privateActiveChoreService.uploadAudioAsset(
            model: model,
            audioRecording: audioRecording,
            assetPropertyName: "activityAsset"
        ) { (result) in
            switch result {
            case .failure(let error):
                print( "uploadAudioAsset error \(error)")
                self.devMessage = "failure"
            case .success(let record):
                self.devMessage = "upload success"
            }
        }
    }
    
    func fetchRecording() {
        
        // try and fetch from the server
        if let resultAssetAudio = model.activityAsset {
            if let resultAssetAudio_fileURL = resultAssetAudio.fileURL {
                print( "model.resultAssetAudio \(resultAssetAudio_fileURL)")
                
                audioRecording = AudioRecording(
                    fileURL: resultAssetAudio_fileURL,
                    createdAt: getCreationDate(for: resultAssetAudio_fileURL)
                )
            }
            
//                do {
//                    let imageData = try Data(contentsOf: resultAssetImage_fileURL)
//                    if let loadedUIImage = UIImage(data: imageData) {
//                        self.coverPhotoImage = Image(uiImage: loadedUIImage)
//                        return
//                    }
//                } catch {
//                    print("Error loading image : \(error)")
//                }
        }
        
        
        if let audioFileNamePrefix = audioFileNamePrefix {
            audioRecording = nil
            
            let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let audioFileURL = documentPath.appendingPathComponent("\(audioFileNamePrefix).m4a")
            let recording = AudioRecording(fileURL: audioFileURL, createdAt: getCreationDate(for: audioFileURL))
            audioRecording = recording
        }
        
        
        
        
        
        // recordings.removeAll()
//        let fileManager = FileManager.default
//        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        
//        for audio in directoryContents {
//            let recording = AudioRecording(fileURL: audio, createdAt: getCreationDate(for: audio))
//            recordings.append(recording)
//        }
//
//        recordings.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedAscending})
//
//        objectWillChange.send(self)
    }
    
    func getCreationDate(for file: URL) -> Date {
        if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
            let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
            return creationDate
        } else {
            return Date()
        }
    }
    
    func deleteRecording(urlsToDelete: [URL]) {
        
        for url in urlsToDelete {
            print(url)
            do {
               try FileManager.default.removeItem(at: url)
            } catch {
                print("File could not be deleted!")
            }
        }
        
        fetchRecording()
    }
}

    
//    var body: some View {
//        VStack {
//            Text("RECORD SOMETHING")
//
//            AudioRecordingsList(audioRecorder: audioRecorder)
//            if audioRecorder.recording == false {
//                Button(action: {
//                    self.audioRecorder.startRecording()
//                }) {
//                    Image(systemName: "circle.fill")
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 100, height: 100)
//                        .clipped()
//                        .foregroundColor(.red)
//                        .padding(.bottom, 40)
//                }
//            } else {
//                Button(action: {
//                    self.audioRecorder.stopRecording()
//                }) {
//                    Image(systemName: "stop.fill")
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 100, height: 100)
//                        .clipped()
//                        .foregroundColor(.red)
//                        .padding(.bottom, 40)
//                }
//            }
//        }
//    }
