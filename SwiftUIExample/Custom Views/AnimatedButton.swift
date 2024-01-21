//
//  AnimatedButton.swift
//  SwiftUIExample
//
//  Created by 한태희 on 2024/01/22.
//

import SwiftUI

struct AnimatedButton<ButtonContent: View>: View {
    var tint: Color = .white
    var content: () -> ButtonContent
    var action: () async -> Status
    
    /// 로딩 상태 표시를 위한 상태 값
    @State private var isLoading: Bool = false
    /// 실패 분기를 위한 상태 값
    @State private var isFailed: Bool = false
    /// 작업 수행 상태에 대한 상태 값
    @State private var status: Status = .idle
    
    
    var body: some View {
        Button {
            Task {
                /// 동작을 수행하기 직전에 로딩 상태로 변경
                isLoading = true
                /// 주어진 동작 수행
                let status = await action()
                
                /// 동작 수행이 끝나고 성공 및 실패 여부를 isFailed에 저장
                isFailed = status == .failed ?  true : false
                /// 버튼 상태를 status로 설정
                self.status = status
                
                /// 0.5초 간 성공 및 실패 여부를 유지한 후 idle 상태로 복귀
                try? await Task.sleep(for: .seconds(0.5))
                self.status = .idle
                
                /// 모든 작업이 끝난 후 로딩 상태 해제
                isLoading = false
            }
        } label: {
            content()
                /// tint 색상을 지정하면 글자 색을 흰색으로 고정
                .foregroundColor(tint == .white ? nil : .white)
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                /// 로딩 중에는 기존 view를 숨김
                .opacity(isLoading ? 0 : 1)
                /// 텍스트가 개행되는 것을 막음
                .lineLimit(1)
                /// 로딩 중에는 버튼 사이즈를 50x50으로 고정
                .frame(width: isLoading ? 50 : nil, height: isLoading ? 50 : nil)
                /// status에 따라 버튼 배경색을 지정
                .background(Color(status == .idle ? UIColor(tint) : status == .success ? .systemMint : .systemRed).shadow(.drop(color: .gray.opacity(0.2), radius: 6)), in: Capsule())
                /// 로딩 중이면서 idle 상태일 때는 ProgressView를 나타냄
                .overlay {
                    if isLoading && status == .idle {
                        ProgressView()
                    }
                }
                /// 실패 시에는 느낌표 이미지를 나타내고 성공 시에는 체크마크 이미지를 나타냄
                .overlay{
                    if status != .idle {
                        Image(systemName: isFailed ? "exclamationmark" : "checkmark")
                            .fontWeight(.black)
                            .foregroundStyle(.white)
                    }
                }
        }
        /// 로딩 중에는 버튼을 비활성화
        .disabled(isLoading)
        /// 상태 값 변경 시에 애니메이션을 추가해서 부드럽게 전환
        .animation(.easeInOut, value: isLoading)
        .animation(.easeInOut, value: status)
    }
}

enum Status: Equatable {
    case idle
    case failed
    case success
}

struct AnimatedButton_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

