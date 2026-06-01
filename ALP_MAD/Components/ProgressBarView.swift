//
//  ProgressBarView.swift
//  ALP_MAD
//
//  Created by Nicholas Leroy Kurniawan on 1/6/26.
//

import SwiftUI

struct ProgressBarView: View {
    let progress: Double
    let gradient: LinearGradient
    var height: CGFloat = 14
    var showLabel: Bool = true
    var labelText: String = ""
    
    @State private var animatedProgress: Double = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if showLabel && !labelText.isEmpty {
                Text(labelText)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppTheme.textSecondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(AppTheme.bgCardLight.opacity(0.6))
                        .frame(height: height)
                    
                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(gradient)
                        .frame(
                            width: max(0, geometry.size.width * CGFloat(min(animatedProgress, 1.0))),
                            height: height
                        )
                        .shadow(color: gradient.stops.first?.color.opacity(0.5) ?? .clear, radius: 4, x: 0, y: 0)
                }
            }
            .frame(height: height)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { _, newValue in
            withAnimation(.easeOut(duration: 0.5)) {
                animatedProgress = newValue
            }
        }
    }
}

private extension LinearGradient {
    var stops: [Gradient.Stop] {
        return []
    }
}

#Preview {
    VStack(spacing: 20) {
        ProgressBarView(
            progress: 0.6,
            gradient: AppTheme.expGradient,
            labelText: "EXP"
        )
        ProgressBarView(
            progress: 0.4,
            gradient: AppTheme.staminaGradient,
            labelText: "Stamina"
        )
        ProgressBarView(
            progress: 0.8,
            gradient: AppTheme.bossHPGradient,
            labelText: "Boss HP"
        )
    }
    .padding()
    .background(AppTheme.bgDark)
}
