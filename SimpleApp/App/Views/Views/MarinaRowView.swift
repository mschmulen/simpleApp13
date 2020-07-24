//
//  MarinaRowView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/21/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct MarinaRowView: View {
    
    var model: MarinaModel
    
    var body: some View {
        VStack {
            Text(model.name)
        }
    }
}

struct MarinaRowView_Previews: PreviewProvider {
    static var previews: some View {
        MarinaRowView(model: MarinaModel.mock)
    }
}
