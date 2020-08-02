//
//  CloudKitStatusView.swift
//  FamilyKit
//
//  Created by Matthew Schmulen on 7/30/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

public struct CloudKitStatusView: View {
    
    public var body: some View {
        VStack {
            Text("CloudKitStatusView")
            Text("CloudKit is not available please check something and fix it")
        }
    }
    
    public init() {
    }
}

struct CloudKitStatusView_Previews: PreviewProvider {
    static var previews: some View {
        CloudKitStatusView()
    }
}
