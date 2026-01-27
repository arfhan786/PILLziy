//
//  TakeDoseView.swift
//  PILLziy
//
//  Created by Arfhan Ahmad on 1/24/26.
//

import SwiftUI

private let takeDoseMorphismGray = Color(white: 0.94)
private let takeDoseGreen = Color(red: 0.45, green: 0.90, blue: 0.52)

private struct TakeDoseMorphismOverlay: View {
    var body: some View {
        Capsule()
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

struct TakeDoseView: View {
    let medication: Medication
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .center, spacing: 24) {
                    Image("BodyDoseSkip")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    LoopingPillVideoView()
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            
            HStack(spacing: 12) {
                Button(action: {
                    // How to take it action
                }) {
                    Text("How to take it?")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                        .background(takeDoseMorphismGray)
                        .overlay(TakeDoseMorphismOverlay())
                        .clipShape(Capsule())
                        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
                }
                .buttonStyle(.plain)
                
                Button(action: {
                    dismiss()
                }) {
                    Text("I have taken")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                        .background(takeDoseGreen)
                        .overlay(TakeDoseMorphismOverlay())
                        .clipShape(Capsule())
                        .shadow(color: takeDoseGreen.opacity(0.4), radius: 8, x: 0, y: 4)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .background(Color(white: 0.98))
        .navigationTitle(medication.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        TakeDoseView(medication: Medication(name: "Tylenol 500", dosage: "500mg", frequency: "1 Pill Daily"))
    }
}
