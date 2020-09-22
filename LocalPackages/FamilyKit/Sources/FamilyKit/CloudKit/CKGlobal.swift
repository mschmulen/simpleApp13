//
//  File.swift
//  
//
//  Created by Matthew Schmulen on 8/19/20.
//

import SwiftUI
import Combine
import CloudKit


public let CKContainerIdentifier = "iCloud.com.jumptack.FamilyKit"

public enum CloudKitContainer {
    case CloudContainer(_ container: CKContainer)
    case MockContainer(_ container: CKContainer)
}

