//
//  CKModel.swift
//  FamilyKit
//
//  Created by Matthew Schmulen on 7/25/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI
import CoreLocation
import CloudKit

public protocol CKModel: Identifiable {
    
    // TODO fix the associatedtype type setup
    associatedtype ItemType
    
    static var recordName: String { get }
    static var ckSchemeKeys: [String] { get }
    static var mock: ItemType { get }
    
    var id: UUID { get }
    var recordID: CKRecord.ID? { get }
    var ckRecord: CKRecord? { get }
    
    init?(record: CKRecord)
    
    var title: String? { get }
    
    //static func fromCKRecord(record: CKRecord)
    
}

