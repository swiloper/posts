//
//  ErrorContentUnavailableView.swift
//  Components
//
//  Created by Ihor Myronishyn on 15.02.2026.
//

import SwiftUI

public struct ErrorContentUnavailableView: View {
    
    // MARK: - Properties
    
    private let error: Error
    
    // MARK: - Init
    
    public init(error: Error) {
        self.error = error
    }
    
    // MARK: - Body
    
    public var body: some View {
        ContentUnavailableView("Error", systemImage: "exclamationmark.circle", description: Text(error.localizedDescription))
    }
}

// MARK: - Preview

#Preview {
    ErrorContentUnavailableView(error: URLError(.badURL))
}
