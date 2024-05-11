//
//  CustomProgressBar.swift
//  Bookmarked
//
//  Created by Zachary Farmer on 5/7/24.
//

import SwiftUI
import SwiftData

struct CustomProgressBar: View {
    @Query var bookGoal: [BookGoalModel]
    var value: CGFloat = 0.8
    
    var body: some View {
        VStack {
            HStack {
                ZStack(alignment: .leading) {
                    ZStack(alignment: .trailing) {
                        Capsule()
                            .fill(Color.black.opacity(0.08)).frame(height: 10)
                        
                    }
                    
                    Capsule()
                        .fill(LinearGradient(gradient: .init(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .frame(width: calculatePercent(), height: 10)
                    
                    
                }
                .padding(10)
                .background(Color.black.opacity(0.085))
                .clipShape(RoundedRectangle(cornerRadius: 15))
                
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.black.opacity(0.08)).frame(width: 45, height: 30)
                    
                    if bookGoal[0].currentNumber == bookGoal[0].goalNumber {
                        Text(String(format: "%.0f", self.value * 100) + "%")
                            .font(.caption).foregroundStyle(Color.yellow.opacity(0.75))
                    } else {
                        Text(String(format: "%.0f", self.value * 100) + "%")
                            .font(.caption).foregroundStyle(Color.gray.opacity(0.75))
                    }
                    
                }
            }
        }
        .padding(.horizontal)
    }
    
    func calculatePercent() -> CGFloat {
        let width = UIScreen.main.bounds.width - 90
        
        return width * self.value
    }
}

#Preview {
    CustomProgressBar()
}
