//
//  AnimatedButtonView.swift
//  SwiftUIExample
//
//  Created by 한태희 on 2024/01/22.
//

import SwiftUI

struct AnimatedButtonView: View {
    @State private var isSucess: Bool = true
    
    var body: some View {
        VStack(spacing: 30) {
            Toggle("성공여부", isOn: $isSucess)
                .frame(width: 120)
            AnimatedButton(tint: .purple) {
                Text("Animated Button")
            } action: {
                /// 테스트를 위해 2초가 소요되는 작업이 진행되었다고 가정
                try? await Task.sleep(for: .seconds(2))
                /// 토글에 따라 성공 여부를 가정
                return isSucess ? .success : .failed
            }
        }
    }
}

struct AnimatedButtonView_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedButtonView()
    }
}
