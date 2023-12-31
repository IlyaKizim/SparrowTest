//
//  TEST.swift
//  sparrowTest
//
//  Created by Кизим Илья on 22.12.2023.
//

import SwiftUI

struct ShowView: View {
    
    // MARK: - Properties
    var action: (Int) -> ()
    let theme: Theme
    @State var isPressed: [Bool] = [false, false, false, false, false, false]
    
    var themeButtonModel: ButtonModel {
            return theme.buttonModel
        }
    
    // MARK: - Body

    var body: some View {
        ZStack {
            GeometryReader { proxy in
                ForEach(0..<6) { i in
                    Button(action: {
                        withAnimation {
                            isPressed[i].toggle()
                            action(-1)
                            Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { _ in
                               isPressed[i].toggle()
                                action(i)
                            }
                        }
                    }) {
                        VStack {
                            Image(systemName: themeButtonModel.imageNames)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                            Text("device")
                                .font(.caption)
                        }
                        .foregroundColor(.black)
                    }
                    .frame(width: isPressed[i] ? proxy.size.width : proxy.size.width / 6, height: isPressed[i] ? proxy.size.height  : proxy.size.height - 10)
                    .zIndex(isPressed[i] ? 3 : 1)
                    .background(LinearGradient(colors: themeButtonModel.gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .offset(x: isPressed[i] ? 0 : CGFloat.calculateOffset(for: i, proxy: proxy))
                    .padding(.top, isPressed[i] ? 0 : 5)
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 1)
            )
        }
        .frame(maxWidth: .infinity, maxHeight: 80, alignment: .leading)
    }
}
