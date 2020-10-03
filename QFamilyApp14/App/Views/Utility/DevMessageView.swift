//
//  DevMessageView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/13/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct DevMessageView: View {
    
    @Binding var devMessage: String?
    
    var showEnabled:Bool = true
    
    var body: some View {
        VStack {
            if showEnabled == true {
                if devMessage != nil {
                    Text("\(devMessage!)")
                        .foregroundColor(.red)
                        .onTapGesture {
                            self.devMessage = nil
                    }
                }
            }
            EmptyView()
        }
    }
}
