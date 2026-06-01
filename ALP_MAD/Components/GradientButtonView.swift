//
//  GradientButtonView.swift
//  ALP_MAD
//
//  Created by Nicholas Leroy Kurniawan on 1/6/26.
//

import SwiftUI

struct GradientButtonView: View {
    let title: String
    let icon: String?
    let gradient: LinearGradient
    let action: () -> Void
    var isDisabled: Bool = false
    var isLoading: Bool = false
    var fullWidth: Bool = true
    
    init(
        title: String,
        icon: String? = nil,
        gradient: LinearGradient = AppTheme.primaryGradient,
        isDisabled: Bool = false,
        isLoading: Bool = false,
        fullWidth: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.gradient = gradient
        self.isDisabled = isDisabled
        self.isLoading = isLoading
        self.fullWidth = fullWidth
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(0.8)
                } else {
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(.headline)
                    }
                    Text(title)
                        .fontWeight(.bold)
                }
            }
            .foregroundStyle(.white)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .padding(.vertical, 14)
            .padding(.horizontal, 24)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isDisabled ? AnyShapeStyle(Color.gray.opacity(0.3)) : AnyShapeStyle(gradient))
            )
            .shadow(color: isDisabled ? .clear : AppTheme.primaryColor.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .disabled(isDisabled || isLoading)
        .scaleEffect(isDisabled ? 0.98 : 1.0)
    }
}
