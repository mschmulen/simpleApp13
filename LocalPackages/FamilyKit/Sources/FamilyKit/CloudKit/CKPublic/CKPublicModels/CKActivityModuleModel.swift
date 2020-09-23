//
//  CKActivityModule.swift
//  
//
//  Created by Matthew Schmulen on 9/15/20.
//

import Foundation
import SwiftUI
import CloudKit

public enum ActivityModuleType: String, CaseIterable {
    case audio
    case photo
    case drawing
    case chat
    case none
}

extension ActivityModuleType {
    
    public var emoji: String {
        switch self {
        case .audio:
            return "🎧"
        case .photo:
            return "📷"
        case .drawing:
            return "🎨"
        case .chat:
            return "💬"
        case .none:
            return "🔖"
        }
    }
}

public typealias SemVersionString = String

public final class CKActivityModuleModel: CKModel, ObservableObject {
    
    public static func == (lhs: CKActivityModuleModel, rhs: CKActivityModuleModel) -> Bool {
        return lhs.id == rhs.id
    }
    public func hash(into hasher: inout Hasher) { hasher.combine(id) }
    public static var defaultSortDescriptor: SortDescriptor {
        return .custom(key: "creationDate", ascending: true)
    }
    
    public typealias ItemType = CKActivityModuleModel
    public static let silentPushNotificationCategory = NotificationCategory.familyKitCategorySilentPushChoreActive
    public static let silentPushNotificationDesiredKeys: [String]? = ["name", "version"]
    public static let recordName = "ActivityModule"
    public static let ckSchemeKeys = [
        "name",
        "description",
        "version"
    ]
    public var id = UUID()
    public var recordID: CKRecord.ID?
    
    public var name: String?
    public var description: String?
    public var version: SemVersionString?
    
    public var moduleType: ActivityModuleType {
        return ActivityModuleType.photo
    }
    
    public var title: String? {
        return name
    }
    
    public static var mock: CKActivityModuleModel {
        let model = CKActivityModuleModel(
            name: "photo",
            description:"simple photo activitys",
            version: "0.0.1"
        )
        return model
    }
    
    public init(
    ){
        self.name = nil
        self.description = nil
        self.version = nil
    }
    
    public init(name: String, description: String, version: String) {
        self.name = name
        self.description = description
        self.version = version
    }
    
    public init?(record: CKRecord) {
        
        self.recordID = record.recordID
        
        if let name  = record["name"] as? String {
            self.name = name
        }
        
        if let description = record["description"] as? String {
            self.description = description
        }
    }
    
}

// MARK: - Create a CKRecord from this model
extension CKActivityModuleModel {
    
    public var ckRecord: CKRecord? {
        
        let record: CKRecord
        
        if let recordID = recordID {
            record = CKRecord(recordType: CKActivityModuleModel.recordName, recordID: recordID)
        }
        else {
            record = CKRecord(recordType: CKActivityModuleModel.recordName)
        }
        
        if let name = name {
            record["name"] = name as CKRecordValue
        }
        
        if let description = description {
            record["description"] = description as CKRecordValue
        }
        
        return record
    }
}
