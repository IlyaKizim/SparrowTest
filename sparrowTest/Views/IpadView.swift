//
//  TestView.swift
//  sparrowTest
//
//  Created by Кизим Илья on 20.12.2023.
//

import SwiftUI

struct IpadView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var viewModel: ContentViewModel
    @State private var isPressed = [false, false, false, false, false, false]
    
    var updateIndex: (Int) -> ()
    let theme: Theme
    
    var themeButtonModel: ButtonModel {
        return theme.buttonModel
    }
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottomTrailing) {
                GeometryReader { proxy in
                    ZStack(alignment: .bottomTrailing) {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: viewModel.width, height: viewModel.height)
                            .foregroundStyle(LinearGradient(colors: themeButtonModel.gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing))
                            .overlay(OverlayButton(isPressed: $isPressed, proxy: proxy, updateIndex: updateIndex, themeButtonModel: themeButtonModel))
                        Text("")
                            .frame(width: 30, height: 30)
                            .background(.red)
                            .gesture(gestureForBottomTrailingElement())
                    }
                }
                .background(backgroundWithGeometryReader(content: EmptyView()))
            }
            .frame(width: viewModel.width, height: viewModel.height)
            .offset(x: viewModel.currentLocation.width, y: viewModel.currentLocation.height)
            .gesture(dragGesture())
        }
    }
    
    // MARK: - GestureDraggingRectangle
    
   private func dragGesture() -> some Gesture {
        DragGesture()
            .onChanged { value in
                if viewModel.startLocation == .zero {
                    viewModel.startLocation = viewModel.currentLocation
                    viewModel.dragGesture = true
                }
                viewModel.currentLocation = CGSize(
                    width: viewModel.startLocation.width + value.translation.width,
                    height: viewModel.startLocation.height + value.translation.height
                )
            }
            .onEnded { _ in
                withAnimation(.spring()) {
                    viewModel.startLocation = .zero
                    viewModel.dragGesture = false
                }
            }
    }
    
    // MARK: - GestureResizeRectangle
    
    private func gestureForBottomTrailingElement() -> some Gesture {
        DragGesture()
            .onChanged { value in
                viewModel.width = max(400, viewModel.width + value.translation.width)
                viewModel.height = max(100, (viewModel.height + value.translation.height))
            }
    }
    
    // MARK: - CalculatePositionMainRectangle
    
    private func backgroundWithGeometryReader<Content: View>(content: Content) -> some View {
        GeometryReader { buttonProxy in
            Color.clear
                .onChange(of: [buttonProxy.size]) { _,_ in
                    viewModel.currentProxyFrame = buttonProxy.frame(in: .global)
                }
                .onAppear {
                    viewModel.currentProxyFrame = buttonProxy.frame(in: .global)
                }
                .onChange(of: viewModel.currentLocation) { _,_ in
                    viewModel.currentProxyFrame = buttonProxy.frame(in: .global)
                }
            content
        }
    }
}

    // MARK: - OverlayButton

struct OverlayButton: View {
    @EnvironmentObject private var viewModel: ContentViewModel
    @Binding var isPressed: [Bool]
    var proxy: GeometryProxy
    var updateIndex: (Int) -> ()
    var themeButtonModel: ButtonModel
    
    var body: some View {
        ZStack(alignment: .leading) {
            LazyVGrid( columns: [GridItem(.adaptive(minimum: proxy.size.height / 2), spacing : 1)], spacing: 1, content: {
                ForEach(0..<6) {index in
                    Button(action: {
                        withAnimation(.spring(duration: 0.5)) {
                            isPressed[index].toggle()
                            Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { _ in
                                    isPressed[index].toggle()
                                    updateIndex(index)
                                }
                        }
                    }) {
                        Rectangle()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .foregroundStyle(Color.colorForIndex(index))
                            .frame(width: isPressed[index] ? proxy.size.width : .none, height: isPressed[index] ? proxy.size.height : min(viewModel.h, proxy.size.height / 2))
                            .animation(.spring, value: viewModel.height)
                            .overlay(
                                VStack {
                                    Image(systemName: themeButtonModel.imageNames)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                    Text("device")
                                        .font(.caption)
                                }
                                    .opacity(isPressed[index] ? 0 : 1)
                                    .foregroundColor(.black)
                                    .animation(.spring, value: viewModel.height)
                            )
                    }
                    .overlay(overlayWithGeometryReader(index: index, isPressed: $isPressed[index], content: EmptyView()))
                    .offset(x: isPressed[index] ? viewModel.calculateOffset(rectangle: viewModel.currentProxyFrame, button: viewModel.positions[index]).x : 0,
                            y: isPressed[index] ? viewModel.calculateOffset(rectangle: viewModel.currentProxyFrame, button: viewModel.positions[index]).y : 0)
                    .zIndex(isPressed[index] ? 3 : 1)
                    .frame(height: min(viewModel.h, proxy.size.height / 2))
                }
            })
        }
    }
    
    // MARK: - CalculateEveryPositionButton
    
   private func overlayWithGeometryReader<Content: View>(index: Int, isPressed: Binding<Bool>, content: Content) -> some View {
        GeometryReader { geometry in
            Color.clear
                .onAppear {
                    let buttonPosition = geometry.frame(in: .global)
                    viewModel.positions[index] = buttonPosition
                }
                .onChange(of: geometry.frame(in: .global)) { newSize, _ in
                    let buttonPosition = geometry.frame(in: .global)
                    guard !isPressed.wrappedValue else { return }
                    viewModel.positions[index] = buttonPosition
                }
            content
        }
    }
}


    






