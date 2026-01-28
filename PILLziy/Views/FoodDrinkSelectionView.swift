//
//  FoodDrinkSelectionView.swift
//  PILLziy
//
//  Created by Arfhan Ahmad on 1/24/26.
//

import SwiftUI

private let selectionMorphismGray = Color(white: 0.97)

private struct SelectionMorphismOverlay: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.1),
                        Color.black.opacity(0.03),
                        Color.clear
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .allowsHitTesting(false)
    }
}

struct FoodDrinkItem {
    let imageName: String
    let title: String
}

struct FoodDrinkSelectionView: View {
    @Environment(\.dismiss) var dismiss
    
    private let items: [FoodDrinkItem] = [
        FoodDrinkItem(imageName: "Banana", title: "Banana"),
        FoodDrinkItem(imageName: "Water", title: "Water"),
        FoodDrinkItem(imageName: "Milk", title: "Milk"),
        FoodDrinkItem(imageName: "Coke", title: "Coke"),
        FoodDrinkItem(imageName: "Fried Food", title: "Fried Food"),
        FoodDrinkItem(imageName: "Ice Cream", title: "Ice Cream")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 18),
                    GridItem(.flexible(), spacing: 18)
                ], spacing: 18) {
                    ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                        if item.title == "Milk" {
                            NavigationLink(destination: TakeWithMilkView()) {
                                FoodDrinkCard(item: item)
                            }
                            .buttonStyle(.plain)
                        } else {
                            FoodDrinkCard(item: item)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 40)
                .padding(.bottom, 24)
            }
        }
        .background(Color.white)
        .navigationTitle("Select Food Or Drink")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FoodDrinkCard: View {
    let item: FoodDrinkItem
    
    var body: some View {
        VStack(spacing: 12) {
            Image(item.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 100)
            
            Text(item.title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .background(selectionMorphismGray)
        .overlay(SelectionMorphismOverlay())
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.16), radius: 14, x: 0, y: 8)
    }
}

#Preview {
    NavigationStack {
        FoodDrinkSelectionView()
    }
}
