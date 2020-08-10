//
//  AudioRecordingsList.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/3/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

struct AudioRecordingsList: View {
    
    @ObservedObject var audioRecorder: AudioRecorder
    
    var body: some View {
        List {
            ForEach(audioRecorder.recordings, id: \.createdAt) { recording in
                AudioRecordingRow(audioURL: recording.fileURL)
            }
                .onDelete(perform: delete)
        }
    }
    
    func delete(at offsets: IndexSet) {
        
        var urlsToDelete = [URL]()
        for index in offsets {
            urlsToDelete.append(audioRecorder.recordings[index].fileURL)
        }
        audioRecorder.deleteRecording(urlsToDelete: urlsToDelete)
    }
}

struct AudioRecordingsList_Previews: PreviewProvider {
    static var previews: some View {
        AudioRecordingsList(audioRecorder: AudioRecorder())
    }
}

struct AudioRecordingRow: View {
    
    var audioURL: URL
    var showFileName: Bool = false
    
    @ObservedObject var audioPlayer = AudioPlayer()
    
    var body: some View {
        HStack {
            if showFileName == true {
                Text("\(audioURL.lastPathComponent)")
                Spacer()
            }
            
            if audioPlayer.isPlaying == false {
                Button(action: {
                    self.audioPlayer.startPlayback(audio: self.audioURL)
                }) {
                    Image(systemName: "play.circle")
                        .imageScale(.large)
                }
            } else {
                Button(action: {
                    self.audioPlayer.stopPlayback()
                }) {
                    Image(systemName: "stop.fill")
                        .imageScale(.large)
                }
            }
        }
    }
    
}
