//
//  FamilyKit+Player.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/18/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import FamilyKit

extension Player {
    
    public func isOwnerOrEmpty(model: CKActivityModel) ->Bool {
        guard let myReference = self.recordReference else {
            return false
        }
        guard let modelReference = model.kidReference else {
            return true
        }
        
        if modelReference == myReference {
            return true
        } else {
            return false
        }
    }
        
    public func isOwner(model: CKActivityModel) ->Bool {
        guard let myReference = self.recordReference else {
            return false
        }
        guard let modelReference = model.kidReference else {
            return false
        }
        
        if modelReference == myReference {
            return true
        } else {
            return false
        }
    }
}

