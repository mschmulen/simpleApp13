//
//  BoatRowView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/21/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct BoatRowView: View {
    
    var model: BoatModel
    
    var body: some View {
        VStack {
            Text(model.name)
        }
    }
}

struct BoatRowView_Previews: PreviewProvider {
    static var previews: some View {
        BoatRowView(model: BoatModel.mock)
    }
}
