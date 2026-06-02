//
//  AttackButtonView.swift
//  ALP_MAD
//
//  Created by Hendrawan Saputro on 30/05/26.
//

import SwiftUI

struct AttackButtonView: View {
    let canAttack: Bool
    let stamina: Int
    let isLoading: Bool
    let isDefeated: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 12) {
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                    isPressed = true
                }
                action()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isPressed = false
                }
            } label: {
                VStack(spacing: 8) {
                    if isLoading {
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(1.2)
                    } else if isDefeated {
                        Image(systemName: "checkmark.shield.fill")
                            .font(.system(size: 32))
                        Text("DEFEATED")
                            .font(.headline)
                            .fontWeight(.heavy)
                    } else {
                        Image(systemName: "bolt.circle.fill")
                            .font(.system(size: 36))
                        Text("ATTACK")
                            .font(.headline)
                            .fontWeight(.heavy)
                            .tracking(2)
                    }
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            isDefeated
                                ? AnyShapeStyle(AppTheme.accentGreen.opacity(0.3))
                                : canAttack
                                    ? AnyShapeStyle(AppTheme.attackGradient)
                                    : AnyShapeStyle(Color.gray.opacity(0.3))
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            isDefeated
                                ? AppTheme.accentGreen.opacity(0.4)
                                : canAttack
                                    ? AppTheme.accentRed.opacity(0.5)
                                    : Color.gray.opacity(0.2),
                            lineWidth: 2
                        )
                )
                .shadow(
                    color: canAttack && !isDefeated ? AppTheme.accentRed.opacity(0.4) : .clear,
                    radius: 12,
                    x: 0,
                    y: 6
                )
            }
            .disabled(!canAttack || isLoading || isDefeated)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            
            if !isDefeated {
                HStack(spacing: 4) {
                    Image(systemName: "bolt.fill")
                        .font(.caption2)
                        .foregroundStyle(AppTheme.accentCyan)
                    Text("Cost: \(GameConstants.attackStaminaCost) stamina")
                        .font(.caption)
                        .foregroundStyle(AppTheme.textMuted)
                    Text("•")
                        .foregroundStyle(AppTheme.textMuted)
                    Text("Available: \(stamina)")
                        .font(.caption)
                        .foregroundStyle(stamina >= GameConstants.attackStaminaCost ? AppTheme.accentCyan : AppTheme.accentRed)
                }
            }
        }
    }
}

#Preview {
    AttackButtonView(canAttack: true, stamina: 10, isLoading: false, isDefeated: false, action: {})
}
