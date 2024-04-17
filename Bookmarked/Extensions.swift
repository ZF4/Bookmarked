//
//  Extensions.swift
//  Bookmarked
//
//  Created by Zachary Farmer on 3/18/24.
//

import Foundation
import UIKit
import SwiftUI

extension UIImage {
/// Initialize a new `UIImage` using data from an `ImageModel`.
///
/// - Parameters:
///   - model: The image model to load the image from.
///
    convenience init?(loadingDataFrom model: BookModel) {
        guard let data = model.imageData,
              data.isEmpty == false
        else {
            return nil
        }
        
        self.init(data: data)
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

extension View {
    @available(iOS 14, *)
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
        return self
    }
}

extension View {
    func underlineTextField() -> some View {
        self
            .padding(.vertical, 10)
            .overlay(Rectangle().frame(height: 2).padding(.top, 35))
            .foregroundColor(Color("lineColor"))
            .padding(10)
    }
}

//Dismiss all sheets
struct PresentationKey: EnvironmentKey {
    static let defaultValue: [Binding<Bool>] = []
}

extension EnvironmentValues {
    var presentations: [Binding<Bool>] {
        get { return self[PresentationKey.self] }
        set { self[PresentationKey.self] = newValue }
    }
}
