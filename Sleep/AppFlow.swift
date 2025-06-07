//
//  AppFlow.swift
//  Sleep
//
//  Created by hongyan199048 on 2025/6/5.
//

import SwiftUI

// 定义可能的导航目的地类型
enum Destination: String, CaseIterable, Identifiable {
    case story
    case music
    case profile

    var id: String { self.rawValue }
}

struct AppFlow: View {
    @State private var selectedTab: Destination = .story
    @State private var path: [Destination] = []

    var body: some View {
        NavigationStack(path: $path) {
            StartupPage(onGetStarted: {
                path.append(.story)
            })
            .navigationDestination(for: Destination.self) { destination in
                ZStack {
                    StoryPage(selectedTab: $selectedTab)
                        .opacity(selectedTab == .story ? 1 : 0)
                    
                    MusicPage(selectedTab: $selectedTab)
                        .opacity(selectedTab == .music ? 1 : 0)
                        
                    ProfilePage(selectedTab: $selectedTab)
                        .opacity(selectedTab == .profile ? 1 : 0)
                }
            }
        }
    }
}

#Preview {
    AppFlow()
} 
