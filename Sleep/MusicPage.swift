//
//  MusicPage.swift
//  Sleep
//
//  Created by hongyan199048 on 2025/6/6.
//

import SwiftUI

struct MusicPage: View {
    @Binding var selectedTab: Destination
    let onTabSelected: (Destination) -> Void
    
    var body: some View {
        ZStack {
            Image("dark_background_image")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                        
            VStack {
                VStack {
                    Text("Sleep Music")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                        .padding(.top, 50.0)
                    
                    Text("This baby' sleep music soothes minds with\nsoft melodies and calm rhythms, guiding\nlittle ones into peaceful slumber.")
                        .fontWeight(.medium)
                        .foregroundColor(.purple)
                        .padding(.top, 10.0)
                }
                
                Spacer()
                
                // 底部导航栏
                HStack(spacing: 100) {
                    TabItem(iconName: "moon.stars.fill", text: "Story", isSelected: selectedTab == .story)
                        .onTapGesture {
                            onTabSelected(.story)
                        }
                    TabItem(iconName: "music.note", text: "Music", isSelected: selectedTab == .music)
                        .onTapGesture {
                            onTabSelected(.music)
                        }
                    TabItem(iconName: "person.fill", text: "Profile", isSelected: false)
                }
            }
        }
    }
}

#Preview {
    MusicPage(selectedTab: .constant(.music), onTabSelected: { _ in })
}
