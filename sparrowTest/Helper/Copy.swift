//
//  ReserveCopy.swift
//  sparrowTest
//
//  Created by Кизим Илья on 26.12.2023.
//

//struct SixView: View {
//    @State private var isPressed = [false, false, false, false, false, false]
//    var onButtonPress: (pressView, Int) -> Void
//
//    init(onButtonPress: @escaping (pressView, Int) -> Void) {
//            self.onButtonPress = onButtonPress
//        }
//
//    var body: some View {
//            GeometryReader { proxy in
//                RoundedRectangle(cornerRadius: 10)
//                    .frame(height: 80)
//                    .foregroundColor(.orange)
//                    .overlay(
//                        ZStack(alignment: .leading) {
//                            ForEach(0..<6) { index in
//                                Button(action: {
//                                    withAnimation {
//                                        isPressed[index].toggle()
//                                    }
//                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                                        switch index {
//                                        case 0:
//                                            onButtonPress(.firstView, index)
//                                        case 1:
//                                            onButtonPress(.secondView, index)
//                                        case 2:
//                                            onButtonPress(.thirdView, index)
//                                        case 3:
//                                            onButtonPress(.fourView, index)
//                                        case 4:
//                                            onButtonPress(.fiveView, index)
//                                        case 5:
//                                            onButtonPress(.sixView, index)
//                                        default:
//                                            break
//                                        }
//                                    }
//                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7){
//                                            isPressed[index] = false
//                                    }
//                                }) {
//                                    VStack {
//                                        Image(systemName: "play.rectangle")
//                                            .resizable()
//                                            .aspectRatio(contentMode: .fit)
//                                            .frame(width: 30, height: 30)
//                                        Text("device")
//                                            .font(.caption)
//                                    }
//                                    .opacity(isPressed[index] ? 0 : 1)
//                                    .foregroundColor(.black)
//                                }
//                                .zIndex(isPressed[index] ? 3 : 1)
//                                .frame(width: isPressed[index] ? proxy.size.width : proxy.size.width / 6, height: isPressed[index] ? 80 : 60)
//                                .background(Color.colorForIndex(index))
//                                .clipShape(RoundedRectangle(cornerRadius: 10))
//                                .offset(x: isPressed[index] ? 0 : CGFloat.calculateOffset(for: index, proxy: proxy))
//                            }
//                        }
//                        , alignment: .leading
//                    )
//            }
//    }
//}
//
//#Preview {
//    SixView(onButtonPress: { pressedView, index in })
//}

//struct ShowFirstView: View {
//    @Binding var index: Int
//    @State private var isPressed = [false, false, false, false, false, false]
//
//    var body: some View {
//        ZStack {
//            GeometryReader { proxy in
//                ForEach(0..<6) { i in
//                    Button(action: {
//                        withAnimation {
//                            isPressed[i].toggle()
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
//                                isPressed[i].toggle()
//                                self.index = i
//                            }
//                        }
//                    }) {
//                        VStack {
//                            Image(systemName: "archivebox.circle")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 30, height: 30)
//                            Text("device")
//                                .font(.caption)
//                        }
//                        .foregroundColor(.black)
//                    }
//                    .frame(width: isPressed[i] ? proxy.size.width : proxy.size.width / 6, height: isPressed[i] ? proxy.size.height  : proxy.size.height - 10)
//                    .zIndex(isPressed[i] ? 3 : 1)
//                    .background(LinearGradient(colors: [.green, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                    .offset(x: isPressed[i] ? 0 : CGFloat.calculateOffset(for: i, proxy: proxy))
//
//                    .padding( .top, isPressed[i] ? 0 : 5)
//                }
//            }
//            .overlay(
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(Color.black, lineWidth: 1)
//            )
//        }
//        .frame(maxWidth: .infinity, maxHeight: 80, alignment: .leading)
//    }
//}
//


