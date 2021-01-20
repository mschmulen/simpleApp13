//
//  CKPrivateModel.swift
//  
//
//  Created by Matthew Schmulen on 7/31/20.
//

import Foundation
import SwiftUI
import CloudKit

// TODO Rename: CKPrivateModel
public protocol CKModel: Identifiable, Hashable {
    
    associatedtype ItemType
    
    // notification info
    static var silentPushNotificationCategory: NotificationCategory { get }
    static var silentPushNotificationDesiredKeys: [String]? { get }
    
    static var recordName: String { get }
    static var ckSchemeKeys: [String] { get }
    static var mock: ItemType { get }
    static var defaultSortDescriptor: SortDescriptor { get }
    
    var id: UUID { get }
    var recordID: CKRecord.ID? { get }
    var ckRecord: CKRecord? { get }
    
    init?(record: CKRecord)
    
    var title: String? { get }
    
    func update()
    
}
