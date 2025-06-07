//
//  ProfilePage.swift
//  Sleep
//
//  Created by hongyan199048 on 2025/6/6.
//


import SwiftUI

struct ProfilePage: View {
    @Binding var selectedTab: Destination
    
    var body: some View {
        ZStack {
            Image("dark_background_image")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                        
            VStack {
                VStack {
                    Text("Profile")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                        .padding(.top, 50.0)
                    
                    // 用户头像
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.purple)
                        .padding(.top, 20)
                    
                    Text("User Name")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.purple)
                        .padding(.top, 10)
                    
                    Text("user@example.com")
                        .font(.subheadline)
                        .foregroundColor(.purple.opacity(0.8))
                        .padding(.top, 5)
                }
                
                Spacer()
                
                // 底部导航栏
                HStack(spacing: 100) {
                    TabItem(iconName: "moon.stars.fill", text: "Story", isSelected: selectedTab == .story, onTap: {
                        selectedTab = .story
                    })
                    TabItem(iconName: "music.note", text: "Music", isSelected: selectedTab == .music, onTap: {
                        selectedTab = .music
                    })
                    TabItem(iconName: "person.fill", text: "Profile", isSelected: selectedTab == .profile, onTap: {
                        selectedTab = .profile
                    })
                }
            }
        }
    }
}
        
        
        
        

#Preview {
    ProfilePage(selectedTab: .constant(.profile))
}
