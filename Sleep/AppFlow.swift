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

    var id: String { self.rawValue }
}

struct AppFlow: View {
    // 使用一个数组作为导航路径的状态变量
    @State private var path: [Destination] = []
    @State private var selectedTab: Destination = .story

    var body: some View {
        // 使用 NavigationStack 并绑定路径
        NavigationStack(path: $path) {
            // 导航的根视图是 StartupPage
            StartupPage(onGetStarted: {
                // 当 StartupPage 的按钮点击时，将 .story 目的地添加到路径中，触发导航
                path.append(.story)
            })
            // 定义当特定类型的目的地出现在路径中时，应该显示哪个视图
            .navigationDestination(for: Destination.self) { destination in
                switch destination {
                case .story:
                    StoryPage(selectedTab: $selectedTab, onTabSelected: { newTab in
                        selectedTab = newTab
                        if newTab != .story {
                            path.append(newTab)
                        }
                    })
                case .music:
                    MusicPage(selectedTab: $selectedTab, onTabSelected: { newTab in
                        selectedTab = newTab
                        if newTab != .music {
                            path.append(newTab)
                        }
                    })
                }
            }
        }
    }
}

#Preview {
    AppFlow()
} 
