//
//  OutlinedTextFieldStyle.swift
//  Bookmarked
//
//  Created by Zachary Farmer on 7/16/25.
//

import SwiftUI
import Foundation


struct OutlinedTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.white)
            .foregroundColor(.black)
            .accentColor(.blue) // Cursor color
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(Color.gray, lineWidth: 2)
            }
    }
}
