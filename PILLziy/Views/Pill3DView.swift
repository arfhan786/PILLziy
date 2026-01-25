//
//  Pill3DView.swift
//  PILLziy
//
//  Created by Arfhan Ahmad on 1/24/26.
//

import SwiftUI

struct Pill3DView: View {
    var topColor: Color = .red
    var bottomColor: Color = .white
    
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let pillWidth = size * 0.7
            let pillHeight = size * 0.5
            
            ZStack {
                // Bottom half (white) - capsule shape
                Capsule()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                bottomColor,
                                bottomColor.opacity(0.95)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: pillWidth, height: pillHeight)
                    .offset(y: pillHeight * 0.25)
                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
                    .overlay(
                        // Highlight on bottom half
                        Capsule()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.3),
                                        Color.clear
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: pillWidth, height: pillHeight)
                            .offset(y: pillHeight * 0.25)
                    )
                
                // Top half (red) - capsule shape
                Capsule()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                topColor,
                                topColor.opacity(0.95)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: pillWidth, height: pillHeight)
                    .offset(y: -pillHeight * 0.25)
                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: -5)
                    .overlay(
                        // Highlight on top half
                        Capsule()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.4),
                                        Color.clear
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: pillWidth, height: pillHeight)
                            .offset(y: -pillHeight * 0.25)
                    )
                
                // Face on top half (red part)
                VStack(spacing: size * 0.06) {
                    // Eyes
                    HStack(spacing: size * 0.15) {
                        // Left eye
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: size * 0.14, height: size * 0.14)
                            
                            Circle()
                                .fill(Color.black)
                                .frame(width: size * 0.07, height: size * 0.07)
                        }
                        
                        // Right eye
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: size * 0.14, height: size * 0.14)
                            
                            Circle()
                                .fill(Color.black)
                                .frame(width: size * 0.07, height: size * 0.07)
                        }
                    }
                    
                    // Smile - curved line
                    Path { path in
                        let centerX: CGFloat = 0
                        let centerY: CGFloat = 0
                        let radius = size * 0.09
                        
                        path.move(to: CGPoint(x: centerX - radius, y: centerY))
                        path.addQuadCurve(
                            to: CGPoint(x: centerX + radius, y: centerY),
                            control: CGPoint(x: centerX, y: centerY + radius * 0.6)
                        )
                    }
                    .stroke(Color.black, lineWidth: size * 0.025)
                    .frame(width: size * 0.2, height: size * 0.1)
                }
                .offset(y: -pillHeight * 0.25)
            }
            .frame(width: size, height: size)
        }
        .rotation3DEffect(
            .degrees(20),
            axis: (x: 1, y: 0, z: 0),
            perspective: 0.4
        )
    }
}

#Preview {
    Pill3DView()
        .frame(width: 200, height: 200)
}
