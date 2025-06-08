//
//  StoryGuessHowMuchILoveYou.swift
//  Sleep
//
//  Created by hongyan199048 on 2025/6/8.
//

import SwiftUI
import AVFoundation

struct StoryGuessHowMuchILoveYou: View {
    // MARK: - Properties
    @State private var isPlaying = false
    @State private var volume: Float = 0.5
    @State private var timer: Timer?
    @State private var remainingTime: TimeInterval = 3600 // 默认1小时
    @State private var showTimerPicker = false
    @Environment(\.dismiss) private var dismiss
    
    // 音频播放器
    @StateObject private var audioPlayer = AudioPlayerManager()
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // 背景渐变
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "1A1A2E"),
                    Color(hex: "16213E"),
                    Color(hex: "0F3460")
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // 顶部导航栏
                HStack {
                    // 移除返回按钮
                    // Button(action: { dismiss() }) {
                    //     Image(systemName: "chevron.left")
                    //         .font(.title2)
                    //         .foregroundColor(.white)
                    // }
                    
                    Spacer()
                    
                    Text("猜猜我有多爱你")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: { /* 收藏功能 */ }) {
                        Image(systemName: "heart")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                
                // 主要内容
                VStack(spacing: 40) {
                    // 封面图片
                    Image("guess_how_much_i_love_you") // 使用甜梦的封面图片
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                        .cornerRadius(20)
                        .shadow(radius: 10)
                    
                    // 播放控制
                    HStack(spacing: 40) {
                        Button(action: { /* 上一首 */ }) {
                            Image(systemName: "backward.fill")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        
                        Button(action: {
                            isPlaying.toggle()
                            if isPlaying {
                                audioPlayer.play()
                            } else {
                                audioPlayer.pause()
                            }
                        }) {
                            Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .font(.system(size: 70))
                                .foregroundColor(.white)
                        }
                        
                        Button(action: { /* 下一首 */ }) {
                            Image(systemName: "forward.fill")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                    }
                    
                    // 音量控制
                    VStack(spacing: 10) {
                        HStack {
                            Image(systemName: "speaker.fill")
                                .foregroundColor(.white)
                            Slider(value: Binding(
                                get: { Double(volume) },
                                set: { volume = Float($0) }
                            ))
                            .accentColor(.white)
                            Image(systemName: "speaker.wave.3.fill")
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                    }
                    
                    // 定时器
                    VStack(spacing: 15) {
                        Button(action: { showTimerPicker.toggle() }) {
                            HStack {
                                Image(systemName: "timer")
                                    .foregroundColor(.white)
                                Text(timeString(from: remainingTime))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(20)
                        }
                        
                        if showTimerPicker {
                            Picker("选择时间", selection: $remainingTime) {
                                Text("30分钟").tag(TimeInterval(1800))
                                Text("1小时").tag(TimeInterval(3600))
                                Text("2小时").tag(TimeInterval(7200))
                                Text("关闭").tag(TimeInterval(0))
                            }
                            .pickerStyle(WheelPickerStyle())
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(15)
                        }
                    }
                }
                .padding()
                
                Spacer()
            }
        }
        .onAppear {
            setupAudioPlayer()
        }
        .onDisappear {
            audioPlayer.stop()
        }
    }
    
    // MARK: - Helper Methods
    private func setupAudioPlayer() {
        if let url = Bundle.main.url(forResource: "guess_how_much_i_love_you", withExtension: "mp3") {
            audioPlayer.setupPlayer(with: url)
        }
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) / 60 % 60
        if hours > 0 {
            return "\(hours)小时\(minutes)分钟"
        } else {
            return "\(minutes)分钟"
        }
    }
}

#Preview {
    StoryGuessHowMuchILoveYou()
}

