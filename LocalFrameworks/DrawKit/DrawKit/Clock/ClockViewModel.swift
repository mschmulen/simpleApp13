//
//  ClockViewModel.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct ClockViewModel: Codable {
    
    let isEnabled: Bool
    
    let clockType: ClockType
    
    let showPauseButton: Bool
    
    let showRestartButton: Bool
    
    static var mock:ClockViewModel {
        return ClockViewModel(
            isEnabled: true,
            clockType: .stopWatch,
            showPauseButton: true,
            showRestartButton: true
        )
    }
}

extension ClockViewModel {
    
    static var defaultConfig:ClockViewModel {
        return ClockViewModel(
            isEnabled: true,
            clockType: .stopWatch,
            showPauseButton: false,
            showRestartButton: false
        )
    }
    
    static var countDownCofig:ClockViewModel {
        return ClockViewModel(
            isEnabled: true,
            clockType: .timer(totalMinutes: 3, warningMinutes:1),
            showPauseButton: false,
            showRestartButton: false
        )
    }
}

enum ClockType {
    case timer( totalMinutes:Int, warningMinutes:Int)
    case stopWatch
}

extension ClockType: Codable {
    
    enum CodingKeys: CodingKey {
        case rawValue
        case associatedValue
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 0:
            let minutes = try container.decode(Int.self, forKey: .associatedValue)
            let minutesWarning = try container.decode(Int.self, forKey: .associatedValue)
            self = .timer(totalMinutes: minutes, warningMinutes: minutesWarning)
        case 1:
            //let email = try container.decode(String.self, forKey: .associatedValue)
            // self = .email(email)
            self = .stopWatch
        default:
            throw CodingError.unknownValue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .timer(let minutes, let minutesWarning):
            try container.encode(0, forKey: .rawValue)
            try container.encode(minutes, forKey: .associatedValue)
            try container.encode(minutesWarning, forKey: .associatedValue)
        case .stopWatch:
            try container.encode(0, forKey: .rawValue)
        }
    }
}
