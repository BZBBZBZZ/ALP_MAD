//
//  ActivityRowView.swift
//  ALP_MAD
//
//  Created by Dave on 01/06/26.
//

import SwiftUI

struct ActivityRowView: View {
    let activity: ActivityModel
    let onComplete: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        CardView(padding: 0) {
            HStack(spacing: 0) {
                // Info Section
                VStack(alignment: .leading, spacing: 8) {
                    Text(activity.name)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .lineLimit(2)
                    
                    HStack(spacing: 12) {
                        // Rewards
                        HStack(spacing: 4) {
                            Image(systemName: "bolt.fill")
                                .font(.caption2)
                                .foregroundStyle(AppTheme.accentCyan)
                            Text("+\(activity.staminaReward)")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(AppTheme.textSecondary)
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "sparkles")
                                .font(.caption2)
                                .foregroundStyle(AppTheme.accentGold)
                            Text("+\(activity.expReward)")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(AppTheme.textSecondary)
                        }
                    }
                    
                    // Completion Count
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption2)
                            .foregroundStyle(AppTheme.accentGreen)
                        Text("Completed: \(activity.completionCount) times")
                            .font(.caption2)
                            .foregroundStyle(AppTheme.textMuted)
                    }
                    .padding(.top, 2)
                }
                .padding(16)
                
                Spacer()
                
                // Complete Button
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                        isPressed = true
                    }
                    onComplete()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isPressed = false
                    }
                } label: {
                    ZStack {
                        AppTheme.bgCardLight
                            .frame(width: 70)
                        
                        VStack(spacing: 4) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("DO")
                                .font(.caption2)
                                .fontWeight(.heavy)
                        }
                        .foregroundStyle(AppTheme.primaryColor)
                    }
                }
                .scaleEffect(isPressed ? 0.9 : 1.0)
            }
        }
        .contextMenu {
            Button {
                onEdit()
            } label: {
                Label("Edit Activity", systemImage: "pencil")
            }
            
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

#Preview {
    ActivityRowView(
        activity: ActivityModel(id: "1", userId: "test", name: "Test Activity", staminaReward: 10, expReward: 20, completionCount: 0, createdAt: Date()),
        onComplete: {},
        onEdit: {},
        onDelete: {}
    )
}
