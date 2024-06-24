//
//  UberSwiftUIApp.swift
//  UberSwiftUI
//
//  Created by Shivankit on 23/06/24.
//

import SwiftUI

@main
struct UberSwiftUIApp: App {
    let persistenceController = PersistenceController.shared
    
    @StateObject var locationViewModel = LocationSearchViewModel()
    var body: some Scene {
        WindowGroup {
           HomeView()
                .environmentObject(locationViewModel)
        }
    }
}
