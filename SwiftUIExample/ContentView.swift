//
//  ContentView.swift
//  SwiftUIExample
//
//  Created by 한태희 on 2024/01/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    AnimatedButtonView()
                } label: {
                    Text("애니메이션 버튼")
                }
                
                NavigationLink {
                    MovableGridView()
                } label: {
                    Text("드래그 그리드")
                }
            }
            .navigationTitle("SwiftUI Example")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
