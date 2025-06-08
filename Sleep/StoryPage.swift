//
//  StoryPage.swift
//  Sleep
//
//  Created by hongyan199048 on 2025/6/5.
//

import SwiftUI
import UIKit // 新增：引入UIKit框架

struct StoryPage: View {
    @Binding var selectedTab: Destination  // 绑定当前选中的标签页
    
    // 触感反馈生成器 - 用于提供滑动时的触觉反馈
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    // 卡片轮播相关的状态变量
    @State private var currentIndex: CGFloat = 0  // 当前显示的卡片索引
    @State private var dragOffset: CGFloat = 0    // 拖拽偏移量
    @State private var isDragging = false  // 添加拖动状态
    
    // 导航状态变量
    @State private var showGuessHowMuchILoveYou = false
    @State private var showRabbitWantsToSleep = false
    @State private var showElephantAndPiggie = false
    @State private var showVeryHungryCaterpillar = false
    @State private var showLittleHouse = false
    @State private var showGoodnightMoon = false
    @State private var showMoonGoodnight = false
    @State private var showLittleBlueYellow = false
    @State private var showMouseDream = false
    @State private var showLittlePrince = false
    
    // 卡片布局参数配置
    private let cardWidth: CGFloat = 200          // 卡片宽度
    private let cardHeight: CGFloat = 250         // 卡片高度
    private let spacing: CGFloat = 100            // 卡片间距
    private let curveDepth: CGFloat = 100         // 卡片下沉深度
    private let scaleFactor: CGFloat = 0.3        // 缩放因子
    private let maxScaleReduction: CGFloat = 0.7  // 最大缩放比例
    private let maxRotationAngle: Double = -25    // 最大旋转角度
    private let snapThresholdRatio: CGFloat = 0.1 // 吸附阈值比例
    
    let stories: [Story] = [
        Story(imageName: "guess_how_much_i_love_you", title: "猜猜我有多爱你", duration: "10 MIN", type: "睡前故事"),
        Story(imageName: "rabbit_wants_to_sleep", title: "小兔子睡不着", duration: "15 MIN", type: "睡眠引导"),
        Story(imageName: "elephant_and_piggie", title: "小象波波", duration: "10 MIN", type: "友情故事"),
        Story(imageName: "very_hungry_caterpillar", title: "好饿的毛毛虫", duration: "8 MIN", type: "成长故事"),
        Story(imageName: "little_house", title: "小房子", duration: "12 MIN", type: "生活故事"),
        Story(imageName: "goodnight_moon", title: "晚安，月亮", duration: "5 MIN", type: "睡前故事"),
        Story(imageName: "moon_goodnight", title: "月亮，晚安", duration: "8 MIN", type: "睡前故事"),
        Story(imageName: "little_blue_yellow", title: "小蓝和小黄", duration: "6 MIN", type: "颜色认知"),
        Story(imageName: "mouse_dream", title: "小老鼠的梦想", duration: "12 MIN", type: "梦想故事"),
        Story(imageName: "little_prince", title: "小王子", duration: "20 MIN", type: "哲理故事")
    ]
    
