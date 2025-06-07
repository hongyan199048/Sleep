//
//  StoryPage.swift
//  Sleep
//
//  Created by hongyan199048 on 2025/6/5.
//

import SwiftUI
import UIKit // 新增：引入UIKit框架

struct StoryPage: View {
    @Binding var selectedTab: Destination
    
    // 触感反馈生成器
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    @State private var currentIndex: CGFloat = 0
    @State private var dragOffset: CGFloat = 0
    
    // 控制卡片的大小和间距
    private let cardWidth: CGFloat = 200
    private let cardHeight: CGFloat = 250
    private let spacing: CGFloat = 100
    private let curveDepth: CGFloat = 100
    private let scaleFactor: CGFloat = 0.3
    private let maxScaleReduction: CGFloat = 0.7
    private let maxRotationAngle: Double = -25
    private let snapThresholdRatio: CGFloat = 0.2
    
    let stories: [Story] = [
        Story(imageName: "night_island_image", title: "Night Island", duration: "45 MIN", type: "SLEEP MUSIC"),
        Story(imageName: "sweet_sleep_image", title: "Sweet Sleep", duration: "45 MIN", type: "SLEEP MUSIC"),
        Story(imageName: "forest_sound_image", title: "Forest Sound", duration: "60 MIN", type: "NATURE SOUNDS"),
        Story(imageName: "rainy_day_image", title: "Rainy Day", duration: "50 MIN", type: "AMBIENCE"),
        Story(imageName: "meditation_journey_image", title: "Meditation Journey", duration: "30 MIN", type: "MEDITATION"),
        Story(imageName: "calm_waves_image", title: "Calm Waves", duration: "55 MIN", type: "NATURE SOUNDS")
    ]
    
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
                
                GeometryReader { geometry in
                    let width = geometry.size.width
                    let liveCurrentIndex = currentIndex - (dragOffset / (cardWidth + spacing))
                    
                    HStack(spacing: spacing) {
                        ForEach(stories) { story in
                            StoryCard(story: story, cardWidth: cardWidth, cardHeight: cardHeight)
                                .frame(width: cardWidth, height: cardHeight)
                                .scaleEffect(scale(for: story, centerIndex: liveCurrentIndex))
                                .offset(y: offset(for: story, centerIndex: liveCurrentIndex))
                                .rotation3DEffect(
                                    .degrees(rotationAngle(for: story, centerIndex: liveCurrentIndex)),
                                    axis: (x: 0, y: 0, z: 1)
                                )
                        }
                    }
                    .padding(.horizontal, (width - cardWidth) / 2)
                    .offset(x: -CGFloat(currentIndex) * (cardWidth + spacing) + dragOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragOffset = value.translation.width
                            }
                            .onEnded { value in
                                let totalCardWidth = cardWidth + spacing
                                let dragDistance = value.translation.width
                                
                                var targetIndex = currentIndex
                                if abs(dragDistance) > totalCardWidth * snapThresholdRatio {
                                    if dragDistance < 0 {
                                        targetIndex = min(CGFloat(stories.count - 1), currentIndex + 1)
                                    } else {
                                        targetIndex = max(0, currentIndex - 1)
                                    }
                                }
                                
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    currentIndex = targetIndex
                                    dragOffset = 0
                                    feedbackGenerator.impactOccurred()
                                }
                            }
                    )
                }
                .padding(.bottom, 200.0)
                .frame(height: 200)
                
                Spacer() // 将底部导航栏推到底部

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
    
    private func scale(for story: Story, centerIndex: CGFloat) -> CGFloat {
        let index = CGFloat(stories.firstIndex(where: { $0.id == story.id }) ?? 0)
        let distance = abs(index - centerIndex)
        return 1.0 - min(distance * scaleFactor, maxScaleReduction)
    }
    
    private func offset(for story: Story, centerIndex: CGFloat) -> CGFloat {
        let index = CGFloat(stories.firstIndex(where: { $0.id == story.id }) ?? 0)
        let distance = abs(index - centerIndex)
        return -distance * curveDepth
    }
    
    private func rotationAngle(for story: Story, centerIndex: CGFloat) -> Double {
        let index = CGFloat(stories.firstIndex(where: { $0.id == story.id }) ?? 0)
        let distance = index - centerIndex
        return Double(distance) * maxRotationAngle
    }
}

struct Story: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let duration: String
    let type: String
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
    let story: Story
    let cardWidth: CGFloat
    let cardHeight: CGFloat
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image(story.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: cardWidth, height: cardHeight)
                .clipped()
            
            VStack {
                Text(story.title)
                    .font(.title3)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                
                Text("\(story.duration) • \(story.type)")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.bottom, 10)
            }
            .frame(width: cardWidth)
            .background(Color.purple)
        }
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

// 底部导航栏项目的辅助视图
struct TabItem: View {
    let iconName: String
    let text: String
    let isSelected: Bool
    let onTap: () -> Void  // 添加点击回调
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)

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
        .onTapGesture {
            feedbackGenerator.impactOccurred()
            onTap()  // 调用回调函数
        }
    }
}

#Preview {
    StoryPage(selectedTab: .constant(.story))
}

