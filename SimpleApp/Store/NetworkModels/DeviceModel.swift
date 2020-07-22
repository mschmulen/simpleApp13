//
//  DeviceModel.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/20/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI

/// Information about this device
struct DeviceModel {
    
    let idfv: UUID?
    let localeLanguageCode: String?
    let localeRegionCode: String?
    let localePreferredLanguages: [String]

    init() {
        
        self.idfv = UIDevice.current.identifierForVendor
        let locale = Locale.current
        self.localeLanguageCode = locale.languageCode
        self.localeRegionCode = locale.regionCode
        self.localePreferredLanguages = Locale.preferredLanguages

    }
    
}

