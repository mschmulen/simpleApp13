//
//  AudioRecording.swift
//  
//
//  Created by Matthew Schmulen on 8/6/20.
//

import Foundation

public struct AudioRecording {
    public let fileURL: URL
    public let createdAt: Date
    
    public init( fileURL: URL, createdAt: Date) {
        self.fileURL = fileURL
        self.createdAt = createdAt
    }
}
