//
//  CustomError.swift
//  
//
//  Created by Matthew Schmulen on 9/12/20.
//

import Foundation
import CloudKit

// TODO: Rename CKCustomError
enum CustomError: Error {
    
    case unknown
    
    case cursorFailure
    
    // CKErrorDomain
    case networkUnavailable
    
    // NSURLErrorDomain
    case urlError400
    case urlError401
    case urlError404
    
    static func make( error: NSError?) -> CustomError {
        guard let error = error else {
            return .unknown
        }
        return CustomError.make(
            domain: (error as NSError).domain,
            code: (error as NSError).code
        )
    }
    
    private static func make(domain: String, code: Int) -> CustomError {
        switch domain {
        case "CKErrorDomain":
            switch code {
            case 3: return .networkUnavailable
            // TODO: Extend error codes
            // case X: return .networkFailure
            // case X: return .quotaExceeded
            // case X: return .permissionFailure
            // case X: return .partialFailure
            // case X: return .notAuthenticated
            default: return .unknown
            }
        case "NSURLErrorDomain":
            switch code {
            case 400: return .urlError400
            case 401: return .urlError401
            case 404: return .urlError404
            // TODO: Extend error codes
            default: return .unknown
            }
        default:
            return .unknown
        }
    }// end make
}
