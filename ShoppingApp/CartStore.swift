//
//  CartStore.swift
//  ShoppingApp
//
//  Created by Omidiora Emmanuel on 04/08/2026.
//

import SwiftUI

struct Product : Identifiable {
    let id : String
    let name : String
    let priceValue : Double
    let price : String
    let  color : Color
    let icon : String
}


struct CartItem : Identifiable {
    var id : String  { product.id }
    let product : Product
    var quantity : Int
}

@Observable
final class CartStore {
    private(set) var items : [CartItem] = []
    
    var itemCount : Int {
        items.reduce(0){$0 + $1.quantity}
    }
    
    var total: Double {
        items.reduce(0){$0 + ($1.product.priceValue  * Double($1.quantity))}
        
    }
    
    
    var formattedTotal : String {
        String(format: "$%.0f", total)
    }
  
    func add(_ product: Product) {
           if let index = items.firstIndex(where: { $0.product.id == product.id }) {
               items[index].quantity += 1
           } else {
               items.append(CartItem(product: product, quantity: 1))
           }
       }
       
       func increment(_ product: Product) {
           add(product)
       }
       
       func decrement(_ product: Product) {
           guard let index = items.firstIndex(where: { $0.product.id == product.id }) else { return }
           if items[index].quantity > 1 {
               items[index].quantity -= 1
           } else {
               items.remove(at: index)
           }
       }
       
       func remove(_ product: Product) {
           items.removeAll(where: { $0.product.id == product.id })
       }
}

extension Product {
  
    static let samples: [Product] = [
        Product(id: "linen-shirt", name: "Linen Shirt", priceValue: 48, price: "$48", color: Color(red: 0.72, green: 0.78, blue: 0.74), icon: "tshirt"),
        Product(id: "ceramic-mug", name: "Ceramic Mug", priceValue: 22, price: "$22", color: Color(red: 0.86, green: 0.80, blue: 0.74), icon: "cup.and.saucer"),
        Product(id: "day-bag", name: "Day Bag", priceValue: 86, price: "$86", color: Color(red: 0.70, green: 0.74, blue: 0.82), icon: "bag"),
        Product(id: "soft-lamp", name: "Soft Lamp", priceValue: 64, price: "$64", color: Color(red: 0.90, green: 0.86, blue: 0.78), icon: "lamp.desk"),
        Product(id: "wool-throw", name: "Wool Throw", priceValue: 72, price: "$72", color: Color(red: 0.78, green: 0.72, blue: 0.68), icon: "square.grid.3x3.topleft.filled"),
        Product(id: "glass-bottle", name: "Glass Bottle", priceValue: 28, price: "$28", color: Color(red: 0.68, green: 0.80, blue: 0.82), icon: "waterbottle")
    ]
   

}
