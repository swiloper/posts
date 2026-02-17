//
//  QuickLookPresenter.swift
//  Files
//
//  Created by Ihor Myronishyn on 16.02.2026.
//

import SwiftUI
import QuickLook

public struct QuickLookPresenter: ViewModifier {
    
    // MARK: - Properties
    
    @Bindable private var manager: QuickLookManager
    
    private var isErrorAlertPresented: Binding<Bool> {
        Binding {
            manager.error != nil
        } set: {
            if !$0 {
                manager.dismiss()
            }
        }
    }
    
    // MARK: - Init
    
    public init(manager: QuickLookManager) {
        self.manager = manager
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        content
            .quickLookPreview($manager.selectedLocalFileURL, in: manager.state.value ?? [])
            .alert("Error", isPresented: isErrorAlertPresented) {
                Button("OK") {
                    manager.dismiss()
                } //: Button
            } message: {
                if let error = manager.error {
                    Text(error.localizedDescription)
                }
            }
    }
}

// MARK: - View

public extension View {
    func quickLook(using manager: QuickLookManager) -> some View {
        modifier(QuickLookPresenter(manager: manager))
    }
}
