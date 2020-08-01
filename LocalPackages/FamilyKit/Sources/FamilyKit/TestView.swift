//
//  File.swift
//  
//
//  Created by Matthew Schmulen on 7/31/20.
//

import SwiftUI

public let globalTestString = "MATTYY"

public struct TestView: View {
    public var body: some View {
        Text("TestView \(globalTestString)")
    }
    
    public init(){}
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
