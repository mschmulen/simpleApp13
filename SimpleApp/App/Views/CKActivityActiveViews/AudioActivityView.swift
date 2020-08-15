//
//  AudioActivityView.swift
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

struct ActivityAudioActionView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var privateActiveChoreService: CKPrivateModelService<CKActivityModel>
    
    @State var devMessage: String? = nil
    
    @Binding var model: CKActivityModel
    
    var isReadOnly: Bool
    
    @State var avAudioRecorder: AVAudioRecorder?
    
    @State var isRecording = false
    @State var isPlaying = false
    
    @State var audioRecording: AudioRecording?
    @State var audioFileNamePrefix: String?
    
    var body: some View {
        VStack {
            
            DevMessageView(devMessage: $devMessage)
            
            Text("RECORD")
            
            if audioRecording != nil {
                AudioRecordingPlayerView(audioURL: audioRecording!.fileURL)
            }
            
            
            // Recording feature
            if isReadOnly == false {
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
            self.loadRecording()
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
        loadRecording()
        saveRecording()
    }

    func loadRecording() {
        if let resultAssetAudio = model.activityAsset {
            if let resultAssetAudio_fileURL = resultAssetAudio.fileURL {
                audioRecording = AudioRecording(
                    fileURL: resultAssetAudio_fileURL,
                    createdAt: getCreationDate(for: resultAssetAudio_fileURL)
                )
            }
        }
        
        if let audioFileNamePrefix = audioFileNamePrefix {
            audioRecording = nil
            
            let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let audioFileURL = documentPath.appendingPathComponent("\(audioFileNamePrefix).m4a")
            let recording = AudioRecording(fileURL: audioFileURL, createdAt: getCreationDate(for: audioFileURL))
            audioRecording = recording
        }
    }
    
    func saveRecording() {
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
                self.devMessage = "upload failure"
            case .success(_):
                self.devMessage = "upload success"
            }
        }
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




struct AudioRecordingPlayerView: View {
    
    var audioURL: URL
    
    @ObservedObject var audioPlayer = AudioPlayer()
    
    var body: some View {
        HStack {
            if audioPlayer.isPlaying == false {
                Button(action: {
                    self.audioPlayer.startPlayback(audio: self.audioURL)
                }) {
                    Image(systemName: "play.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipped()
                        .padding(.bottom, 40)
                }
            } else {
                Button(action: {
                    self.audioPlayer.stopPlayback()
                }) {
                    Image(systemName: "stop.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipped()
                        .padding(.bottom, 40)
                }
            }
        }
    }
    
}

struct ActivityAudioActionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ActivityAudioActionView(
                model: .constant(CKActivityModel.mock),
                isReadOnly: true
            )
            ActivityAudioActionView(
                model: .constant(CKActivityModel.mock),
                isReadOnly: false
            )
        }
    }
}
