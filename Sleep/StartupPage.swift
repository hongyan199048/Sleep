//
//  ContentView.swift
//  Sleep
//
//  Created by hongyan199048 on 2025/6/4.
//

import SwiftUI

struct StartupPage: View {
    // 添加一个闭包属性，用于在按钮点击时执行外部传入的动作
    var onGetStarted: () -> Void

    var body: some View {
        ZStack {
            // Background image
            // 请将 "background_image" 替换为您实际的背景图片资源名称
            Image("background_image")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            // VStack 是垂直堆栈视图，用于将子视图垂直排列
            // Spacer() 是一个弹性空间，会占用所有可用的空间，将其他视图推到顶部或底部
            VStack {
                Spacer()

                // Title
                Text("Welcome to Sleep")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)

                // Description
                Text("Explore the new kinds of sleep. It uses sound\nand visualization to create perfect conditions\nfor refreshing sleep.")
                    .font(.body)
                    .foregroundColor(.purple)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                    .lineSpacing(8)

                Spacer()

                // Illustration image
                // 请将 "birds_illustration_name" 替换为您实际的鸟插图图片资源名称
                Image("birds_illustration_name")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200) // Adjust height as needed

                Spacer()

                // Get Started Button
                Button(action: {
                    // 调用外部传入的动作
                    onGetStarted()
                }) {
                    Text("GET STARTED")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 300, height: 60)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.purple)
                        )
                }
                .padding(.bottom, 80)
            }
        }
    }
}

#Preview {
    StartupPage(onGetStarted: {})
}
