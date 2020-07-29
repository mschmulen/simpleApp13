//
//  ArrayStack.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation

/**
 Stack
 Codable Stack implimentation with an array backing data store
 
*/
struct Stack<T:Codable> : Codable {
    
    public private(set) var items: [T] = []
    
    mutating func push(_ item: T) {
        self.items.insert(item, at: 0)
    }
    
    mutating func pop() -> T? {
        if items.isEmpty { return nil }
        return self.items.removeFirst()
    }
    
    func peek() -> T? {
        return self.items.first
    }
}

//struct StackX<T:Drawable>: StackProtocol{
//
//    typealias ItemType = T
//
//    public private(set) var items: [T] = []
//
//    mutating func push(_ item: T) {
//        self.items.insert(item, at: 0)
//    }
//
//    mutating func pop() -> T? {
//        if items.isEmpty { return nil }
//        return self.items.removeFirst()
//    }
//
//    func peek() -> T? {
//        return self.items.first
//    }
//}


protocol DrawableStackProtocol {
    associatedtype ListItemDrawable
    
    var items: [ListItemDrawable] { get}
    mutating func push(_ item: ListItemDrawable)
    mutating func pop() -> ListItemDrawable?
    func peek() -> ListItemDrawable?
}

struct StackDrawable: DrawableStackProtocol {
    
    public private(set) var items: [Drawable] = []
    
    mutating func push(_ item: Drawable) {
        self.items.insert(item, at: 0)
    }
    
    mutating func pop() -> Drawable? {
        if items.isEmpty { return nil }
        return self.items.removeFirst()
    }
    
    func peek() -> Drawable? {
        return self.items.first
    }
}

//class CStack<T:Drawable> : Codable {
//    
//    var items: [T] = []
//    
//    func push(_ item: T) {
//        self.items.insert(item, at: 0)
//    }
//    
//    func pop() -> T? {
//        if items.isEmpty { return nil }
//        return self.items.removeFirst()
//    }
//    
//    func peek() -> T? {
//        return self.items.first
//    }
//}


/**
 Non serializable Array Stack
 maybe you can deprecate this by making the commands serializable
 
 */
//struct ArrayStack<T> {
//    var items: [T] = []
//
//    mutating func push(_ item: T) {
//        self.items.insert(item, at: 0)
//    }
//
//    mutating func pop() -> T? {
//        if items.isEmpty { return nil }
//        return self.items.removeFirst()
//    }
//
//    func peek() -> T? {
//        return self.items.first
//    }
//}
