//
//  File.swift
//  
//
//  Created by Matthew Schmulen on 8/3/20.
//

import Foundation
import SwiftUI
import Combine
import StoreKit

// reference: https://github.com/bizz84/SwiftyStoreKit
// reference: https://github.com/apphud/ios-swiftui-subscriptions
// reference: https://blog.apphud.com/swift-ui-subscriptions/
// reference: RevenueCat’s SDK

private let subscription_1 = "YOUR_PRODUCT_ID"
private let subscription_2 = "YOUR_ANOTHER_PRODUCT_ID"

// TODO setup StoreKit
private let shared_secret = "YOUR_SHARED_SECRET"

public let terms_text = "Premium subscription is required to get access to all wallpapers. Regardless whether the subscription has free trial period or not it automatically renews with the price and duration given above unless it is canceled at least 24 hours before the end of the current period. Payment will be charged to your Apple ID account at the confirmation of purchase. Your account will be charged for renewal within 24 hours prior to the end of the current period. You can manage and cancel your subscriptions by going to your account settings on the App Store after purchase. Any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription to that publication, where applicable."

// TODO: integrate this into FamilyKitAppState
public class ProductPurchaseStore : ObservableObject {
    
    public static let shared = ProductPurchaseStore()
    
    @Published public var products: [SKProduct] = []
    @Published public var anyString = UUID().uuidString // observable "cache buster" force reload of purchase values for View
    
    public func handleUpdateStore(){
        anyString = UUID().uuidString
    }
    
    public func initializeProducts(){
        func initializeProducts(){
            IAPManager.shared.startWith(arrayOfIds: [subscription_1, subscription_2], sharedSecret: shared_secret) { products in
                self.products = products
            }
        }
    }
    
}

// usage ...
//struct ContentView : View {
//    @ObservedObject var productsStore : ProductsStore
//    @State var show_modal = false
//
//    var body: some View {
//        VStack() {
//            ForEach (productsStore.products, id: \.self) { prod in
//                Text(prod.subscriptionStatus()).lineLimit(nil).frame(height: 80)
//            }
//            Button(action: {
//                print("Button Pushed")
//                self.show_modal = true
//            }) {
//                Text("Present")
//            }.sheet(isPresented: self.$show_modal) {
//                 PurchaseView()
//            }
//        }
//    }
//}