    var body: some View {
        ZStack {
            // 背景图片层
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
                
                // 卡片轮播区域
                GeometryReader { geometry in
                    let width = geometry.size.width
                    let liveCurrentIndex = currentIndex - (dragOffset / (cardWidth + spacing))
                    
                    HStack(spacing: spacing) {
                        ForEach(stories) { story in
                            StoryCard(story: story, 
                                    cardWidth: cardWidth, 
                                    cardHeight: cardHeight,
                                    onCardTap: { tappedStory in
                                        if !isDragging {
                                            switch tappedStory.title {
                                            case "猜猜我有多爱你":
                                                showGuessHowMuchILoveYou = true
                                            case "小兔子睡不着":
                                                showRabbitWantsToSleep = true
                                            case "小象波波":
                                                showElephantAndPiggie = true
                                            case "好饿的毛毛虫":
                                                showVeryHungryCaterpillar = true
                                            case "小房子":
                                                showLittleHouse = true
                                            case "晚安，月亮":
                                                showGoodnightMoon = true
                                            case "月亮，晚安":
                                                showMoonGoodnight = true
                                            case "小蓝和小黄":
                                                showLittleBlueYellow = true
                                            case "小老鼠的梦想":
                                                showMouseDream = true
                                            case "小王子":
                                                showLittlePrince = true
                                            default:
                                                break
                                            }
                                        }
                                    })
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
                                isDragging = true
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
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    isDragging = false
                                }
                            }
                    )
                }
                .padding(.bottom, 200.0)
                .frame(height: 200)
                
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
        .navigationDestination(isPresented: $showGuessHowMuchILoveYou) {
            StoryGuessHowMuchILoveYou()
        }
        .navigationDestination(isPresented: $showRabbitWantsToSleep) {
            StoryRabbitWantsToSleep()
        }
        .navigationDestination(isPresented: $showElephantAndPiggie) {
            StoryElephantAndPiggie()
        }
        .navigationDestination(isPresented: $showVeryHungryCaterpillar) {
            StoryVeryHungryCaterpillar()
        }
        .navigationDestination(isPresented: $showLittleHouse) {
            StoryLittleHouse()
        }
        .navigationDestination(isPresented: $showGoodnightMoon) {
            StoryGoodnightMoon()
        }
        .navigationDestination(isPresented: $showMoonGoodnight) {
            StoryMoonGoodnight()
        }
        .navigationDestination(isPresented: $showLittleBlueYellow) {
            StoryLittleBlueYellow()
        }
        .navigationDestination(isPresented: $showMouseDream) {
            StoryMouseDream()
        }
        .navigationDestination(isPresented: $showLittlePrince) {
            StoryLittlePrince()
        }
    }
    
    // 计算卡片缩放比例
    private func scale(for story: Story, centerIndex: CGFloat) -> CGFloat {
        let index = CGFloat(stories.firstIndex(where: { $0.id == story.id }) ?? 0)
        let distance = abs(index - centerIndex)
        return 1.0 - min(distance * scaleFactor, maxScaleReduction)
    }
    
    // 计算卡片垂直偏移量
    private func offset(for story: Story, centerIndex: CGFloat) -> CGFloat {
        let index = CGFloat(stories.firstIndex(where: { $0.id == story.id }) ?? 0)
        let distance = abs(index - centerIndex)
        return -distance * curveDepth
    }
    
    // 计算卡片旋转角度
    private func rotationAngle(for story: Story, centerIndex: CGFloat) -> Double {
        let index = CGFloat(stories.firstIndex(where: { $0.id == story.id }) ?? 0)
        let distance = index - centerIndex
        return Double(distance) * maxRotationAngle
    }
}

// 故事数据模型
struct Story: Identifiable {
    let id = UUID()
    let imageName: String    // 故事封面图片
    let title: String        // 故事标题
    let duration: String     // 故事时长
    let type: String         // 故事类型
}

// 分类按钮组件
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

// 精选故事卡片组件
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

// 故事卡片组件
struct StoryCard: View {
    let story: Story
    let cardWidth: CGFloat
    let cardHeight: CGFloat
    let onCardTap: (Story) -> Void
    
    @State private var dragStartTime: Date?
    @State private var dragStartLocation: CGPoint?
    @State private var isDragging = false
    @State private var isPressed = false
    
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
            .background(.ultraThinMaterial)
            .background(Color.purple.opacity(0.5))
        }
        .cornerRadius(10)
        .shadow(radius: isPressed ? 5 : 10)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    if dragStartTime == nil {
                        dragStartTime = Date()
                        dragStartLocation = value.location
                    }
                    
                    if let startLocation = dragStartLocation {
                        let dragDistance = startLocation.distance(to: value.location)
                        if dragDistance > 10 {
                            isDragging = true
                            isPressed = false
                        } else {
                            isPressed = true
                        }
                    }
                }
                .onEnded { value in
                    let dragDuration = Date().timeIntervalSince(dragStartTime ?? Date())
                    let dragDistance = dragStartLocation?.distance(to: value.location) ?? 0
                    
                    if !isDragging && dragDistance < 10 && dragDuration < 0.2 {
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            onCardTap(story)
                        }
                    }
                    
                    dragStartTime = nil
                    dragStartLocation = nil
                    isDragging = false
                    isPressed = false
                }
        )
    }
}

// 底部导航栏项目组件
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
                .foregroundColor(isSelected ? .purple : .gray)
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

//test
