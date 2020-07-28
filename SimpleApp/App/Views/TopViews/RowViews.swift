//
//  ChoreRowView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/24/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct ChoreRowView: View {
    var categoryName: String
    var items: [ChoreModel]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(self.categoryName)
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(self.items) { model in
                        NavigationLink(
                            destination: ChoreDetailView(
                                model: model
                            )
                        ) {
                            ChoreItemView(model: model)
                        }
                    }
                }
            }
            .frame(height: 185)
        }
    }
}

struct ChoreItemView: View {
    var model: ChoreModel
    var body: some View {
        VStack(alignment: .leading) {
            model.image
                .renderingMode(.original)
                .resizable()
                .frame(width: 155, height: 155)
                .cornerRadius(5)
            Text("\(model.name) \(model.points)")
                .foregroundColor(.primary)
                .font(.caption)
        }
        .padding(.leading, 15)
    }
}

struct ConnectRowView: View {
    var categoryName: String
    var items: [ConnectModel]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(self.categoryName)
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(self.items) { model in
                        NavigationLink(
                            destination: ConnectDetailView(
                                model: model
                            )
                        ) {
                            ConnectItemView(model: model)
                        }
                    }
                }
            }
            .frame(height: 185)
        }
    }
}

struct ConnectItemView: View {
    var model: ConnectModel
    var body: some View {
        VStack(alignment: .leading) {
            model.image
                .renderingMode(.original)
                .resizable()
                .frame(width: 155, height: 155)
                .cornerRadius(5)
            Text("\(model.name) \(model.points)")
                .foregroundColor(.primary)
                .font(.caption)
        }
        .padding(.leading, 15)
    }
}




struct FunRowView: View {
    var categoryName: String
    var items: [FunModel]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(self.categoryName)
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(self.items) { model in
                        NavigationLink(
                            destination: FunDetailView(
                                model: model
                            )
                        ) {
                            FunItemView(model: model)
                        }
                    }
                }
            }
            .frame(height: 185)
        }
    }
}

struct FunItemView: View {
    var model: FunModel
    var body: some View {
        VStack(alignment: .leading) {
            model.image
                .renderingMode(.original)
                .resizable()
                .frame(width: 155, height: 155)
                .cornerRadius(5)
            Text("\(model.name) \(model.points)")
                .foregroundColor(.primary)
                .font(.caption)
        }
        .padding(.leading, 15)
    }
}
