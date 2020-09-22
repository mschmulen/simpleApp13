//
//  CKSearch+Sort.swift
//  
//
//  Created by Matthew Schmulen on 9/22/20.
//

import SwiftUI
import Combine
import CloudKit

// TODO: Rename ModelServiceSearchPredicate
public enum SearchPredicate {
    
    case predicateTrue
    case customEqualsSearch( searchKey: String, searchValue: String)
    case customContainsSearch( searchKey: String, searchValue: String)
    
    var predicate: NSPredicate {
        switch self {
        case .predicateTrue:
            return NSPredicate(value: true)
        case .customEqualsSearch(let searchKey, let searchValue):
            return NSPredicate(format: "\(searchKey) == %@", searchValue)
        case .customContainsSearch(let searchKey, let searchValue):
            return NSPredicate(format: "\(searchKey) CONTAINS %@", searchValue)
        }
    }
}

// TODO: Rename ModelServiceSortDescriptor
public enum SortDescriptor {
    
    /// custom "modificationDate", "creationDate",
    /// note: ascending false for a date is most recent first
    case custom(key: String, ascending:Bool )
    case none
    
    var sortDescriptors: [NSSortDescriptor] {
        switch self {
        case .custom(let key, let ascending):
            return [NSSortDescriptor(key: key, ascending: ascending)]
        case .none:
            // TODO: Matt I think you hacked this for debug and you need to find out where and why so you can move it back to empty, but for now its fine
            return [NSSortDescriptor]()
            //                return [NSSortDescriptor(key: "modificationDate", ascending: false)]
        }
    }
}
