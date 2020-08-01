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
    //static var ckSchemeKeys: [String] { get }
    
    init?(record: CKRecord)
    
}

public struct CKUser: CKUserModel {
    
    public typealias ItemType = CKUser
    public static let recordName = "User"
    
    public var id = UUID()
    public var recordID: CKRecord.ID?
    
    public var appleIDProvider_credential_user_email: String?
    public var appleIDProvider_credential_user_familyName: String?
    public var appleIDProvider_credential_user_givenName: String?
    public var appleIDProvider_credential_user_identifier: String?
    
    public var localeCurrentLanguageCode: String?
    public var localeCurrentRegionCode: String?
    public var localePreferredLanguages: [String]?
    
    public var birthDate: Date?
    public var emoji: String?
    
    static var mock: CKUser {
        
        var model = CKUser()
        
        model.localeCurrentLanguageCode = "en"
        model.localeCurrentRegionCode = "US"
        model.localePreferredLanguages = nil
        
        return model
    }
    
    init(){
        self.appleIDProvider_credential_user_email = nil
        self.appleIDProvider_credential_user_familyName = nil
        self.appleIDProvider_credential_user_givenName = nil
        self.appleIDProvider_credential_user_identifier = nil

        self.localeCurrentLanguageCode = nil
        self.localeCurrentRegionCode = nil
        self.localePreferredLanguages = nil
        
        self.birthDate = nil
        self.emoji = nil
        //self.kids = nil
        
    }
    
    public init?(record: CKRecord) {
        
        self.recordID = record.recordID
        
        self.appleIDProvider_credential_user_email = record["appleIDProvider_credential_user_email"] as? String
        self.appleIDProvider_credential_user_familyName = record["appleIDProvider_credential_user_familyName"] as? String
        self.appleIDProvider_credential_user_givenName = record["appleIDProvider_credential_user_givenName"] as? String
        self.appleIDProvider_credential_user_identifier = record["appleIDProvider_credential_user_identifier"] as? String
        
        self.birthDate = record["birthDate"] as? Date
        self.emoji = record["emoji"] as? String
        
        self.localeCurrentLanguageCode = record["localeCurrentLanguageCode"] as? String
        self.localeCurrentRegionCode = record["localeCurrentRegionCode"] as? String
        self.localePreferredLanguages = record["localePreferredLanguages"] as? [String]
        
        // TODO Handle the kids reference
        //self.kids = record["kids"] as? [String]
        
    }
    
}
