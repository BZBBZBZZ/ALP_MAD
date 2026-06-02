//
//  WatchActivityView.swift
//  watch-os Watch App
//
//  Created by Dave on 01/06/26.
//

import SwiftUI

struct WatchActivityItem: Identifiable {
    let id: String
    let name: String
    let staminaReward: Int
}

struct WatchActivityView: View {
    var viewModel: WatchViewModel
    
    private var mappedActivities: [WatchActivityItem] {
        viewModel.activities.compactMap { dict in
            guard let id = dict["id"] as? String,
                  let name = dict["name"] as? String,
                  let staminaReward = dict["staminaReward"] as? Int else { return nil }
            return WatchActivityItem(id: id, name: name, staminaReward: staminaReward)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if mappedActivities.isEmpty {
                    Text("No activities yet.\nCreate them on iPhone.")
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(mappedActivities) { activity in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(activity.name)
                                        .font(.caption)
                                        .lineLimit(2)
                                    Text("+\(activity.staminaReward) Stamina")
                                        .font(.caption2)
                                        .foregroundStyle(.cyan)
                                }
                                
                                Spacer()
                                
                                Button {
                                    viewModel.completeActivity(id: activity.id)
                                } label: {
                                    Image(systemName: "plus")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.green)
                                }
                                .buttonStyle(.borderless)
                                .frame(width: 40, height: 40)
                                .background(Circle().fill(Color.green.opacity(0.2)))
                            }
                        }
                    }
                }
            }
            .navigationTitle("Quests")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 2) {
                        Image(systemName: "bolt.fill")
                            .foregroundStyle(.cyan)
                        Text("\(viewModel.stamina)")
                            .fontWeight(.bold)
                            .foregroundStyle(.cyan)
                    }
                }
            }
        }
    }
}


#Preview {
    WatchActivityView(viewModel: WatchViewModel())
}
