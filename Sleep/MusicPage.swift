//
//  MusicPage.swift
//  Sleep
//
//  Created by hongyan199048 on 2025/6/6.
//

import SwiftUI

struct Card: Identifiable {
    let id = UUID()
    let title: String
    let color: Color
}

struct MusicPage: View {
    @Binding var selectedTab: Destination
    
    @State private var currentIndex: CGFloat = 0
    @State private var dragOffset: CGFloat = 0
    
    // 控制卡片的大小和间距
    private let cardWidth: CGFloat = 150
    private let cardHeight: CGFloat = 200
    private let spacing: CGFloat = 100 //卡片间距
    private let curveDepth: CGFloat = 100 // 新增：控制圆弧的深度
    private let scaleFactor: CGFloat = 0.3 // 新增：控制卡片缩放的速度
    private let maxScaleReduction: CGFloat = 0.7 // 新增：控制卡片缩放的最大幅度
    private let maxRotationAngle: Double = -25 // 新增：控制卡片旋转的最大角度
    private let snapThresholdRatio: CGFloat = 0.2 // 新增：控制滑动吸附的灵敏度 (0.0 到 1.0之间)
    
    let cards: [Card] = [
        Card(title: "音乐 1", color: .purple.opacity(0.8)),
        Card(title: "音乐 2", color: .purple.opacity(0.8)),
        Card(title: "音乐 3", color: .purple.opacity(0.8)),
        Card(title: "音乐 4", color: .purple.opacity(0.8))
    ]
    
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
                
                GeometryReader { geometry in
                    let width = geometry.size.width
                    // 计算实时的中心索引
                    let liveCurrentIndex = currentIndex - (dragOffset / (cardWidth + spacing))
                    
                    HStack(spacing: spacing) {
                        ForEach(cards) { card in
                            CardView(card: card)
                                .frame(width: cardWidth, height: cardHeight)
                                .scaleEffect(scale(for: card, centerIndex: liveCurrentIndex))
                                .offset(y: offset(for: card, centerIndex: liveCurrentIndex))
                                .rotation3DEffect(
                                    .degrees(rotationAngle(for: card, centerIndex: liveCurrentIndex)),
                                    axis: (x: 0, y: 0, z: 1) // 沿着Z轴旋转
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
                                    if dragDistance < 0 { // 向左滑动
                                        targetIndex = min(CGFloat(cards.count - 1), currentIndex + 1)
                                    } else { // 向右滑动
                                        targetIndex = max(0, currentIndex - 1)
                                    }
                                }
                                
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    currentIndex = targetIndex
                                    dragOffset = 0
                                }
                            }
                    )
                }
                .padding(.bottom, 200.0)
                .frame(height: 200) // 确保GeometryReader有固定高度
                
                Spacer()
                
                
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
    
    private func scale(for card: Card, centerIndex: CGFloat) -> CGFloat {
        let index = CGFloat(cards.firstIndex(where: { $0.id == card.id }) ?? 0)
        let distance = abs(index - centerIndex)
        return 1.0 - min(distance * scaleFactor, maxScaleReduction)
    }
    
    private func offset(for card: Card, centerIndex: CGFloat) -> CGFloat {
        let index = CGFloat(cards.firstIndex(where: { $0.id == card.id }) ?? 0)
        let distance = abs(index - centerIndex) // 这里使用abs是为了对称下沉效果
        return -distance * curveDepth // 使用 curveDepth
    }
    
    private func rotationAngle(for card: Card, centerIndex: CGFloat) -> Double {
        let index = CGFloat(cards.firstIndex(where: { $0.id == card.id }) ?? 0)
        let distance = index - centerIndex // 这里的 distance 不用abs，需要方向
        // 根据距离和方向计算旋转角度
        return Double(distance) * maxRotationAngle
    }
}

struct CardView: View {
    let card: Card
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(card.color)
            .overlay(
                Text(card.title)
                    .font(.title)
                    .foregroundColor(.white)
            )
            .shadow(radius: 10)
    }
}

#Preview {
    MusicPage(selectedTab: .constant(.music))
}
