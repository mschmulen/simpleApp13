//
//  PurchaseView.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 7/19/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import FamilyKit
import StoreKit

struct PurchaseView: View {
    
    @Environment(\.window) var window: UIWindow?
    
    @EnvironmentObject var appState: AppState
    
    @State private var isDisabled : Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    private func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }

    var body: some View {
                           
        ScrollView (showsIndicators: false) {
            
            VStack {
                Text("Get Premium Membership").font(.title)
                Text("Choose one of the packages above").font(.subheadline)
                
                self.purchaseButtons()
                self.aboutText()
                self.helperButtons()
                self.termsText().frame(width: UIScreen.main.bounds.size.width)
                self.dismissButton()
                
                }.frame(width : UIScreen.main.bounds.size.width)
            }.disabled(self.isDisabled)
    }

    // MARK:- View creations
    
    func purchaseButtons() -> some View {
        // remake to ScrollView if has more than 2 products because they won't fit on screen.
        HStack {
            Spacer()
            
            if ProductPurchaseStore.shared.products.count <= 0 {
                Text("NO PRODUCTS in ProductPurchaseStore")
            }
            ForEach(ProductPurchaseStore.shared.products, id: \.self) { prod in
                PurchaseButton(block: {
                    self.purchaseProduct(skproduct: prod)
                }, product: prod).disabled(IAPManager.shared.isActive(product: prod))
            }
            Spacer()
        }
    }
    
    func helperButtons() -> some View{
        VStack {
            Button(action: {
                self.termsTapped()
            }) {
                Text("Terms of use").font(.footnote)
            }
            Button(action: {
                self.restorePurchases()
            }) {
                Text("Restore purchases").font(.footnote)
            }
            Button(action: {
                self.privacyTapped()
            }) {
                Text("Privacy policy").font(.footnote)
            }
            }.padding()
    }
    
    func aboutText() -> some View {
        Text("""
                • Unlimited searches
                • 100GB downloads
                • Multiplatform service
                """).font(.subheadline).lineLimit(nil)
    }
    
    func termsText() -> some View{
        // Set height to 600 because SwiftUI has bug that multiline text is getting cut even if linelimit is nil.
        VStack {
            Text(terms_text).font(.footnote).lineLimit(nil).padding()
            Spacer()
            }.frame(height: 350)
    }
    
    func dismissButton() -> some View {
        Button(action: {
            self.dismiss()
        }) {
            Text("Not now").font(.footnote)
            }.padding()
    }
    
    //MARK:- Actions
    
    func restorePurchases(){
        
        IAPManager.shared.restorePurchases(success: {
            self.isDisabled = false
            ProductPurchaseStore.shared.handleUpdateStore()
            self.dismiss()
            
        }) { (error) in
            self.isDisabled = false
            ProductPurchaseStore.shared.handleUpdateStore()
            
        }
    }
    
    func termsTapped(){
        
    }
    
    func privacyTapped(){
        
    }
    
    func purchaseProduct(skproduct : SKProduct){
        print("did tap purchase product: \(skproduct.productIdentifier)")
        isDisabled = true
        IAPManager.shared.purchaseProduct(product: skproduct, success: {
            self.isDisabled = false
            ProductPurchaseStore.shared.handleUpdateStore()
            self.dismiss()
        }) { (error) in
            self.isDisabled = false
            ProductPurchaseStore.shared.handleUpdateStore()
        }
    }
}

struct PurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseView()
    }
}


struct PurchaseButton : View {
    
    var block : SuccessBlock!
    var product : SKProduct!
    
    var body: some View {
        
        Button(action: {
            self.block()
        }) {
            Text(product.localizedPrice()).lineLimit(nil).multilineTextAlignment(.center).font(.subheadline)
            }.padding().frame(height: 50).scaledToFill().border(Color.blue, width: 1)
    }
}
