//
//  StoryPage.swift
//  Sleep
//
//  Created by hongyan199048 on 2025/6/5.
//

import SwiftUI

struct StoryPage: View {
    @Binding var selectedTab: Destination
    
    var body: some View {
        ZStack {
            // 背景图片
            // 请将 "dark_background_image" 替换为您实际的背景图片资源名称
            Image("dark_background_image")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

                     
            VStack {
                // 顶部标题区域
                VStack  {
                    Text("Sleep Stories")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                        .padding(.top, 50.0)

                    Text("Soothing bedtime stories to help you fall\ninto a deep and natural sleep")
                        .font(.body)
                        .foregroundColor(.purple.opacity(0.8))
                        .padding(.vertical, 10)
                }
            
                Spacer()
                
            // 其他故事列表
            ScrollView() {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 20),
                    GridItem(.flexible(), spacing: 20)
                ], spacing: 10) {
                    StoryCard(imageName: "night_island_image", title: "Night Island", duration: "45 MIN", type: "SLEEP MUSIC")
                    StoryCard(imageName: "sweet_sleep_image", title: "Sweet Sleep", duration: "45 MIN", type: "SLEEP MUSIC")
                    StoryCard(imageName: "forest_sound_image", title: "Forest Sound", duration: "60 MIN", type: "NATURE SOUNDS")
                    StoryCard(imageName: "rainy_day_image", title: "Rainy Day", duration: "50 MIN", type: "AMBIENCE")
                    StoryCard(imageName: "meditation_journey_image", title: "Meditation Journey", duration: "30 MIN", type: "MEDITATION")
                    StoryCard(imageName: "calm_waves_image", title: "Calm Waves", duration: "55 MIN", type: "NATURE SOUNDS")
                    StoryCard(imageName: "meditation_journey_image", title: "Meditation Journey", duration: "30 MIN", type: "MEDITATION")
                    StoryCard(imageName: "calm_waves_image", title: "Calm Waves", duration: "55 MIN", type: "NATURE SOUNDS")
                    StoryCard(imageName: "rainy_day_image", title: "Rainy Day", duration: "50 MIN", type: "AMBIENCE")
                    StoryCard(imageName: "meditation_journey_image", title: "Meditation Journey", duration: "30 MIN", type: "MEDITATION")
                    StoryCard(imageName: "calm_waves_image", title: "Calm Waves", duration: "55 MIN", type: "NATURE SOUNDS")
                    StoryCard(imageName: "meditation_journey_image", title: "Meditation Journey", duration: "30 MIN", type: "MEDITATION")
                    StoryCard(imageName: "calm_waves_image", title: "Calm Waves", duration: "55 MIN", type: "NATURE SOUNDS")
                    
                }
                .frame(width: 350)
            }
            .scrollIndicators(.hidden)
            
                Spacer() // 将底部导航栏推到底部

                // 底部导航栏
                HStack(spacing: 100) {
                    TabItem(iconName: "moon.stars.fill", text: "Story", isSelected: selectedTab == .story)
                        .onTapGesture {
                            selectedTab = .story
                        }
                    TabItem(iconName: "music.note", text: "Music", isSelected: selectedTab == .music)
                        .onTapGesture {
                            selectedTab = .music
                        }
                    TabItem(iconName: "person.fill", text: "Profile", isSelected: selectedTab == .profile)
                        .onTapGesture {
                            selectedTab = .profile
                        }
                }
              
            }
        }
    }
}

// 分类按钮的辅助视图
struct CategoryButton: View {
    let iconName: String
    let text: String

    var body: some View {
        Button(action: {
            // 分类按钮点击事件
        }) {
            VStack(spacing: 8) {
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.purple) // 根据图片调整颜色
                    .padding(15)
                    .background(Color.white.opacity(0.1)) // 根据图片调整颜色和透明度
                    .clipShape(Circle())

                Text(text)
                    .font(.caption)
                    .foregroundColor(.purple)
            }
        }
    }
}

// 精选故事卡片的辅助视图
struct FeaturedStoryCard: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // 卡片背景图片
            // 请将 "ocean_moon_image" 替换为您实际的图片资源名称
            Image("ocean_moon_image")
                .resizable()
                .scaledToFill()
                .frame(height: 200) // 调整高度
                .cornerRadius(15)
                .clipped()

            VStack(alignment: .leading) {
                // 锁图标
                Image(systemName: "lock.fill")
                    .foregroundColor(.white)
                    .padding(5)
                    .background(Color.black.opacity(0.3))
                    .clipShape(Circle())
                    .padding(.bottom, 5)

                Text("The Ocean Moon")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)

                Text("Non-stop 8- hour mixes of our\nmost popular sleep audio")
                    .font(.caption)
                    .foregroundColor(.purple.opacity(0.9))

                Button(action: {
                    // START 按钮点击事件
                }) {
                    Text("START")
                        .font(.headline)
                        .foregroundColor(.purple) // Button text should be purple based on instruction
                        .padding(.vertical, 8)
                        .padding(.horizontal, 20)
                        .background(Color.white)
                        .cornerRadius(20)
                }
                .padding(.top, 10)
            }
            .padding()
        }
        .frame(height: 200) // 确保 ZStack 本身的高度
    }
}

// 其他故事卡片的辅助视图
struct StoryCard: View {
    let imageName: String
    let title: String
    let duration: String
    let type: String

    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            // 故事图片
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 100) // 调整大小
                .cornerRadius(10)
                .clipped()

            Text(title)
                .font(.headline)
                .foregroundColor(.purple)

            Text("\(duration) • \(type)")
                .font(.caption2)
                .foregroundColor(.purple.opacity(0.7))
        }
        .frame(width: 150) // 确保 VStack 的宽度
    }
}

// 底部导航栏项目的辅助视图
struct TabItem: View {
    let iconName: String
    let text: String
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(isSelected ? .purple : .gray)

            Text(text)
                .font(.caption2)
                .foregroundColor(.purple)
        }
    }
}

#Preview {
    StoryPage(selectedTab: .constant(.story))
}

