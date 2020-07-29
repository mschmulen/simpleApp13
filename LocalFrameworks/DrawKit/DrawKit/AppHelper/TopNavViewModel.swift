//
//  TopNavViewModel.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI


struct TopNavViewModel: Codable {
    let clockViewModel: ClockViewModel
}

extension TopNavViewModel {
    
    static var defaultConfig:TopNavViewModel {
        
        return TopNavViewModel(
            clockViewModel: ClockViewModel.defaultConfig
        )
    }
        
}//end TopNavViewModel
