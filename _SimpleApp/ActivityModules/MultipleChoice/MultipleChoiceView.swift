//
//  MultipleChoiceView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 9/22/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct MultipleChoiceViewModel {
    
    let prompt: String
    let answer: MultipleChoiceViewModelAnswer
    let alternates: [MultipleChoiceViewModelAnswer]
    
    static var mock: MultipleChoiceViewModel {
        return MultipleChoiceViewModel(
            prompt: "pick the letter A",
            answer: MultipleChoiceViewModelAnswer.mockCorrect,
            alternates: [
                MultipleChoiceViewModelAnswer.mockFalse,
                MultipleChoiceViewModelAnswer.mockFalse,
                MultipleChoiceViewModelAnswer.mockFalse
            ]
        )
    }
    
    public struct MultipleChoiceViewModelAnswer:Identifiable  {
        
        let id: UUID = UUID()
        
        let answer: String
        let isCorrectAnswer: Bool
        
        static var mockCorrect: MultipleChoiceViewModelAnswer {
            return MultipleChoiceViewModelAnswer(answer:"A", isCorrectAnswer:true)
        }
        
        static var mockFalse: MultipleChoiceViewModelAnswer {
            return MultipleChoiceViewModelAnswer(answer:"B", isCorrectAnswer:false)
        }
    }
}

struct MultipleChoiceView: View {
    
    var viewModel: MultipleChoiceViewModel
    
    @State var items:[MultipleChoiceViewModel.MultipleChoiceViewModelAnswer] = [MultipleChoiceViewModel.MultipleChoiceViewModelAnswer]()
    
    @State var info:String = ""
    var body: some View {
        VStack{
            Text("\(info)")
            Text("\(viewModel.prompt)")
            List {
                ForEach( self.items ) { item in
                    Button(action: {
                       print( "did select")
                        if item.isCorrectAnswer == true {
                            self.info = "Correct!"
                        } else {
                            self.info = "Not Correct :("
                        }
                    }) {
                        Text("\(item.answer)")
                    }.padding()
                }
            }
        }.onAppear {
            self.items.append(self.viewModel.answer )
            for alt in self.viewModel.alternates {
                self.items.append(alt)
            }
            self.items.shuffle()
        }
    }
}
