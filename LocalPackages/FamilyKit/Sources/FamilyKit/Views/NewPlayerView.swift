//
//  NewPlayerView.swift
//  
//
//  Created by Matthew Schmulen on 8/2/20.
//

import SwiftUI

struct NewPlayerView: View {
    //@Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @Binding var showNewPlayer:Bool
    
    @State var errorMessage: String?
    
    @State var newPlayerName: String = ""
    @State var newPlayerEmoji: String = ""
    
    @State var selectedPlayerType: PlayerType = PlayerType.kid
    
    enum PlayerType: CaseIterable, Hashable, Identifiable {
        case adult
        case kid
        var name: String {
            return "\(self)".map {
                $0.isUppercase ? " \($0)" : "\($0)" }.joined().capitalized
        }
        var id: PlayerType {self}
    }
    
    @State private var stateBirthDate:Date = Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date()
    
    var starterDate: Date {
        switch selectedPlayerType {
        case .adult:
            return Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date()
        case .kid:
            return Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date()
        }
    }
    
    var body: some View {
        VStack {
            Text("New \(selectedPlayerType.name)")
            HStack {
                Spacer()
                Button(action: {
                    if self.newPlayerName.isEmpty {
                        self.errorMessage = "Player name cannot be empty"
                    } else {
                        
                        switch self.selectedPlayerType {
                        case .kid:
                            var newModel = CKPlayerModel()
                            newModel.isAdult = false
                            newModel.playerType = .kid
                            newModel.bucks = 0
                            newModel.dateOfBirth = self.stateBirthDate
                            newModel.name = self.newPlayerName
                            newModel.emoji = self.newPlayerEmoji
                            self.familyKitAppState.playerService.pushUpdateCreate(model: newModel) { (result) in
                                switch result {
                                case .failure(let error):
                                    print( "NewPlayerView failure \(error)")
                                    self.errorMessage = "failed to create"
                                case .success(_):
                                    self.showNewPlayer.toggle()
                                }
                            }
                        case .adult:
                            var newModel = CKPlayerModel()
                            newModel.isAdult = true
                            newModel.playerType = .adult
                            newModel.bucks = 0
                            newModel.dateOfBirth = self.stateBirthDate
                            newModel.name = self.newPlayerName
                            newModel.emoji = self.newPlayerEmoji
                            self.familyKitAppState.playerService.pushUpdateCreate(model: newModel) { (result) in
                                switch result {
                                case .failure(let error):
                                    print( "NewPlayerView failure \(error)")
                                    self.errorMessage = "failed to create"
                                case .success(_):
                                    self.showNewPlayer.toggle()
                                }
                            }
                        }
                    }
                }) {
                    Text("SAVE")
                }
                Spacer()
                Button(action: {
                    self.showNewPlayer.toggle()
                }) {
                    Text("Cancel")
                }
                Spacer()
            }//end HStack
            
            TextField("playerName", text: $newPlayerName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
            
            TextField("newPlayerEmoji", text: $newPlayerEmoji)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))

            Picker(selection: $selectedPlayerType, label: Text("Type")) {
                ForEach(PlayerType.allCases) { v in
                    Text(v.name).tag(v)
                }
            }.pickerStyle(SegmentedPickerStyle())
                .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
            
            VStack{
                Text("birthday")
                DatePicker(selection: $stateBirthDate, in: ...starterDate, displayedComponents: .date) {
                    Text("Select your birthday")
                }
                .labelsHidden()
            }
            .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3))
            .border(Color.gray)
            
        }//end VStack
    }
}

//struct NewPlayerView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewPlayerView(showNewPlayer: .constant(true))
//    }
//}
