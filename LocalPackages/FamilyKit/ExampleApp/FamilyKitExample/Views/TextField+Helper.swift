//
//  TextField+Helper.swift
//  FamilyKitExample
//
//  Created by Matthew Schmulen on 8/1/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

//TextField("", text: $test ?? "default value")
func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}


// TextField($test.bound)
//extension Optional where Wrapped == String {
//    var _bound: String? {
//        get {
//            return self
//        }
//        set {
//            self = newValue
//        }
//    }
//    public var bound: String {
//        get {
//            return _bound ?? ""
//        }
//        set {
//            _bound = newValue.isEmpty ? nil : newValue
//        }
//    }
//}




//struct IntTextField: TextField {
//
//    init(_ text: String, binding: Binding<Int>) {
//
//    }
//}
