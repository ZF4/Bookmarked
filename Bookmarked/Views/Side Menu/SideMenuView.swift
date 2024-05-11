//
//  SideMenuView.swift
//  Bookmarked
//
//  Created by Zachary Farmer on 4/30/24.
//

import SwiftUI
import SwiftData

struct SideMenuView: View {
    //Refactor
    @AppStorage("bookGoalSet") var bookGoalSet: Bool = false
    @AppStorage("editBookGoal") var editBookGoal: Bool = true

    @Environment(\.modelContext) var modelContext
    @Query var bookGoal: [BookGoalModel]
    @State var bookGoalNumber: Int = 0
    @State var numOfBooksFinished: Int = 0
    @State var minusButtonDisabled: Bool = true
    @State var hasSetBookGoal: Bool = false
    @State var isEditing: Bool = false
    @State var eachBookEquals: CGFloat = 0
    @State var percentComplete: CGFloat = 0.0
    
    var body: some View {
        VStack {
            Image("lightModeLogo")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 70)
                .foregroundStyle(Color("logoColor"))
                .padding(.bottom, 35)
            
            if !editBookGoal {
                HStack {
                    Text("\(bookGoal[0].goalNumber)")
                    Divider()
                        .frame(width: 1, height: 20)
                    Text("\(bookGoal[0].currentNumber)")
                }
                HStack {
                    Button {
                        hasSetBookGoal = false
                        editBookGoal = true
                        bookGoalNumber = 0
                        checkIfBookNumIsZero()
                        resetBookGoal()
                    } label: {
                        Text("Reset")
                    }
                    .buttonStyle(BorderedButtonStyle())
                    
                    Button {
                        editBookGoal = true
                        isEditing = true
                    } label: {
                        Text("Edit")
                    }
                    .buttonStyle(BorderedButtonStyle())
                    
                }
                
            } else if isEditing {
                HStack {
                    Text("\(bookGoal[0].goalNumber)")
                    Divider()
                        .frame(width: 1, height: 20)
                    Text("\(bookGoal[0].currentNumber)")
                }
                VStack {
                    HStack {
                        Button {
                            bookGoalNumber -= 1
                            checkIfBookNumIsZero()
                        } label: {
                            Image(systemName: "minus.square.fill")
                                .font(.system(size: 25))
                        }
                        .disabled(minusButtonDisabled)
                        .padding(.trailing, 10)
                        
                        Text(String(bookGoalNumber))
                            .font(.system(size: 30))
                            .padding(.trailing, 10)
                        
                        Button {
                            bookGoalNumber += 1
                            checkIfBookNumIsZero()
                        } label: {
                            Image(systemName: "plus.app.fill")
                                .font(.system(size: 25))
                        }
                    }
                    Button {
                        updateBookGoal(newBookGoal: bookGoalNumber)
                        hasSetBookGoal = true
                        isEditing = false
                        editBookGoal = false
                    } label: {
                        Text("Update Book Goal")
                    }
                    .disabled(bookGoalNumber <= 0)
                    .buttonStyle(BorderedButtonStyle())
                }
                .onAppear {
                    if !bookGoal.isEmpty {
                        bookGoalNumber = bookGoal[0].goalNumber
                    }
                }
                
            } else {
                HStack {
                    Button {
                        bookGoalNumber -= 1
                        checkIfBookNumIsZero()
                    } label: {
                        Image(systemName: "minus.square.fill")
                            .font(.system(size: 25))
                    }
                    .disabled(minusButtonDisabled)
                    .padding(.trailing, 10)
                    
                    Text(String(bookGoalNumber))
                        .font(.system(size: 30))
                        .padding(.trailing, 10)
                    
                    Button {
                        bookGoalNumber += 1
                        checkIfBookNumIsZero()
                    } label: {
                        Image(systemName: "plus.app.fill")
                            .font(.system(size: 25))
                    }
                }
                .padding(.bottom, 15)
                .onAppear {
                    if !bookGoal.isEmpty {
                        bookGoalNumber = bookGoal[0].goalNumber
                    }
                }
                
                //MARK: SET BOOK GOAL
                Button {
                    createBookGoal()
                    hasSetBookGoal = true
                    editBookGoal = false
                } label: {
                    Text("Set Book Goal")
                }
                .disabled(bookGoalNumber <= 0)
                .buttonStyle(BorderedButtonStyle())
                
                
            }
            
            Spacer()
            
            Image("myLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 100)
            
            Text("\(getVersion())")
                .padding(.bottom)
                .fontWeight(.light)
            
        }
        .padding(.horizontal, 50)
        .background(Color.white)
        .ignoresSafeArea(edges: .bottom)
    }
    
    func updateBookGoal(newBookGoal: Int) {
        bookGoal[0].goalNumber = newBookGoal
    }
    
    func getVersion() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        return "v. \(version)"
    }
    
    func checkIfBookNumIsZero() {
        if bookGoalNumber == 0 {
            minusButtonDisabled = true
        } else if bookGoalNumber >= 1 {
            minusButtonDisabled = false
        }
    }
    
    func createBookGoal() {
        let newBookGoal = BookGoalModel(goalNumber: bookGoalNumber, currentNumber: 0)
        modelContext.insert(newBookGoal)
        bookGoalSet = true
    }
    
    func resetBookGoal() {
        bookGoal[0].currentNumber = 0
        bookGoal[0].goalNumber = 0
        bookGoalSet = false
        do {
            try modelContext.delete(model: BookGoalModel.self)
        } catch {
            print("Failed to delete all Book goals.")
        }
    }
}

#Preview {
    SideMenuView()
}
