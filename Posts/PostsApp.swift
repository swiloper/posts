//
//  PostsApp.swift
//  Posts
//
//  Created by Ihor Myronishyn on 13.02.2026.
//

import Trends
import Search
import SwiftUI

@main
struct PostsApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("Trends", systemImage: "chart.line.uptrend.xyaxis") {
                    TrendsView()
                } //: Tab
                
                Tab("Search", systemImage: "magnifyingglass", role: .search) {
                    SearchView()
                } //: Tab
            } //: TabView
        } //: WindowGroup
    }
}