//struct ShowFiveView: View {
//    @Binding var index: Int
//    @State var dragLocation: CGPoint?
//    @State private var isDragging = false
//    @State private var geometryBounds: CGRect?
//    @State private var curLocation: CGFloat = 0
//    @State private var curIndex = -1
//    @State private var arrayCoords: [ClosedRange<CGFloat>] = []
//    @State private var isPressed = [false, false, false, false, false, false]
//    @Binding var flags: [Bool]
//
//    @GestureState private var isLongPressing = false
//
//    private var drag: some Gesture {
//        LongPressGesture(minimumDuration: 0.1)
//            .updating($isLongPressing) { value, state, _ in
//                state = value
//            }
//            .onEnded { value in
//                if isLongPressing {
//                    isDragging = false
//                } else {
//                    isDragging = true
//                }
//            }
//            .simultaneously(with: DragGesture(minimumDistance: 0)
//                .onChanged { value in
//                    guard isDragging else { return }
//                    print(value.location)
//                    dragLocation = value.location
//                    updateLocation(dragLocation ?? CGPoint(x: 0, y: 0))
//                }
//                .onEnded { _ in
//                    isDragging = false
//                }
//            )
//    }
//
//    var body: some View {
//        ZStack {
//            GeometryReader {proxy in
//                ForEach(0..<6) {index in
//                    Button(action: {
//                        withAnimation {
//                            isPressed[index].toggle()
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
//                                isPressed[index].toggle()
//                                self.index = index
//                            }
//                        }
//                    }) {
//                        VStack {
//                            Image(systemName: "externaldrive")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 30, height: 30)
//                            Text("device")
//                                .font(.caption)
//                        }
//                        .foregroundColor(.black)
//                    }
//                    .frame(width: isPressed[index] ? proxy.size.width : proxy.size.width / 6, height: isPressed[index] ? proxy.size.height : proxy.size.height)
//                    .zIndex(isPressed[index] ? 3 : 1)
//                    .background(LinearGradient(colors: [.indigo, .white], startPoint: .topLeading, endPoint: .bottomTrailing))
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                    .offset(x: isPressed[index] ? 0 : CGFloat.calculateOffset(for: index, proxy: proxy))
//                    .simultaneousGesture(drag)
//
//                }
//
//
//            }
//            .background(
//                GeometryReader { geoProxy in
//                    Color.clear
//                        .preference(key: BoundsPreferenceKey.self, value: geoProxy.frame(in: .global))
//                })
//            .onPreferenceChange(BoundsPreferenceKey.self) { bounds in
//                geometryBounds = bounds
//                if arrayCoords.isEmpty {
//                    if let unwrappedBounds = bounds {
//                        let width = unwrappedBounds.size.width
//
//                        var startLoc: CGFloat = 0
//                        var currentLoc: CGFloat = 0
//                        let widthRec = width / 6
//                        for _ in 0..<6 {
//                            currentLoc = startLoc + widthRec
//                            arrayCoords.append(startLoc...currentLoc)
//                            startLoc = currentLoc
//                        }
//                    } else {
//                        print("Bounds are nil")
//                    }
//                }
//            }
//            .onChange(of: curLocation) { newValue, _ in
//                let intValue = newValue
//                for index in 0..<arrayCoords.count {
//                    if arrayCoords[index].contains(intValue) {
//                        if curIndex != index {
//                            withAnimation(.easeInOut(duration: 1)) {
//                                flags[index] = true
//                            }
//                            curIndex = index
//                            break
//                        }
//                    } else {
//                        withAnimation(.easeInOut(duration: 1)) {
//                            flags[index] = false
//                        }
//                    }
//                }
//            }
//            .background(LinearGradient(colors: [.indigo, .white], startPoint: .topLeading, endPoint: .bottomTrailing))
//            .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
//
//        }
//        .frame(maxWidth: .infinity, maxHeight: 80, alignment: .leading)
//        .gesture(drag)
//        .padding([.leading, .trailing], 10)
//    }
//
//    func updateLocation(_ location: CGPoint) {
//        curLocation = location.x
//
//    }
//}
//import SwiftUI
//
//enum pressView {
//    case firstView
//    case secondView
//    case thirdView
//    case fourView
//    case fiveView
//    case sixView
//}
//
//
//struct RectangleInfo: Identifiable {
//    let id: UUID
//    var position: CGPoint
//    var opacity: Double
//    var content: AnyView?
//}
//
//struct ContentView: View {
//
//
//    @State private var stackIsEmpty = true
//    @State private var rectangles: [RectangleInfo] = []
//    @State private var currentXPosition: CGFloat = 0
//    @State private var pressedView: pressView?
//    @State private var isExpanded: Bool = false
//    @State private var startLocation: CGSize = .zero
//    @State private var currentLocation: CGSize = .zero
//    @State var flags = [true, false, false, false, false, false]
//    @State private var isPressed = [false, false, false, false, false, false]
//    var divice = UIDevice.current.userInterfaceIdiom
//
//    var body: some View {
//        ZStack {
//            Color.gray.edgesIgnoringSafeArea(.all).opacity(0.2)
//            GeometryReader { geometry in
//                VStack {
//                    ZStack(alignment: .bottom) {
//                        Rectangle()
//                            .frame(height: 100)
//                            .foregroundStyle(.white)
//                        Text("SparrowTest")
//                            .padding([.bottom], 10)
//                    }
//
//                    Spacer()
//
//                    RoundedRectangle(cornerRadius: 10)
//                        .frame(height: 250)
//                        .foregroundStyle(.white)
//                        .padding([.leading, .trailing], 20)
//
//                    Spacer()
//
//                    if divice == .pad {
//                        RoundedRectangle(cornerRadius: 30)
//                            .fill(Color.clear)
//                            .frame(width: 400, height: 100)
//                            .offset(x: currentLocation.width, y: currentLocation.height)
//                            .overlay(
//                                IpadView()
//                            )
//
//                    } else if divice == .phone {
//                        ZStack {
//                            Rectangle()
//                                .frame(height: 100)
//                                .foregroundStyle(.white)
//                            HStack {
//                                ForEach(0..<6) { index in
//                                    Button(action: {
//                                        withAnimation{
//                                            stackIsEmpty.toggle()
//                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                                                pressedView = pressViewForViewType(index)
//                                                createViewArray(pressedView: pressViewForViewType(index))
//                                            }
//                                        }
//                                    }) {
//                                        VStack {
//                                            Image(systemName: "square")
//                                                .resizable()
//                                                .aspectRatio(contentMode: .fit)
//                                                .frame(width: 30, height: 30)
//                                            Text("device")
//                                                .font(.caption)
//                                        }
//                                        .foregroundColor(.black)
//                                    }
//                                    .frame(maxWidth: .infinity)
//                                }
//                            }
//                        }
//                        .background(Color.yellow.onAppear {
//                            currentXPosition = geometry.size.width
//                        })
//                        .offset(y: stackIsEmpty ? 0 : 200)
//                        .transition(.move(edge: .bottom))
//                        .animation(.easeInOut(duration: 0.6), value: stackIsEmpty)
//                        .overlay(
//                            ZStack {
//                                ForEach(Array(rectangles.enumerated().reversed()), id: \.element.id) { (index, rectangleInfo) in
//                                    if let viewType = rectangleInfo.content {
//                                        viewType
//                                            .padding([.leading, .trailing], 10)
//                                            .position(rectangleInfo.position)
//                                            .opacity(rectangleInfo.opacity)
//                                    }
//                                }
//                                let constantPosition = CGPoint(x: currentXPosition / 2 - 10, y: 0)
//                                if let pressedView = pressedView {
//                                    switch pressedView {
//                                    case .firstView:
//                                        FirstView { pressView, index  in
//                                            withAnimation(.linear(duration: 0.3)) {
//                                                self.pressedView = pressView
//                                                createViewArray(pressedView: pressView)
//                                            }
//                                        }
//                                        .position(constantPosition)
//                                        .padding([.leading, .trailing], 10)
//                                    case .secondView:
//                                        SecondView{ pressView, index in
//                                            withAnimation(.linear(duration: 0.3)) {
//                                                self.pressedView = pressView
//
//                                                createViewArray(pressedView: pressView)
//                                            }
//                                        }
//                                        .position(constantPosition)
//                                        .padding([.leading, .trailing], 10)
//                                    case .thirdView:
//                                        ThirdView{ pressView, index in
//                                            withAnimation(.linear(duration: 0.3)) {
//                                                self.pressedView = pressView
//
//                                                createViewArray(pressedView: pressView)
//                                            }
//                                        }
//                                        .position(constantPosition)
//                                        .padding([.leading, .trailing], 10)
//                                    case .fourView:
//                                        FourView{ pressView, index in
//                                            withAnimation(.linear(duration: 0.3)) {
//                                                self.pressedView = pressView
//                                                createViewArray(pressedView: pressView)
//                                            }
//                                        }
//                                        .position(constantPosition)
//                                        .padding([.leading, .trailing], 10)
//                                    case .fiveView:
//                                        FiveView{ pressView, index in
//                                            withAnimation(.linear(duration: 0.3)) {
//                                                createViewArray(pressedView: pressView)
//                                            }
//                                            self.pressedView = pressView
//                                        }
//                                        .position(constantPosition)
//                                        .padding([.leading, .trailing], 10)
//                                    case .sixView:
//                                        SixView{ pressView, index in
//                                            withAnimation(.linear(duration: 0.3)) {
//                                                self.pressedView = pressView
//                                                createViewArray(pressedView: pressView)
//                                            }
//                                        }
//                                        .position(constantPosition)
//                                        .padding([.leading, .trailing], 10)
//                                    }
//                                }
//                            }
//                        )
//
//                    }
//                }
//            }
//            .ignoresSafeArea(.all, edges: divice == .pad ? .top : .all)
//        }
//    }
//}
//
//extension ContentView {
//
//    func createViewArray(pressedView: pressView?) {
//
//        let constantPosition = CGPoint(x: currentXPosition / 2, y: 0)
//        var view: RectangleInfo?
//        switch pressedView {
//        case .firstView:
//            view = RectangleInfo(id: UUID(), position: constantPosition, opacity: 1.0, content: AnyView(FirstView(onButtonPress: { pressView, int in })))
//        case .secondView:
//            view = RectangleInfo(id: UUID(), position: constantPosition, opacity: 1.0, content: AnyView(SecondView(onButtonPress: { pressView, int in })))
//        case .thirdView:
//            view = RectangleInfo(id: UUID(), position: constantPosition, opacity: 1.0, content: AnyView(ThirdView(onButtonPress: { pressView, int in })))
//        case .fourView:
//            view = RectangleInfo(id: UUID(), position: constantPosition, opacity: 1.0, content: AnyView(FourView(onButtonPress: { pressView, int in })))
//        case .fiveView:
//            view = RectangleInfo(id: UUID(), position: constantPosition, opacity: 1.0, content: AnyView(FiveView(onButtonPress: { pressView, int in })))
//        case .sixView:
//            view = RectangleInfo(id: UUID(), position: constantPosition, opacity: 1.0, content: AnyView(FiveView(onButtonPress: { pressView, int in })))
//        case .none:
//            break
//        }
//        if var newRectangle = view {
//            if rectangles.count < 5  {
//                for index in stride(from: rectangles.count - 1, through: 0, by: -1) {
//                    rectangles[index].position.x -= 10
//                    rectangles[index].position.y += 10
//                    rectangles[index].opacity = 0.5
//                }
//            } else {
//                newRectangle.position.x = rectangles.first?.position.x ?? 0
//                newRectangle.position.y = rectangles.first?.position.y ?? 0
//            }
//            rectangles.insert(newRectangle, at: 0)
//        }
//
//    }
//
//    func pressViewForViewType(_ viewType: Int) -> pressView {
//        switch viewType {
//        case 0: return .firstView
//        case 1: return .secondView
//        case 2: return .thirdView
//        case 3: return .fourView
//        case 4: return .fiveView
//        case 5: return .sixView
//        default: return .firstView
//        }
//    }
//}
//
//
//#Preview {
//    ContentView()
//}
