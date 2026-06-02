//
//  WatchBossView.swift
//  ALP_MAD
//
//  Created by Hendrawan Saputro on 01/06/26.
//

import SwiftUI

struct WatchBossView: View {
    var viewModel: WatchViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            Text(viewModel.bossName)
                .font(.headline)
                .foregroundStyle(.red)
            
            VStack(spacing: 4) {
                HStack {
                    Text("HP")
                        .font(.caption2)
                        .foregroundStyle(.red)
                    Spacer()
                    Text("\(viewModel.bossCurrentHp)/\(viewModel.bossMaxHp)")
                        .font(.caption2)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule().fill(Color.gray.opacity(0.3))
                        Capsule().fill(Color.red)
                            .frame(width: max(0, geometry.size.width * CGFloat(viewModel.hpProgress)))
                    }
                }
                .frame(height: 8)
            }
            .padding(.horizontal)
            
            Spacer()
            
            Button {
                viewModel.attackBoss()
            } label: {
                if viewModel.bossIsDefeated {
                    Text("DEFEATED")
                        .fontWeight(.bold)
                        .foregroundStyle(.green)
                } else {
                    HStack {
                        Image(systemName: "bolt.fill")
                        Text("ATTACK (10)")
                    }
                    .fontWeight(.bold)
                }
            }
            .tint(viewModel.bossIsDefeated ? .gray : .red)
            .disabled(!viewModel.canAttack)
            
            HStack {
                Image(systemName: "bolt.fill")
                    .font(.caption2)
                    .foregroundStyle(.cyan)
                Text("Stamina: \(viewModel.stamina)")
                    .font(.caption2)
                    .foregroundStyle(viewModel.stamina >= 10 ? .cyan : .red)
            }
        }
        .padding()
    }
}

#Preview {
    WatchBossView(viewModel: WatchViewModel())
}
