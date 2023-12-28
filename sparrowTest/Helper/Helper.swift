//
//  Extension.swift
//  sparrowTest
//
//  Created by Кизим Илья on 21.12.2023.
//

import SwiftUI

    //MARK: RectanglesInfo

struct RectangleInfo: Identifiable {
    let id: UUID
    var position: CGPoint
    var opacity: Double
    var content: AnyView?
}

    //MARK: ColorDependingOfIndex

extension Color {
    static func colorForIndex(_ index: Int) -> LinearGradient {
        switch index {
        case 0: return LinearGradient(colors: [.green, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
        case 1: return LinearGradient(colors: [.red, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
        case 2: return LinearGradient(colors: [.orange, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
        case 3: return LinearGradient(colors: [.purple, .white], startPoint: .topLeading, endPoint: .bottomTrailing)
        case 4: return LinearGradient(colors: [.indigo, .white], startPoint: .topLeading, endPoint: .bottomTrailing)
        case 5: return LinearGradient(colors: [.teal, .accentColor], startPoint: .topLeading, endPoint: .bottomTrailing)
        default: return LinearGradient(colors: [.teal, .accentColor], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}

    //MARK: CalculateOffsetForButton

extension CGFloat {
    static func calculateOffset(for index: Int, proxy: GeometryProxy) -> CGFloat {
        var offset: CGFloat = 0
        for _ in 0..<index {
            offset +=  proxy.size.width / 6
        }
        return offset
    }
}

    //MARK: PreferenceKey

struct BoundsPreferenceKey: PreferenceKey {
    static var defaultValue: CGRect?
    
    static func reduce(value: inout CGRect?, nextValue: () -> CGRect?) {
        value = value ?? nextValue()
    }
}

    //MARK: ButtonModel

struct ButtonModel {
    let gradientColors: [Color]
    let imageNames: String
}

enum Theme {
    case greenBlue
    case redBlue
    case orangePurple
    case purpleWhite
    case indigoWhite
    case tealAccent
    
    var buttonModel: ButtonModel {
        switch self {
        case .greenBlue: return ButtonModel(gradientColors: [.green, .blue], imageNames: "rectangle")
        case .redBlue: return ButtonModel(gradientColors: [.red, .blue], imageNames: "folder")
        case .orangePurple: return ButtonModel(gradientColors: [.orange, .purple], imageNames: "paperplane.fill")
        case .purpleWhite: return ButtonModel(gradientColors: [.purple, .white], imageNames: "externaldrive")
        case .indigoWhite: return ButtonModel(gradientColors: [.indigo, .white], imageNames: "archivebox.circle")
        case .tealAccent: return ButtonModel(gradientColors: [.teal, .accentColor], imageNames: "doc")
        }
    }
}
