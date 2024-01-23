//
//  MovableGridView.swift
//  SwiftUIExample
//
//  Created by 한태희 on 2024/01/22.
//

import SwiftUI

struct MovableGridView: View {
    
    @State private var colors: [Color] = [.red, .blue, .green, .purple, .orange, .yellow, .brown, .cyan, .indigo, .mint, .pink, .black]
    /// 현재 드래그 중인 아이템
    @State private var draggingItem: Color?
    
    var body: some View {
        ScrollView(.vertical) {
            let columns = Array(repeating: GridItem(spacing: 10), count: 3)
            LazyVGrid(columns: columns) {
                ForEach(colors, id: \.self) { color in
                    GeometryReader {
                        let size = $0.size
                        RoundedRectangle(cornerRadius: 10)
                            .fill(color.gradient)
                            .draggable(color) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.ultraThinMaterial)
                                    .frame(width: size.width, height: size.height)
                                    .onAppear {
                                        draggingItem = color
                                    }
                            }
                            .dropDestination(for: Color.self) { items, location in
                                draggingItem = nil
                                return false
                            } isTargeted: { status in
                                if let draggingItem, status, draggingItem != color {
                                   if let from = colors.firstIndex(of: draggingItem),
                                      let to = colors.firstIndex(of: color) {
                                       withAnimation(.easeInOut) {
                                           let sourceItem = colors.remove(at: from)
                                           colors.insert(sourceItem, at: to)
                                       }
                                   }
                                }
                            }
                    }
                    .frame(height: 120)
                }
            }
            .padding(15)
        }
        .navigationTitle("드래그 그리드")
    }
}

struct MovableGridView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
