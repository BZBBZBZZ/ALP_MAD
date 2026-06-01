//
//  BuffListView.swift
//  ALP_MAD
//
//  Created by Hendrawan Saputro on 01/06/26.
//

import SwiftUI

struct BuffListView: View {
    let buffs: [BuffModel]
    
    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "sparkle")
                        .foregroundStyle(AppTheme.accentGold)
                    Text("Active Buffs")
                        .font(.headline)
                        .foregroundStyle(.white)
                    Spacer()
                    Text("\(buffs.count)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(AppTheme.accentGold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(AppTheme.accentGold.opacity(0.15))
                        )
                }
                
                ForEach(buffs) { buff in
                    HStack(spacing: 10) {
                        Image(systemName: buff.type == .damage ? "flame.fill" : "bolt.shield.fill")
                            .foregroundStyle(buff.type == .damage ? AppTheme.accentPink : AppTheme.accentCyan)
                            .frame(width: 24)
                        
                        Text(buff.displayName)
                            .font(.subheadline)
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        Text("Streak \(buff.grantedAtStreak)")
                            .font(.caption2)
                            .foregroundStyle(AppTheme.textMuted)
                    }
                    .padding(.vertical, 4)
                    
                    if buff.id != buffs.last?.id {
                        Divider()
                            .background(AppTheme.bgCardLight)
                    }
                }
            }
        }
    }
}
