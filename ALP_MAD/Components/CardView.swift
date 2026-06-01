//
//  CardView.swift
//  ALP_MAD
//
//  Created by Nicholas Leroy Kurniawan on 1/6/26.
//

import SwiftUI

struct CardView<Content: View>: View {
    var padding: CGFloat = 16
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            content()
        }
        .padding(padding)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppTheme.bgCard.opacity(0.85))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    AppTheme.primaryColor.opacity(0.3),
                                    AppTheme.secondaryColor.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}
