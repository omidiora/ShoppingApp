//
//  ContentView.swift
//  ShoppingApp
//
//  Created by vinayagamoorthi on 26/07/26.
//

import SwiftUI

struct ContentView: View {
    @Environment(CartStore.self) private var cartStore
    
    @State var selectedCategory = "All"
    let categories = ["All", "Apparel", "Home", "Beauty", "Tech"]
    let products = Product.samples
    @State private var addedProductID: String?
    @State var showCart = false
    
    var body: some View {
        NavigationStack {
            ZStack {
               Color(red: 0.93, green: 0.95, blue: 0.94)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    header
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                    
                    categoryRow
                        .padding(.top, 22)
                    
                    productGrid
                        .padding(.top, 18)
                    
                    Spacer()
                    
                    bottomBar
               }
            }
            .navigationDestination(isPresented: $showCart) {
                CartView()
            }
        }
    }
    
    var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Shopping App")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.12, green: 0.18, blue: 0.16))
                
                Text("Curated everyday essentials.")
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundStyle(Color(red: 0.35, green: 0.42, blue: 0.40))
                    
            }
            
            Spacer()
            
            Button(action: {
                showCart = true
            }, label: {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "bag")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Color(red: 0.12, green: 0.18, blue: 0.16))
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(.white.opacity(0.55)))
                    
                    if cartStore.itemCount > 0 {
                        Text("\(cartStore.itemCount)")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                         .foregroundStyle(.white)
                         .frame(minWidth: 18, minHeight: 18)
                         .background(Circle().fill(Color(red: 0.28, green: 0.48, blue: 0.44)))
                         .offset(x: 6, y: -4)
                    }
                }
            })
        }
    }
    
    var categoryRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 22) {
                ForEach(categories, id: \.self) { category in
                    Button {
                        selectedCategory = category
                    } label: {
                        VStack(spacing: 6) {
                            Text(category)
                                .font(.system(size: 15, weight: selectedCategory == category ? .semibold : .regular, design: .rounded))
                                .foregroundStyle(selectedCategory == category ? Color(red: 0.12, green: 0.18, blue: 0.16) : Color(red: 0.45, green: 0.52, blue: 0.50))
                            
                            Capsule()
                                .fill(selectedCategory == category ? Color(red: 0.28, green: 0.48, blue: 0.44) : .clear)
                                .frame(width: 18, height: 3)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 24)
        }
    }
    
    //MARK: Product Grid
    var productGrid: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 14),
                GridItem(.flexible(), spacing: 14)
            ], spacing: 16) {
                ForEach(Array(products.enumerated()), id: \.element.id) { index, product in
                    ProductCard(product: product, isAdded: addedProductID == product.id, onAddToCart: {
                        cartStore.add(product)
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                           addedProductID = product.id
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            if addedProductID == product.id {
                                withAnimation { addedProductID = nil  }
                            }
                        }
                    })
                    .opacity(1)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 28)
        }
    }
    
    var bottomBar: some View {
        HStack {
            bottomItem(icon: "house.fill", label: "Home", active: true)
            bottomItem(icon: "square.grid.2x2", label: "Browse", active: false)
            bottomItem(icon: "heart", label: "Saved", active: false)
            bottomItem(icon: "person", label: "You", active: false)
        }
        .padding(.horizontal, 28)
        .padding(.top, 14)
        .padding(.bottom, 28)
        .background(
            Rectangle()
                .fill(.white.opacity(0.82))
                .shadow(color: .black.opacity(0.04), radius: 12, y: -4)
                .ignoresSafeArea(edges: .bottom)
        )
    }
    
    func bottomItem(icon: String, label: String, active: Bool) -> some View {
        Button(action: {}, label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                Text(label)
                .font(.system(size: 11, weight: .medium, design: .rounded))
            }
            .foregroundStyle(
                active
                ? Color(red: 0.28, green: 0.48, blue: 0.44)
                : Color(red: 0.55, green: 0.60, blue: 0.58)
            )
            .frame(maxWidth: .infinity)
        })
        .buttonStyle(.plain)
    }
    
}

struct ProductCard: View {
    let product: Product
    let isAdded: Bool
    let onAddToCart: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(product.color)
                
                Image(systemName: product.icon)
                    .font(.system(size: 34, weight: .light))
                    .foregroundStyle(Color(red: 0.18, green: 0.24, blue: 0.22).opacity(0.55))
                    
            }
            .frame(height: 120)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(Color(red: 0.12, green: 0.18, blue: 0.16))
                
                Text(product.price)
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundStyle(Color(red: 0.40, green: 0.48, blue: 0.46))
            }
            .padding(.horizontal, 2)
            
            Button(action: onAddToCart, label: {
                HStack(spacing: 6) {
                    Image(systemName: isAdded ? "checkmark" : "plus")
                    .font(.system(size: 11, weight: .bold))
                    Text(isAdded ? "Added" : "Added to cart")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                }
                .foregroundStyle(isAdded ? Color(red: 0.12, green: 0.18, blue: 0.16) : .white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(
                            isAdded ? Color(red: 0.28, green: 0.48, blue: 0.44).opacity(0.12) : Color(red: 0.28, green: 0.48, blue: 0.44)
                        )
                )
            })
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    ContentView()
        .environment(CartStore())
}
