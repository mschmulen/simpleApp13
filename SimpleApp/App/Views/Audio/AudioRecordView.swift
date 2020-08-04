//
//  AudioRecordView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/3/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

struct AudioRecordView: View {
    
    @ObservedObject var audioRecorder: AudioRecorder
    
    var body: some View {
        NavigationView {
            VStack {
                Text("ActionView")
                
                AudioRecordingsList(audioRecorder: audioRecorder)
                
                if audioRecorder.recording == false {
                    Button(action: {
                        self.audioRecorder.startRecording()
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
                        self.audioRecorder.stopRecording()
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
            }//end vstack
                .navigationBarTitle("Voice recorder")
        }//end nav
    }//end body
}

struct AudioRecordView_Previews: PreviewProvider {
    static var previews: some View {
        AudioRecordView(audioRecorder: AudioRecorder())
    }
}

