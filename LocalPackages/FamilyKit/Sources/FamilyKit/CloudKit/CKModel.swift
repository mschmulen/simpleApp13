//
//  File.swift
//  
//
//  Created by Matthew Schmulen on 7/31/20.
//

import Foundation
import SwiftUI
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
    // func reload( service: CKPrivateModelService<CKModel> )
}