//struct IpadView: View {
//    
//    // MARK: - Properties
//    
//    @EnvironmentObject private var viewModel: ContentViewModel
//    @State private var isPressed = [false, false, false, false, false, false]
//    
//    var updateIndex: (Int) -> ()
//    let theme: Theme
//    
//    var themeButtonModel: ButtonModel {
//        return theme.buttonModel
//    }
//    
//    // MARK: - Body
//    
//    var body: some View {
//        GeometryReader { geo in
//            ZStack(alignment: .bottomTrailing) {
//                GeometryReader { proxy in
//                    ZStack(alignment: .bottomTrailing) {
//                        RoundedRectangle(cornerRadius: 20)
//                            .frame(width: viewModel.width, height: viewModel.height)
//                            .foregroundStyle(LinearGradient(colors: themeButtonModel.gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing))
//                            .overlay (
//                                ZStack(alignment: .leading) {
//                                    LazyVGrid( columns: [GridItem(.adaptive(minimum: proxy.size.height / 2), spacing : 1)], spacing: 1, content: {
//                                        ForEach(0..<6) {index in
//                                            Button(action: {
//                                                withAnimation(.spring(duration: 0.5)) {
//                                                    isPressed[index].toggle()
//                                                    Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { _ in
//                                                            isPressed[index].toggle()
//                                                            updateIndex(index)
//                                                        }
//                                                }
//                                            }) {
//                                                Rectangle()
//                                                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                                                    .foregroundStyle(Color.colorForIndex(index))
//                                                    .frame(width: isPressed[index] ? proxy.size.width : .none, height: isPressed[index] ? proxy.size.height : min(viewModel.h, proxy.size.height / 2))
//                                                    .animation(.spring, value: viewModel.height)
//                                                    .overlay(
//                                                        VStack {
//                                                            Image(systemName: themeButtonModel.imageNames)
//                                                                .resizable()
//                                                                .aspectRatio(contentMode: .fit)
//                                                                .frame(width: 30, height: 30)
//                                                            Text("device")
//                                                                .font(.caption)
//                                                        }
//                                                            .opacity(isPressed[index] ? 0 : 1)
//                                                            .foregroundColor(.black)
//                                                            .animation(.spring, value: viewModel.height)
//                                                    )
//                                            }
//                                            .overlay(
//                                                GeometryReader { geometry in
//                                                    Color.clear
//                                                        .onAppear {
//                                                            let buttonPosition = geometry.frame(in: .global)
//                                                            viewModel.positions[index] = buttonPosition
//                                                        }
//                                                        .onChange(of: geometry.frame(in: .global)) { newSize, _ in
//                                                            let buttonPosition = geometry.frame(in: .global)
//                                                            guard !isPressed[index] else {return}
//                                                            viewModel.positions[index] = buttonPosition
//                                                        }
//                                                }
//                                            )
//                                            .offset(x: isPressed[index] ? viewModel.calculateOffset(rectangle: viewModel.currentProxyFrame, button: viewModel.positions[index]).x : 0,
//                                                    y: isPressed[index] ? viewModel.calculateOffset(rectangle: viewModel.currentProxyFrame, button: viewModel.positions[index]).y : 0)
//                                            .zIndex(isPressed[index] ? 3 : 1)
//                                            .frame(height: min(viewModel.h, proxy.size.height / 2))
//                                        }
//                                    })
//                                })
//                        Text("")
//                            .frame(width: 30, height: 30)
//                            .background(.red)
//                            .gesture(
//                                DragGesture()
//                                    .onChanged { value in
//                                        viewModel.width = max(400, viewModel.width + value.translation.width)
//                                        viewModel.height = max(100, (viewModel.height + value.translation.height))
//                                    }
//                            )
//                    }
//                    
//                }
//                .background(
//                    GeometryReader { buttonProxy in
//                        Color.clear
//                            .onChange(of: [buttonProxy.size]) { _,_ in
//                                viewModel.currentProxyFrame = buttonProxy.frame(in: .global)
//                            }
//                            .onAppear{
//                                viewModel.currentProxyFrame = buttonProxy.frame(in: .global)
//                            }
//                            .onChange(of: viewModel.currentLocation) {_,_ in
//                                viewModel.currentProxyFrame = buttonProxy.frame(in: .global)
//                            }
//                    }
//                )
//            }
//            .frame(width: viewModel.width, height: viewModel.height)
//            .offset(x: viewModel.currentLocation.width, y: viewModel.currentLocation.height)
//            .gesture(
//                DragGesture()
//                    .onChanged { value in
//                        if viewModel.startLocation == .zero {
//                            viewModel.startLocation = viewModel.currentLocation
//                            viewModel.dragGesture = true
//                            viewModel.tapGesture = false
//                        }
//                        viewModel.currentLocation = CGSize(
//                            width: viewModel.startLocation.width + value.translation.width,
//                            height: viewModel.startLocation.height + value.translation.height
//                        )
//                    }
//                    .onEnded { _ in
//                        withAnimation(.spring()) {
//                            viewModel.startLocation = .zero
//                            viewModel.dragGesture = false
//                        }
//                    }
//            )
//            .gesture(
//                TapGesture(count: 1)
//                    .onEnded {
//                        viewModel.tapGesture.toggle()
//                    }
//            )
//        }
//    }
//}
