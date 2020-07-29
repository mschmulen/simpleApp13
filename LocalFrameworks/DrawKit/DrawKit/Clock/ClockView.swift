//
//  ClockView.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct ClockView: View {
    
    let viewModel: ClockViewModel
    
    @State private var minutes: Int = 3
    @State private var seconds: Int = 0
    @State private var textColor = Color.blue
    @State private var backgroundColor = Color.white
    
    @State private var isPaused: Bool = false
    
    let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()
    
    @State private var currentDate = Date()
    
    init( viewModel:ClockViewModel ) {
        self.viewModel = viewModel
    }
    
    var resetButton: some View {
        return Button(action: {
            self.reset()
        }) {
            AppImage(icon: .reset)
        }
    }
    
    var pauseButton: some View {

        return Button(action: {
            if self.isPaused {
                self.resume()
            } else {
                self.pause()
            }
        }) {
            if isPaused {
                AppImage(icon: .pause)
//                Rectangle()
//                    .foregroundColor(.yellow)
//                    .frame(width: 50, height: 50)
            } else {
                AppImage(icon: .resume)
//                Circle()
//                    .foregroundColor(.green)
//                    .frame(width: 50, height: 50)
            }
        }
        //.background(self.textColor)
    }
    
    var timerColor: Color {
        
        if self.isPaused == true {
            return .gray
        }
        
        switch self.viewModel.clockType {
        case .stopWatch:
            return .black
        case .timer( _, let minutesWarning ):
            if self.seconds <= 0 {
                return .red
            }
            if self.minutes <= minutesWarning {
                return .yellow
            }
            if self.seconds <= 0 {
                if self.minutes <= 0 {
                    return .red
                }
            }
        }
        return .black
    }
    
    var timerButtonView: some View {
        Button(action: {
            self.isPaused.toggle()
        }) {
            Text("\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds)) ")
                .font(.headline)
                .foregroundColor(timerColor)
                .onReceive(timer) { input in
                    self.currentDate = input
                    if self.isPaused == true {
                        return
                    }
                    
                    switch self.viewModel.clockType {
                    case .stopWatch:
                        if self.seconds >= 59 {
                            self.minutes += 1
                            self.seconds = 0
                        } else {
                            self.seconds += 1
                        }
                    case .timer( _, _):
                        if self.seconds <= 0 {
                            if self.minutes <= 0 {
                                self.textColor = .red
                            } else {
                                self.seconds = 59
                                self.minutes -= 1
                            }
                        } else {
                            self.seconds -= 1
                        }
                    }
            }//end Text
            .accessibility(label: Text("Time \(String(format: "%02d", minutes)):\(String(format: "%02d", seconds)) "))
//            .onLongPressGesture {
//                    print( "long press")
//            }
        }//end Button
    }
    
//    var body: some View {
//        HStack(alignment: .center){
//            //VStack(alignment: .center) {
//                timerButtonView
//            //}
//            // pauseButton
//            //resetButton
//        }.onAppear {
//            self.reset()
//        }
//    }//end body
    
    var body: some View {
        HStack {
            timerButtonView
            if viewModel.showPauseButton {
                pauseButton
            }
            if viewModel.showRestartButton {
                resetButton
            }
        }.onAppear {
            self.reset()
        }
        
    }//end body
}

// MARK:  Clock features
extension ClockView {
    
    func pause() {
        textColor = .yellow
        isPaused = true
    }
    
    func resume() {
        textColor = .blue
        isPaused = false
    }
    
    func reset() {
        
        switch self.viewModel.clockType {
        case .stopWatch:
            minutes = 0
            seconds = 0
        case .timer( let countdownMinutes, let warningMinutes ):
            self.minutes = countdownMinutes
            seconds = 0
        }
        
        textColor = .blue
        isPaused = false
    }
}

struct ClockView_Previews: PreviewProvider {
    static var previews: some View {
        ClockView(viewModel: ClockViewModel.mock)
            .previewLayout(PreviewLayout.sizeThatFits)
            .padding()
    }
}
