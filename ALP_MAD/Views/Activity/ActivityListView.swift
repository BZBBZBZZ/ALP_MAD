//
//  ActivityListView.swift
//  ALP_MAD
//
//  Created by Dave on 01/06/26.
//

import SwiftUI

struct ActivityListView: View {
    let userId: String
    @State private var viewModel = ActivityViewModel()
    
    var body: some View {
        ZStack {
            AppTheme.bgDark.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Daily Activities")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Button {
                        viewModel.prepareAdd()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(AppTheme.primaryColor)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 8)
                
                if viewModel.isLoading && viewModel.activities.isEmpty {
                    Spacer()
                    ProgressView()
                        .tint(AppTheme.primaryColor)
                        .scaleEffect(1.5)
                    Spacer()
                } else if viewModel.activities.isEmpty {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "list.bullet.clipboard")
                            .font(.system(size: 60))
                            .foregroundStyle(AppTheme.textMuted)
                        Text("No activities yet")
                            .font(.headline)
                            .foregroundStyle(.white)
                        Text("Create routines to earn stamina & EXP!")
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.textSecondary)
                            .multilineTextAlignment(.center)
                        
                        Button {
                            viewModel.prepareAdd()
                        } label: {
                            Text("Create First Activity")
                                .fontWeight(.semibold)
                                .foregroundStyle(AppTheme.bgDark)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(Capsule().fill(AppTheme.primaryColor))
                        }
                        .padding(.top, 8)
                    }
                    .padding()
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.activities) { activity in
                                ActivityRowView(
                                    activity: activity,
                                    onComplete: {
                                        Task { await viewModel.completeActivity(activity: activity, userId: userId) }
                                    },
                                    onEdit: {
                                        viewModel.prepareEdit(activity: activity)
                                    },
                                    onDelete: {
                                        Task { await viewModel.deleteActivity(activity: activity) }
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadActivities(userId: userId)
        }
        .onDisappear {
            viewModel.cleanup()
        }
        .sheet(isPresented: $viewModel.showAddSheet) {
            AddActivityView(viewModel: viewModel, userId: userId)
        }
        .sheet(isPresented: $viewModel.showEditSheet) {
            EditActivityView(viewModel: viewModel)
        }
    }
}
