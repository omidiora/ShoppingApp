//
//  ContentView.swift
//  ShoppingApp
//
//  Created by Omidiora Emmanuel on 03/08/2026.
//

import SwiftUI

struct ContentView: View {
    @Environment(CartStore.self) private var cartStore
    
    
    @State var selectedCategory  = "All"
    let caegories = ["All", "Apparel", "Home", "Beauty", "Tech"]
    
    
    let products = Product.samples
    @State private var addedProductID : String?
    @State var showCart = true
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color(red :0.93, green: 0.95, blue: 0.94)
                VStack {
                    header.padding(.horizontal,24)
                        .padding(.top,8)
                    
                    categoryRow.padding(.top, 22)
                    
                    productGrid.padding(.top ,10)
                    
                    Spacer()
                    
                    bottomBar
                }
                
                
            }
        }.navigationDestination(isPresented: $showCart){
            CartView()
        }
    }
    

        var header : some View {
            HStack {
                VStack(alignment: .leading,spacing: 4){
                    Text("Shopping App")
                        .font(.system(size: 36 , weight: .bold ,design: .rounded))
                        .foregroundStyle(Color(red :0.12 , green: 0.18, blue: 0.18))
                    
                    
                    Text("Curated everyday essentials")
                        .font(.system(size: 14 , weight: .regular ,design: .rounded))
                        .foregroundStyle(Color(red :0.35 , green: 0.42, blue: 0.40))
                    
              }
            Spacer()
                
                
                Button{
                    showCart = true
                    
                }label:{
                    ZStack(alignment: .topTrailing){
                        Image(systemName: "bag")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(Color(red:0.12, green: 0.18, blue: 0.16))
                            .frame(width: 44,height: 44)
                            .background(Circle().fill(.white.opacity(0.55)))
                        
                        if cartStore.itemCount > 0 {
                            Text("\(cartStore.itemCount)")
                                .font(.system(size: 11, weight: .bold,design: .rounded))
                                .foregroundStyle(.white)
                                .frame(minWidth: 18 , minHeight: 18)
                                .background(Circle().fill(Color(red:0.2, green: 0.48, blue: 0.44)))
                                .offset(x:6, y: -4)
                            
                        }

                    }
                }
                
            }
            
        }
    
    
    var categoryRow : some View {
        ScrollView(.horizontal){
            HStack(spacing :22){
                ForEach(caegories, id:\.self){
                    category in
                    Button {
                        selectedCategory = category
                        
                    }label: {
                        VStack{
                        Text(category)
                                .font(.system(size: 16,weight: selectedCategory == category ? .semibold : .regular, design: .rounded))
                                .foregroundStyle(selectedCategory == category ? Color(red:0.12 , green: 0.18 ,blue: 0.16): Color(red:0.45 , green: 0.52,blue: 0.50) )
                            
                            Capsule().fill(selectedCategory == category ? Color(red :0.28 , green: 0.48 ,blue: 0.44): .clear)
                                .frame(width: 20 , height: 3)
                        
                        }
                    }.buttonStyle(.plain)
                }
                
            }.padding(.horizontal, 24)
        }
    }
    
//    MARK : PRODUCT GRID
    
    var productGrid : some View {
        ScrollView{
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 14),
                GridItem(.flexible(), spacing: 14),
            ],spacing: 16){
            
                ForEach(Array(products.enumerated()),id: \.element.id){
                    index , product in
                    ProductCard(product: product, isAdded: addedProductID == product.id , onAddtoCart: {
                        cartStore.add(product)
                        withAnimation(.spring(response:0.3, dampingFraction:0.7)){
                            addedProductID  == product.id
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){
                            if addedProductID == product.id {
                                withAnimation{
                                    addedProductID = nil
                                }
                            }
                        }
                        
                    }).opacity(1)
                }
                
        
            }.padding(.horizontal ,24)
                .padding(.bottom ,26)
            
            
        }
    }
    
    
    var bottomBar:  some View{
        HStack{
            bottomItem(icon: "house.fill", label: "Home", active: true)
            bottomItem(icon: "house.fill", label: "Home", active: true)
            bottomItem(icon: "house.fill", label: "Home", active: true)
            bottomItem(icon: "house.fill", label: "Home", active: true)
        }.padding(.horizontal,20)
            .padding(.top ,14)
            .padding(.bottom, 28)
            .background(Rectangle().fill(.white.opacity(0.02))
                .shadow(color: .blue.opacity(0.04), radius: 12, y: -4)
                .ignoresSafeArea(edges: .bottom)
            )
    }
    
    
    func bottomItem(icon : String, label:String , active:Bool)-> some View{
        Button(action: {}, label: {
            VStack{
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                Text(label)
                    .font(.system(size: 11,weight: .medium ,design: .rounded))
            }.foregroundStyle(active ? Color(red:0.28, green: 0.48, blue: 0.444): Color(red:0.55, green: 0.60, blue: 0.58))
        }).buttonStyle(.plain)
    }
    
    
}


struct ProductCard : View {
    let product:Product
    let isAdded : Bool
    let onAddtoCart : ()->Void
    var body: some View {
        VStack(alignment: .leading,spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 19, style: .continuous).fill(product.color)
                Image(systemName: product.icon).font(.system(size: 34, weight: .light))
                    .foregroundStyle(Color(red:0.18, green: 0.24, blue: 0.22).opacity(0.55))
            }.frame(height: 120)
            VStack(alignment: .leading){
                Text(product.name)
                    .font(.system(size: 14 , weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red:0.12 , green: 0.10 ,blue: 0.16))
                
                Text(product.price)
                    .font(.system(size: 14, weight: .regular ,design: .rounded))
                    .foregroundStyle(Color(red:0.40, green: 0.18 , blue: 0.16))

            }.padding(.horizontal,2)
            
            Button(action:onAddtoCart, label: {
                HStack(spacing : 6) {
                    Image(systemName: isAdded ? "checkmark":"plus")
                        .font(.system(size: 11, weight: .bold))
                    Text(isAdded ? "Added" :"Added to cart")
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                    
                }.foregroundStyle(isAdded ? Color(red: 0.12, green: 0.18,blue: 0.16) : .white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical,10)
                    .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(isAdded ? Color(red: 0.28, green: 0.48, blue: 0.44).opacity(0.12): Color(red: 0.28, green: 0.48, blue: 0.44)))
            }).buttonStyle(.plain)
        }
        
    }
}

#Preview {
    ContentView().environment(CartStore())
}
