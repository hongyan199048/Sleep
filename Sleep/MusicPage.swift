//
//  MusicPage.swift
//  Sleep
//
//  Created by hongyan199048 on 2025/6/6.
//

import SwiftUI
import UIKit // 新增：引入UIKit框架

// 音乐卡片数据模型
struct Card: Identifiable {
    let id = UUID()
    let title: String        // 音乐标题
    let duration: String     // 音乐时长
    let type: String         // 音乐类型
    let imageName: String    // 音乐封面图片
}

struct MusicPage: View {
    @Binding var selectedTab: Destination  // 绑定当前选中的标签页
    @State private var showNightIsland = false
    @State private var showRainDay = false
    @State private var showForestSound = false
    @State private var showSweetSleep = false
    
    // 触感反馈生成器 - 用于提供滑动时的触觉反馈
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    // 卡片轮播相关的状态变量
    @State private var currentIndex: CGFloat = 0  // 当前显示的卡片索引
    @State private var dragOffset: CGFloat = 0    // 拖拽偏移量
    @State private var isDragging = false  // 添加拖动状态
    
    // 卡片布局参数配置
    private let cardWidth: CGFloat = 200          // 卡片宽度
    private let cardHeight: CGFloat = 250         // 卡片高度
    private let spacing: CGFloat = 100            // 卡片间距
    private let curveDepth: CGFloat = 100         // 卡片下沉深度
    private let scaleFactor: CGFloat = 0.3        // 缩放因子
    private let maxScaleReduction: CGFloat = 0.7  // 最大缩放比例
    private let maxRotationAngle: Double = -25    // 最大旋转角度
    private let snapThresholdRatio: CGFloat = 0.2 // 吸附阈值比例
    
    // 音乐卡片数据数组
    let cards: [Card] = [
        Card(title: "Night Island", duration: "45 MIN", type: "SLEEP MUSIC", imageName: "card_image_1"),
        Card(title: "Sweet Sleep", duration: "45 MIN", type: "SLEEP MUSIC", imageName: "card_image_2"),
        Card(title: "Forest Sound", duration: "60 MIN", type: "NATURE SOUNDS", imageName: "card_image_3"),
        Card(title: "Rainy Day", duration: "50 MIN", type: "AMBIENCE", imageName: "card_image_4")
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
                
                // 卡片轮播区域
                GeometryReader { geometry in
                    let width = geometry.size.width
                    let liveCurrentIndex = currentIndex - (dragOffset / (cardWidth + spacing))
                    
                    HStack(spacing: spacing) {
                        ForEach(cards) { card in
                            CardView(card: card, 
                                   cardWidth: cardWidth, 
                                   cardHeight: cardHeight,
                                   onCardTap: { tappedCard in
                                       if !isDragging {
                                           switch tappedCard.title {
                                           case "Night Island":
                                               showNightIsland = true
                                           case "Rainy Day":
                                               showRainDay = true
                                           case "Forest Sound":
                                               showForestSound = true
                                           case "Sweet Sleep":
                                               showSweetSleep = true
                                           default:
                                               break
                                           }
                                       }
                                   })
                                .frame(width: cardWidth, height: cardHeight)
                                .scaleEffect(scale(for: card, centerIndex: liveCurrentIndex))
                                .offset(y: offset(for: card, centerIndex: liveCurrentIndex))
                                .rotation3DEffect(
                                    .degrees(rotationAngle(for: card, centerIndex: liveCurrentIndex)),
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
                                        targetIndex = min(CGFloat(cards.count - 1), currentIndex + 1)
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
        .navigationDestination(isPresented: $showNightIsland) {
            MusicNightIsland()
        }
        .navigationDestination(isPresented: $showRainDay) {
            MusicRainDay()
        }
        .navigationDestination(isPresented: $showForestSound) {
            MusicForestSound()
        }
        .navigationDestination(isPresented: $showSweetSleep) {
            MusicSweetSleep()
        }
    }
    
    // 计算卡片缩放比例
    private func scale(for card: Card, centerIndex: CGFloat) -> CGFloat {
        let index = CGFloat(cards.firstIndex(where: { $0.id == card.id }) ?? 0)
        let distance = abs(index - centerIndex)
        return 1.0 - min(distance * scaleFactor, maxScaleReduction)
    }
    
    // 计算卡片垂直偏移量
    private func offset(for card: Card, centerIndex: CGFloat) -> CGFloat {
        let index = CGFloat(cards.firstIndex(where: { $0.id == card.id }) ?? 0)
        let distance = abs(index - centerIndex)
        return -distance * curveDepth
    }
    
    // 计算卡片旋转角度
    private func rotationAngle(for card: Card, centerIndex: CGFloat) -> Double {
        let index = CGFloat(cards.firstIndex(where: { $0.id == card.id }) ?? 0)
        let distance = index - centerIndex
        return Double(distance) * maxRotationAngle
    }
}

// 添加 CGPoint 扩展
extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        let dx = self.x - point.x
        let dy = self.y - point.y
        return sqrt(dx * dx + dy * dy)
    }
}

// 音乐卡片视图组件
struct CardView: View {
    let card: Card
    let cardWidth: CGFloat
    let cardHeight: CGFloat
    let onCardTap: (Card) -> Void
    
    @State private var dragStartTime: Date?
    @State private var dragStartLocation: CGPoint?
    @State private var isDragging = false
    @State private var isPressed = false  // 添加按压状态
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image(card.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: cardWidth, height: cardHeight)
                .clipped()
            
            VStack(spacing: 5) {
                Text(card.title)
                    .font(.title3)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                
                Text("\(card.duration) • \(card.type)")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.bottom, 10)
            }
            .frame(width: cardWidth)
            .background(.ultraThinMaterial)
            .background(Color.purple.opacity(0.5))
        }
        .cornerRadius(10)
        .shadow(radius: isPressed ? 5 : 10)  // 按压时减小阴影
        .scaleEffect(isPressed ? 0.95 : 1.0)  // 按压时缩小
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)  // 添加弹性动画
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
                            isPressed = false  // 如果是拖动，取消按压状态
                        } else {
                            isPressed = true  // 如果是点击，设置按压状态
                        }
                    }
                }
                .onEnded { value in
                    let dragDuration = Date().timeIntervalSince(dragStartTime ?? Date())
                    let dragDistance = dragStartLocation?.distance(to: value.location) ?? 0
                    
                    if !isDragging && dragDistance < 10 && dragDuration < 0.2 {
                        // 添加触觉反馈
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                        
                        // 延迟执行点击回调，等待动画完成
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            onCardTap(card)
                        }
                    }
                    
                    // 重置所有状态
                    dragStartTime = nil
                    dragStartLocation = nil
                    isDragging = false
                    isPressed = false
                }
        )
    }
}

#Preview {
    MusicPage(selectedTab: .constant(.music))
}
