//
//  CartView.swift
//  ShoppingApp


import SwiftUI

struct CartView: View {
    @Environment(CartStore.self) private var cartStore
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color(red: 0.93, green: 0.95, blue: 0.94)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                header
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                
                if cartStore.items.isEmpty {
                    emptyState
                } else {
                    cartContent
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private var header: some View {
        HStack {
           Button(action: {
               dismiss()
           }, label: {
               Image(systemName: "chevron.left")
               .font(.system(size: 16, weight: .semibold))
               .foregroundStyle(Color(red: 0.12, green: 0.18, blue: 0.16))
               .frame(width: 40, height: 40)
               .background(Circle().fill(.white.opacity(0.55)))
           })
            
           Spacer()
            
           Text("Your Cart")
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundStyle(Color(red: 0.12, green: 0.18, blue: 0.16))
            
            Spacer()
            Color.clear.frame(width: 40, height: 40)
        }
    }
    
    var emptyState: some View {
        VStack(spacing: 14) {
            Spacer()
            
            Image(systemName: "bag")
            .font(.system(size: 44, weight: .light))
            .foregroundStyle(Color(red: 0.45, green: 0.52, blue: 0.50))
            
            Text("Your cart is empty")
            .font(.system(size: 18, weight: .semibold, design: .rounded))
            .foregroundStyle(Color(red: 0.12, green: 0.18, blue: 0.16))
            
            Text("Add items from the home screen.")
            .font(.system(size: 14, weight: .regular, design: .rounded))
            .foregroundStyle(Color(red: 0.45, green: 0.52, blue: 0.50))
            
            Spacer()
        }
    }
    
    private var cartContent: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    ForEach(cartStore.items) { item in
                        CartItemRow(item: item)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 16)
            }
            
            summaryBar
        }
    }
    
    private var summaryBar: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Total")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(Color(red: 0.35, green: 0.42, blue: 0.40))
                
                Spacer()
                
                Text(cartStore.formattedTotal)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.12, green: 0.18, blue: 0.16))
            }
            
            Button(action: {}, label: {
                Text("Checkout")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color(red: 0.28, green: 0.48, blue: 0.44))
                )
            })
        }
        .padding(.horizontal, 24)
        .padding(.top, 18)
        .padding(.bottom, 28)
        .background(
            Rectangle()
                .fill(.white.opacity(0.82))
                .shadow(color: .black.opacity(0.04), radius: 12, y: -4)
                .ignoresSafeArea(edges: .bottom)
        )
    }
}

struct CartItemRow: View {
    @Environment(CartStore.self) private var cartStore
    let item: CartItem
    
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(item.product.color)
                    .frame(width: 72, height: 72)
                
                Image(systemName: item.product.icon)
                    .font(.system(size: 24, weight: .light))
                    .foregroundStyle(Color(red: 0.18, green: 0.24, blue: 0.22).opacity(0.55))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.product.name)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(Color(red: 0.12, green: 0.18, blue: 0.16))
                
                Text(item.product.price)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundStyle(Color(red: 0.40, green: 0.48, blue: 0.46))
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                quantityButton(icon: "minus") {
                    cartStore.decrement(item.product)
                }
                
                Text("\(item.quantity)")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color(red: 0.12, green: 0.18, blue: 0.16))
                    .frame(minWidth: 16)
                
                quantityButton(icon: "plus") {
                    cartStore.increment(item.product)
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.white.opacity(0.72))
        )
    }
    
    func quantityButton(icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action, label: {
            Image(systemName: icon)
            .font(.system(size: 12, weight: .bold))
            .foregroundStyle(Color(red: 0.28, green: 0.48, blue: 0.44))
            .frame(width: 28, height: 28)
            .background(
                Circle()
                    .fill(Color(red: 0.28, green: 0.48, blue: 0.44).opacity(0.12))
            )
        })
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        CartView()
            .environment(CartStore())
    }
}
