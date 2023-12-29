//
//  ContentViewModel.swift
//  sparrowTest
//
//  Created by Кизим Илья on 26.12.2023.
//

import SwiftUI

class ContentViewModel: ObservableObject {
    
    // MARK: - PropertiesIphone
    
    @Published private (set) var rectangles: [RectangleInfo] = []
    @Published private (set) var curLocation: CGFloat = 0
    @Published private (set) var arrayCoords: [ClosedRange<CGFloat>] = []
    @Published private (set) var currentIndex = -1
    @Published private (set) var position: [Bool] = [true, false, false, false, false, false]
    @Published var geometryBounds: CGRect?
    @Published var currentXPosition: CGFloat = 0
    @Published var index = -1
    @Published var stackIsEmpty = true
    @Published var isLongPressActive = false
    
    // MARK: - PropertiesIpad
    
    @Published private (set) var rectanglesIpad: [RectangleInfo] = []
    @Published private (set) var h: CGFloat = 100
    @Published private (set) var indexIpad = -1
    @Published var startLocation: CGSize = .zero
    @Published var currentLocation: CGSize = .zero
    @Published var dragGesture: Bool = false
    @Published var currentXPositionIpad: CGFloat = .zero
    @Published var width: CGFloat = 400
    @Published var height: CGFloat = 120
    @Published var currentProxyFrame: CGRect = .zero
    @Published var positions: [CGRect] = Array(repeating: .zero, count: 6)
    
    // MARK: - CreateArrayCoordsForDragging
    
    func createArrayCoords() {
        if let unwrappedBounds = geometryBounds {
            let width = unwrappedBounds.size.width
            var startLoc: CGFloat = 0
            var currentLoc: CGFloat = 0
            let widthRec = width / 6
            for _ in 0..<6 {
                currentLoc = startLoc + widthRec
                arrayCoords.append(startLoc...currentLoc)
                startLoc = currentLoc
            }
        }
    }
    
    // MARK: - CheckPossibleFrameForDragging
    
    func checkPossibleFrame(value: DragGesture.Value) {
        guard let bounds = geometryBounds else {
            return
        }
        let location = value.location
        let pointInBounds = bounds.origin.x <= location.x &&
        bounds.size.width >= location.x &&
        location.y >= 0 && location.y <= bounds.size.height
        if pointInBounds {
            curLocation = location.x
        }
    }
    
    // MARK: - ChangingIndex
    
