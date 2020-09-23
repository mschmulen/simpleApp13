//
//  AuthenticatedUser.swift
//  FamilyKit
//
//  Created by Matthew Schmulen on 7/25/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import CloudKit

public protocol CKUserModel: Identifiable {
    
    // TODO fix the associatedtype type setup
    associatedtype ItemType
    
    static var recordName: String { get }
    static var ckSchemeKeys: [String] { get }
    
    init?(record: CKRecord)
    
}

//public struct CKUser: CKUserModel {
public final class CKUser: CKUserModel, ObservableObject {
    
    public static func == (lhs: CKUser, rhs: CKUser) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) { hasher.combine(id) }
    
    public typealias ItemType = CKUser
    public static let recordName = "User"
    public static let ckSchemeKeys = [
        "name",
        "birthDate",
        "emoji",
        "localeCurrentLanguageCode",
        "localeCurrentRegionCode",
        "localePreferredLanguages"
    ]
    
    public var id = UUID()
    public var recordID: CKRecord.ID?
    
    public var name: String?
    public var birthDate: Date?
    public var emoji: String?
    
    public var localeCurrentLanguageCode: String?
    public var localeCurrentRegionCode: String?
    public var localePreferredLanguages: [String]?
    
    public static var mock: CKUser {
        
        let model = CKUser()
        model.name = "mock user"
        model.emoji = "😄"
        model.birthDate = nil
        
        model.localeCurrentLanguageCode = "en"
        model.localeCurrentRegionCode = "US"
        model.localePreferredLanguages = nil
        
        return model
    }
    
    init(){
        self.name = nil
        self.birthDate = nil
        self.emoji = nil
        
        self.localeCurrentLanguageCode = nil
        self.localeCurrentRegionCode = nil
        self.localePreferredLanguages = nil
    }
    
    public init?(record: CKRecord) {
        
        self.recordID = record.recordID
        
        self.name = record["name"] as? String
        self.birthDate = record["birthDate"] as? Date
        self.emoji = record["emoji"] as? String
        
        self.localeCurrentLanguageCode = record["localeCurrentLanguageCode"] as? String
        self.localeCurrentRegionCode = record["localeCurrentRegionCode"] as? String
        self.localePreferredLanguages = record["localePreferredLanguages"] as? [String]
        
        // TODO Handle the kids reference
        //self.kids = record["kids"] as? [String]
        
    }
    
}
