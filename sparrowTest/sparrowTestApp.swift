//
//  sparrowTestApp.swift
//  sparrowTest
//
//  Created by Кизим Илья on 17.12.2023.
//

import SwiftUI

@main
struct sparrowTestApp: App {
    
    @StateObject var viewModel = ContentViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
