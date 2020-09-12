//
//  CustomError.swift
//  
//
//  Created by Matthew Schmulen on 9/12/20.
//

import Foundation
import CloudKit

enum CustomError: Error {
    case unknown
    case cursorFailure
    
    case networkUnavailable
    
    case urlError401
    case urlError400
    
    static func make(domain:String, code:Int) -> CustomError {
        switch domain {
        case "CKErrorDomain":
            switch code {
            case 3: return .networkUnavailable
            default: return .unknown
            }
        case "NSURLErrorDomain":
            switch code {
            case 401: return .urlError401
            case 400: return .urlError400
            default: return .unknown
            }
        default:
            return .unknown
        }
    }
}
