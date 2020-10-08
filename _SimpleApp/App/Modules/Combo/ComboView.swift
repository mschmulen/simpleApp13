//
//  ComboView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 9/25/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct ComboView: View {
    
    var viewData:ViewData = ViewData.mock
    
    var body: some View {
        HStack {
            Text("COMBO VIEW")
        }
    }
    
    
    struct ViewData {
        
        static var mock:ViewData {
            return ViewData(
            )
        }
    }
}