    func changeIndex(newValue: CGFloat) {
        for index in 0..<arrayCoords.count {
            if arrayCoords[index].contains(newValue) {
                if currentIndex != index {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        position[index] = true
                    }
                    currentIndex = index
                    break
                }
            } else {
                withAnimation(.easeInOut(duration: 0.3)) {
                    position[index] = false
                }
            }
        }
    }
    
    // MARK: - AppendingViewInArray
    
    func createViewArray(pressedView: Int) {
    
        let constantPosition = CGPoint(x: currentXPosition / 2 - 20, y: 40)
        var view: RectangleInfo?
        switch pressedView {
        case 0:
            view = RectangleInfo(id: UUID(), position: constantPosition, opacity: 1.0, content: AnyView(ShowView(action: {index in self.index = index}, theme: .greenBlue)))
        case 1:
            view = RectangleInfo(id: UUID(), position: constantPosition, opacity: 1.0, content: AnyView(ShowView(action: {index in self.index = index},theme: .redBlue)))
        case 2:
            view = RectangleInfo(id: UUID(), position: constantPosition, opacity: 1.0, content: AnyView(ShowView(action: {index in self.index = index},theme: .orangePurple)))
        case 3:
            view = RectangleInfo(id: UUID(), position: constantPosition, opacity: 1.0, content: AnyView(ShowView(action: {index in self.index = index},theme: .purpleWhite)))
        case 4:
            view = RectangleInfo(id: UUID(), position: constantPosition, opacity: 1.0, content: AnyView(ShowView(action: {index in self.index = index},theme: .indigoWhite)))
        case 5:
            view = RectangleInfo(id: UUID(), position: constantPosition, opacity: 1.0, content: AnyView(ShowView(action: {index in self.index = index},theme: .tealAccent)))
        default:
            break
        }
        
        if var newRectangle = view {
            if rectangles.count < 5  {
                for index in stride(from: rectangles.count - 1, through: 0, by: -1) {
                    rectangles[index].position.x -= 10
                    rectangles[index].position.y += 10
                }
            } else {
                newRectangle.position.x = rectangles.first?.position.x ?? 0
                newRectangle.position.y = rectangles.first?.position.y ?? 0
            }
            rectangles.insert(newRectangle, at: 0)
        }
        position.append(false)
    }
    
    // MARK: - AppendingViewInArrayIpad
    
    func createViewArrayIpad(pressedView: Int) {
       
        let constantPosition = CGPoint(x: currentXPositionIpad, y: 0)
        var view: RectangleInfo?
        switch pressedView {
        case 0:
            view = RectangleInfo(id: UUID(), position: constantPosition, opacity: 1.0, content: AnyView(IpadView(updateIndex: { index in
                self.indexIpad = index
            }, theme: .redBlue)))
        case 1:
            view = RectangleInfo(id: UUID(), position: constantPosition, opacity: 1.0, content: AnyView(IpadView(updateIndex: { index in
                self.indexIpad = index
            }, theme: .greenBlue)))
        case 2:
            view = RectangleInfo(id: UUID(), position: constantPosition, opacity: 1.0, content: AnyView(IpadView(updateIndex: { index in
                self.indexIpad = index
            }, theme: .orangePurple)))
        case 3:
            view = RectangleInfo(id: UUID(), position: constantPosition, opacity: 1.0, content: AnyView(IpadView(updateIndex: { index in
                self.indexIpad = index
            }, theme: .purpleWhite)))
        case 4:
            view = RectangleInfo(id: UUID(), position: constantPosition, opacity: 1.0, content: AnyView(IpadView(updateIndex: { index in
                self.indexIpad = index
            }, theme: .indigoWhite)))
        case 5:
            view = RectangleInfo(id: UUID(), position: constantPosition, opacity: 1.0, content: AnyView(IpadView(updateIndex: { index in
                self.indexIpad = index
            }, theme: .tealAccent)))
        default:
            view = RectangleInfo(id: UUID(), position: constantPosition, opacity: 1.0, content: AnyView(IpadView(updateIndex: { index in
                self.indexIpad = index
            }, theme: .redBlue)))
        }
        
        if var newRectangle = view {
           
            if rectanglesIpad.count < 5  {
                for index in stride(from: rectanglesIpad.count - 1, through: 0, by: -1) {
                    rectanglesIpad[index].position.x -= 15
                    rectanglesIpad[index].position.y += 15
                }
            } else {
                newRectangle.position.x = rectanglesIpad.first?.position.x ?? 0
                newRectangle.position.y = rectanglesIpad.first?.position.y ?? 0
            }
            rectanglesIpad.insert(newRectangle, at: 0)
        }
    }
    
    // MARK: - calculateOffsetIpadButton
    
    func calculateOffset(rectangle: CGRect, button: CGRect) -> (x: CGFloat, y: CGFloat) {
        let widthButton = button.width
        let heightButton = button.height
        let buttonX = button.origin.x
        let buttonY = button.origin.y
        
        let centerButtonX = buttonX + (widthButton / 2)
        let centerButtonY = buttonY + (heightButton / 2)
        
        
        let widthRectangle = rectangle.width
        let heightRectangle = rectangle.height
        let rectangleX = rectangle.origin.x
        let rectangleY = rectangle.origin.y
        
        let leadingButtonX = centerButtonX - (widthRectangle / 2)
        let topButtonY = centerButtonY - (heightRectangle / 2)
        
        var deltaX: CGFloat = 0
        var deltaY: CGFloat = 0
        
        deltaX = buttonX - leadingButtonX - abs(buttonX - rectangleX)
        deltaY = buttonY - topButtonY - abs(buttonY - rectangleY)

        return (deltaX, deltaY)
    }
}
