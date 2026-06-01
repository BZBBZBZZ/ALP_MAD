//
//  CharacterAvatarView.swift
//  ALP_MAD
//
//  Created by Nicholas Leroy Kurniawan on 1/6/26.
//

import SwiftUI

struct CharacterAvatarView: View {
    let user: UserModel
    @State private var glowAnimation = false
    
    var body: some View {
        CardView {
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AppTheme.primaryColor.opacity(0.2))
                        .frame(width: 120, height: 120)
                        .blur(radius: 20)
                        .scaleEffect(glowAnimation ? 1.1 : 0.9)
                    
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 90, height: 90)
                        .overlay(
                            Circle()
                                .stroke(AppTheme.accentGold.opacity(0.6), lineWidth: 3)
                        )
                    
                    Text(characterEmoji)
                        .font(.system(size: 44))
                }
                
                Text(user.username)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundStyle(AppTheme.accentGold)
                    
                    Text("Level \(user.level)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppTheme.accentGold)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(AppTheme.accentGold.opacity(0.15))
                        .overlay(
                            Capsule()
                                .stroke(AppTheme.accentGold.opacity(0.3), lineWidth: 1)
                        )
                )
            }
            .frame(maxWidth: .infinity)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                glowAnimation = true
            }
        }
    }
    
    private var characterEmoji: String {
        switch user.level {
        case 1...4: return "🧙"
        case 5...9: return "⚔️"
        case 10...14: return "🛡️"
        case 15...19: return "👑"
        default: return "🐉"
        }
    }
}
