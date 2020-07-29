//
//  LayerDetailView.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct LayerDetailView: View {
    
    var model:Layer
    
    var body: some View {
        Form {
            Text("LAYER DETAIL")
            Section {
                Text("name: \(model.name)")
                Text("id: \(model.id)")
                    .font(.caption)
            }
            
            Section {
                Text("drawables: \(model.drawables.items.count)")
                List(model.drawables.items, id: \.id) { drawable in
                    NavigationLink(destination: DrawableDetailView(model:drawable)) {
                        VStack{
                            Text("\(drawable.id)")
                                .font(.caption)
                        }
                    }
                }
            }//end Section
            
        }
    }
}
