//
//  OnboardingView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 9/24/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import CloudKit
import FamilyKit

public struct OnboardingView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var familyKitAppState: FamilyKitAppState
    
    @EnvironmentObject var activityDescriptionService: CKPrivateModelService<CKActivityDescriptionModel>
    @EnvironmentObject var activityService: CKPrivateModelService<CKActivityModel>
    
    @State var errorMessage: String?
    @State var networkStateViewModel: NetworkStateViewModel = NetworkStateViewModel()
    @State var cloudKitStateViewModel: CloudKitStateViewModel = CloudKitStateViewModel()
    
    @State private var currentPage = 0
    private var pageCount = 3
    public var body: some View {
        VStack  {
//            HStack {
//                Spacer()
//                Button(action: {
//                    self.close()
//                }) {
//                    Text("START")
//                }
//                .padding()
//            }
            PagerView(pageCount: pageCount, currentIndex: $currentPage) {
                
                OnboardingWelcomeView {
                    self.nextPage()
                }
                OnboardingInfoView {
                    self.nextPage()
                }
                OnboardingGetStartedView() {
                    self.close()
                }
                //Color.blue
                //Color.red
                //Color.green
            }
        }
    }
    
    func nextPage() {
        if currentPage < pageCount {
            self.currentPage += 1
        }
    }
    
    func close() {
        self.appState.topView = TopView.mainView
    }
    
    
    // NavigationView {
    //            VStack {
    //                if errorMessage != nil {
    //                    Text(errorMessage!)
    //                        .foregroundColor(.red)
    //                }
    //                if familyKitAppState.isSimulator == true {
    //                    Text("SIMULATOR: SOME FEATURES NOT SUPPORTED")
    //                        .font(.caption)
    //                        .foregroundColor(.red)
    //                }
    //
    //                Text("OnboardingView")
    //                Text("Welcome to QFamly")
    //                Text("TODO Ask some questions show some things")
    //
    //            }//end VStack
    //                .onAppear(perform: {
    //                })
    //}//end Navigation
}

struct OnboardingWelcomeView: View {
    
    var nextCallback: ()->Void
    var backgroundColor = SemanticAppColor.random
    
    var body: some View {
        ZStack {
            backgroundColor
            VStack {
                Text("Welcome to Family App").padding()
                Text("Lets get started").padding()
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        self.nextCallback()
                    }) {
                        Text("NEXT ->")
                    }.padding()
                }
            }.foregroundColor(.white)
        }
    }
}

struct OnboardingInfoView: View {
    
    var nextCallback: ()->Void
    var backgroundColor = SemanticAppColor.random
    
    var body: some View {
        ZStack {
            backgroundColor
            VStack {
                Text("Some info Family").padding()
                Text("Some info Family").padding()
                Text("Some info Family").padding()
                Text("Some info Family").padding()
                Spacer()
                
                HStack {
                    Spacer()
                    Button(action: {
                        self.nextCallback()
                    }) {
                        Text("NEXT ->")
                    }.padding()
                }
            }.foregroundColor(.white)
        }
    }
}

struct OnboardingGetStartedView: View {
    
    var nextCallback: ()->Void
    
    var backgroundColor = SemanticAppColor.random
    
    var body: some View {
        ZStack {
            backgroundColor
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        self.nextCallback()
                    }) {
                        Text("CLOSE !")
                    }.padding()
                }
                Text("Get Started").padding()
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        self.nextCallback()
                    }) {
                        Text("DONE !")
                    }.padding()
                }
            }.foregroundColor(.white)
        }
    }
}

