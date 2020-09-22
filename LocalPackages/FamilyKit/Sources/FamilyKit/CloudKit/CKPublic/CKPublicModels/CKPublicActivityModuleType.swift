//
//  CKPublicActivityModuleType.swift
//  
//
//  Created by Matthew Schmulen on 9/22/20.
//

import Foundation
import SwiftUI
import CloudKit

// TODO: rename ActivityModuleType
public enum ActivityCategory: String, CaseIterable {
    case chore
    case fun
    case connect
    case none
}
