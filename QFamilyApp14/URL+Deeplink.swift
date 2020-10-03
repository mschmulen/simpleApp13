//
//  URL+Deeplink.swift
//  QFamilyApp14
//
//  Created by Matthew Schmulen on 10/3/20.
//

import Foundation

// reference https://www.donnywals.com/handling-deeplinks-in-ios-14-with-onopenurl/
extension URL {
    
    var isDeeplink: Bool {
        // qfamily-test://
        return scheme == "qfamily-test" // matches qfamily-test://<rest-of-the-url>
    }
    
    var topView: TopView? {
        guard isDeeplink else { return nil }
        
        switch host {
        case "main": // matches my-url-scheme://main/
            return .mainView
        case "onboarding": // matches my-url-scheme://onboarding/
            return .onboardingView
        case "purchase": // matches my-url-scheme://purchase/
            return .purchaseView
        case "modal": // matches my-url-scheme://modal/
            return .modalView
        default:
            return nil
        }
        
        //return .mainView
    }
    
    var mainViewTabIndex: TabViewIndex? {
        guard isDeeplink else { return nil }
        
        guard let topView = topView, pathComponents.count > 1  else {
            return nil
        }
        
        switch pathComponents[1] {
        case "family": // matches my-url-scheme://main/family
            return .family
        case "familychat": // matches my-url-scheme://familyChat/
            return .familyChat
        case "you": // matches my-url-scheme://you/
            return .you
        case "rewards": // matches my-url-scheme://rewards/
            return .rewards
        default:
            return nil
        }
    }

}
