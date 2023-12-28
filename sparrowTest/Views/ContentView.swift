//
//  ContentView.swift
//  sparrowTest
//
//  Created by Кизим Илья on 17.12.2023.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var viewModel: ContentViewModel
    
    // MARK: - UI Components
    
    var device = UIDevice.current.userInterfaceIdiom
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            backgroundView
            
            GeometryReader { geometry in
                VStack {
                    headerView
                    Spacer()
                    mainContentView
                    Spacer()
                    Group {
                        
                        //MARK: - IpadView
                        
                        if device == .pad {
                            
                            IpadViewContainer()
                            
                            //MARK: - IphoneView
                            
                        } else if device == .phone {
                            PhoneViewContainer()
                                .background(Color.clear.onAppear {
                                    viewModel.currentXPosition = geometry.size.width
                                })
                                .offset(y: viewModel.stackIsEmpty ? 0 : 200)
                                .transition(.move(edge: .bottom))
                                .animation(.easeInOut(duration: 0.6), value: viewModel.stackIsEmpty)
                                .overlay(RectanglesOverlay())
                        }
                    }
                }
            }
            .ignoresSafeArea(.all, edges: device == .pad ? .top : .all)
        }
    }
    
    private var backgroundView: some View {
        Color.gray.edgesIgnoringSafeArea(.all).opacity(0.2)
    }
    
    private var headerView: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .frame(height: 100)
                .foregroundStyle(.white)
            Text("SparrowTest")
                .padding([.bottom], 10)
        }
    }
    
    private var mainContentView: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(height: 250)
            .foregroundStyle(.white)
            .padding([.leading, .trailing], 20)
    }
}

struct PhoneViewContainer: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var viewModel: ContentViewModel
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: 80)
                .foregroundStyle(.white)
            HStack {
                ForEach(0..<6) { index in
                    Button(action: {
                        withAnimation{
                            viewModel.stackIsEmpty.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                viewModel.index = index
                            }
                        }
                    }) {
                        PhoneButtonView(index: index)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

struct PhoneButtonView: View {
    
    // MARK: - Properties
    
    let index: Int
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            Image(systemName: "square")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
            
            Text("device")
                .font(.caption)
        }
        .offset(y: -5)
        .foregroundColor(.black)
    }
}

struct RectanglesOverlay: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var viewModel: ContentViewModel
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            ForEach(Array(viewModel.rectangles.enumerated().reversed()), id: \.element.id) { (index, rectangleInfo) in
                if let viewType = rectangleInfo.content {
                    viewType
                        .position(viewModel.position[index] ? CGPoint(x: viewModel.currentXPosition / 2 - 20, y: 40) : rectangleInfo.position)
                        .opacity(viewModel.position[index] ? 1 : 0.6)
                        .zIndex(viewModel.position[index] ? 3 : 1)
                }
            }
        }
        
        //MARK: - CreateNewViewAfterPressingButton
        
        .onChange(of: viewModel.index) {
            viewModel.createViewArray(pressedView: viewModel.index)
        }
        
        //MARK: - ChangeIndexInDependenceDragging
        
        .onChange(of: viewModel.curLocation) { newValue, _ in
            viewModel.changeIndex(newValue: newValue)
        }
        
        //MARK: - CalculateRectangleBounds
        
        .background(
            GeometryReader { geoProxy in
                Color.clear
                    .preference(key: BoundsPreferenceKey.self, value: geoProxy.frame(in: .global))
            })
        
        //MARK: - CalculateArrayCoordsForDragging
        
        .onPreferenceChange(BoundsPreferenceKey.self) { bounds in
            viewModel.geometryBounds = bounds
            if !viewModel.rectangles.isEmpty {
                viewModel.createArrayCoords()
            }
        }
        
        //MARK: - LongPressGesture
        
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.2)
                .onChanged { value in
                    viewModel.isLongPressActive = false
                }
                .onEnded { value in
                    viewModel.isLongPressActive = true
                }
        )
        
        //MARK: - DragGesture
        
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    if viewModel.isLongPressActive {
                        viewModel.checkPossibleFrame(value: value)
                    }
                }
        )
        .offset(y: -80)
        .padding([.leading, .trailing], 20)
    }
}

struct IpadViewContainer: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var viewModel: ContentViewModel
    
    // MARK: - Body
    
    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .fill(Color.clear)
            .frame(width: 400, height: 100)
            .background(
                GeometryReader { geoProxy in
                    Color.clear
                        .preference(key: BoundsPreferenceKey.self, value: geoProxy.frame(in: .global))
                        .onAppear{
                            let proxyPosition = geoProxy.frame(in: .local)
                            viewModel.currentXPositionIpad = proxyPosition.origin.x + (proxyPosition.width / 2)
                        }
                })
            .onAppear {
                viewModel.createViewArrayIpad(pressedView: viewModel.indexIpad)
            }
            .overlay(
                ForEach(Array(viewModel.rectanglesIpad.enumerated().reversed()), id: \.element.id) { (index, rectangleInfo) in
                    if let viewType = rectangleInfo.content {
                        viewType
                            .position(rectangleInfo.position)
                    }
                }
                    .onChange(of: viewModel.indexIpad) {
                        viewModel.createViewArrayIpad(pressedView: viewModel.indexIpad)
                    }
            )
    }
}

#Preview {
    ContentView()
}
