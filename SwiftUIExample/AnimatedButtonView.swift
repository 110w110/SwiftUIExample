//
//  AnimatedButtonView.swift
//  SwiftUIExample
//
//  Created by 한태희 on 2024/01/22.
//

import SwiftUI

struct AnimatedButtonView: View {
    var body: some View {
        AnimatedButton {
            Text("Animated Button")
        } action: {
            try? await Task.sleep(for: .seconds(2))
            
            return .failed("Failed!!")
//            return .success
        }

    }
}

struct AnimatedButtonView_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedButtonView()
    }
}
