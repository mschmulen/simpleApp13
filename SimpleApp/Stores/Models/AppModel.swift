//
//  AppModel.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/20/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI

/// Information About this App
struct AppModel {
    
    let os: String = "ios"
    let appID: String
    let appShortVersion: String
    let appBuildVersion: String
    init() {
        self.appID = Bundle.main.bundleIdentifier ?? "~"
        self.appShortVersion =  (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? "~"
        self.appBuildVersion = (Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String) ?? "~"
    }
}

