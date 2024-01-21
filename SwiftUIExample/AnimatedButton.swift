//
//  AnimatedButton.swift
//  SwiftUIExample
//
//  Created by 한태희 on 2024/01/22.
//

import SwiftUI

struct AnimatedButton<ButtonContent: View>: View {
    var content: () -> ButtonContent
    var action: () async -> Status
    
    /// 로딩 상태 표시를 위한 상태 값
    @State private var isLoading: Bool = false
    /// 실패 분기를 위한 상태 값
    @State private var isFailed: Bool = false
    /// 실패 시 팝업을 위한 상태 값
    @State private var showPopup: Bool = false
    /// 실패 메시지
    @State private var message: String = ""
    /// 작업 수행 상태에 대한 상태 값
    @State private var status: Status = .idle
    
    
    var body: some View {
        Button {
            Task {
                isLoading = true
                let status = await action()
                
                switch status {
                case .idle:
                    isFailed = false
                case .failed(let error):
                    isFailed = true
                    message = error
                case .success:
                    isFailed = false
                }
                
                self.status = status
                try? await Task.sleep(for: .seconds(0.5))
                self.status = .idle
                isLoading = false
            }
        } label: {
            content()
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .opacity(isLoading ? 0 : 1)
                .lineLimit(1)
                .frame(width: isLoading ? 50 : nil, height: isLoading ? 50 : nil)
                .background(Color(status == .idle ? .systemBackground : status == .success ? .systemMint : .systemRed).shadow(.drop(color: .black.opacity(0.2), radius: 6)), in: Capsule())
                .overlay {
                    if isLoading && status == .idle {
                        ProgressView()
                    }
                }
                .overlay{
                    if status != .idle {
                        Image(systemName: isFailed ? "exclamationmark" : "checkmark")
                            .fontWeight(.black)
                            .foregroundStyle(.white)
                    }
                }
        }
        .disabled(isLoading)
        .animation(.easeInOut, value: isLoading)
        .animation(.easeInOut, value: status)
    }
}

enum Status: Equatable {
    case idle
    case failed(String)
    case success
}

struct AnimatedButton_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

