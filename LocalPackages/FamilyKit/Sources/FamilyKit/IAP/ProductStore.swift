//
//  File.swift
//  
//
//  Created by Matthew Schmulen on 8/3/20.
//

import Foundation
import Combine

struct SKProduct {
    let id:UUID = UUID()
}

class ProductsStore : ObservableObject {
    
    static let shared = ProductsStore()
    
    @Published var products: [SKProduct] = []
    @Published var anyString = "123" // little trick to force reload ContentView from PurchaseView by just changing any Published value
    
    func handleUpdateStore(){
        anyString = UUID().uuidString
    }
    
    func initializeProducts(){
//        IAPManager.shared.startWith(arrayOfIds: [subscription_1, subscription_2], sharedSecret: shared_secret) { products in
//            self.products = products
//        }
    }
}

