//
//  CKDevice.swift
//  
//
//  Created by Matthew Schmulen on 8/1/20.
//

import Foundation
import SwiftUI
import CoreLocation
import CloudKit

internal struct DeviceModel {

    let idfv: UUID?
    let localeLanguageCode: String?
    let localeRegionCode: String?
    let localePreferredLanguages: [String]

    init() {

        self.idfv = UIDevice.current.identifierForVendor
        let locale = Locale.current
        self.localeLanguageCode = locale.languageCode
        self.localeRegionCode = locale.regionCode
        self.localePreferredLanguages = Locale.preferredLanguages
    }
    
    internal static var mock:DeviceModel {
        DeviceModel()
    }
    
}

public struct CKDeviceModel: CKModel {
    
    public static var defaultSortDescriptor: SortDescriptor {
        return .none
    }
    
    public typealias ItemType = CKDeviceModel
    public static let silentPushNotificationCategory = NotificationCategory.familyKitCategorySilentPushGeneric
    public static let silentPushNotificationDesiredKeys: [String]? = nil
    public static let recordName = "Device"
    public static let ckSchemeKeys = [
        "idfv"
    ]
    
    public var id = UUID()
    public var recordID: CKRecord.ID?
    
    public var idfv: String?
    public var localeLanguageCode: String?
    public var localeRegionCode: String?
    public var localePreferredLanguages: [String]?
    
    public var title: String? {
        return idfv
    }
    
    public static var mock: CKDeviceModel {
        var model = CKDeviceModel(deviceModel: DeviceModel.mock)
        model.idfv = "mock idfv"
        model.localeLanguageCode = "en"
        model.localeRegionCode = "US"
        model.localePreferredLanguages = [String]()
        return model
    }
    
    internal init(
        deviceModel:DeviceModel
    ){
        self.idfv = UIDevice.current.identifierForVendor?.uuidString
        let locale = Locale.current
        self.localeLanguageCode = locale.languageCode
        self.localeRegionCode = locale.regionCode
        self.localePreferredLanguages = Locale.preferredLanguages
    }
    
    public init?(record: CKRecord) {
        guard
            let _idfv = record["idfv"] as? String
            else {
                print("CKFamilyModel incomplete record")
                print( "\(record["name"] as? String ?? "no name")")
                return nil
        }
        
        self.recordID = record.recordID
        self.idfv = _idfv
        
        self.localeLanguageCode = record["localeLanguageCode"] as? String
        self.localeRegionCode = record["localeRegionCode"] as? String
        self.localePreferredLanguages = record["localePreferredLanguages"] as? [String]
    }
    
}

// MARK: - Create a CKRecord from this model
extension CKDeviceModel {
    
    public var ckRecord: CKRecord? {
        let record: CKRecord
        if let recordID = recordID {
            record = CKRecord(recordType: CKDeviceModel.recordName, recordID: recordID)
        }
        else {
            record = CKRecord(recordType: CKDeviceModel.recordName)
        }
        
        if let idfv = idfv {
            record["idfv"] = idfv as CKRecordValue
        }

        if let localeLanguageCode = localeLanguageCode {
            record["localeLanguageCode"] = localeLanguageCode as CKRecordValue
        }

        if let localeRegionCode = localeRegionCode {
            record["localeRegionCode"] = localeRegionCode as CKRecordValue
        }
        
        // TODO: fix the localePreferredLanguages for the device
//        if let localePreferredLanguages = localePreferredLanguages {
//            record["localePreferredLanguages"] = localePreferredLanguages as CKRecordValue
//        }
        
        return record
    }
}
