import SwiftUI
import SwiftData
import TipKit

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("bookGoalSet") var bookGoalSet: Bool = false
    @AppStorage("editBookGoal") var editBookGoal: Bool = true
    @AppStorage("libraryName") var libraryName: String = ""
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    @Query var bookGoal: [BookGoalModel]
    @State var bookGoalNumber: Int = 0
    @State var numOfBooksFinished: Int = 0
    @State var minusButtonDisabled: Bool = true
    @State var hasSetBookGoal: Bool = false
    @State var isEditing: Bool = false
    @State var eachBookEquals: CGFloat = 0
    @State var percentComplete: CGFloat = 0.0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Header
            headerSection
            
            // Book Goal Section
            settingsSection(title: "Reading Goal") {
                bookGoalCard
            }
            
            // Library Name Section
            settingsSection(title: "Who's library is this?") {
                libraryNameCard
            }
            
            Spacer(minLength: 20)
            
            // Footer
            footerSection
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            HStack(spacing: 8) {
                Text("BOOKMARKED")
                    .fontWeight(.black)
                    .font(.system(size: 15))
                    .foregroundStyle(Color.black)
                
                Image("bookmarkedTrimmed")
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 15, height: 15)
                    .foregroundStyle(Color.black)
            }
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(Color.gray)
            }
        }
    }
    
    // MARK: - Settings Section Container
    private func settingsSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundStyle(Color.gray)
            
            content()
        }
    }
    
    // MARK: - Book Goal Card
    private var bookGoalCard: some View {
        VStack(spacing: 16) {
            if !editBookGoal && !bookGoal.isEmpty {
                currentGoalDisplay
                goalActionButtons
            } else if isEditing {
                editingGoalView
            } else {
                newGoalView
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private var currentGoalDisplay: some View {
        VStack(spacing: 8) {
            HStack(alignment: .center, spacing: 12) {
                Spacer()
                Text("\(bookGoal[0].currentNumber)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.black)
                
                Text("of")
                    .font(.title3)
                    .foregroundStyle(Color.gray)
                
                Text("\(bookGoal[0].goalNumber)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.black)
                Spacer()
            }
            
            Text("books completed")
                .font(.caption)
                .foregroundStyle(Color.gray)
        }
    }
    
    private var goalActionButtons: some View {
        HStack(spacing: 12) {
            Button("Reset") {
                resetBookGoal()
            }
            .buttonStyle(SecondaryButtonStyle())
            .frame(maxWidth: .infinity)
            .tint(.black)
            
            Button("Edit") {
                editBookGoal = true
                isEditing = true
            }
            .buttonStyle(SecondaryButtonStyle())
            .frame(maxWidth: .infinity)
            .tint(.black)
        }
    }
    
    private var editingGoalView: some View {
        VStack(spacing: 16) {
            Text("Update Goal")
                .font(.title3)
                .fontWeight(.medium)
            
            goalCounterView
            
            Button("Update Goal") {
                updateBookGoal(newBookGoal: bookGoalNumber)
                hasSetBookGoal = true
                isEditing = false
                editBookGoal = false
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(bookGoalNumber <= 0)
        }
        .onAppear {
            if !bookGoal.isEmpty {
                bookGoalNumber = bookGoal[0].goalNumber
            }
        }
    }
    
    private var newGoalView: some View {
        VStack(spacing: 16) {
            Text("Set Your Reading Goal")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(Color.black)
            
            goalCounterView
            
            Button("Set Goal") {
                createBookGoal()
                hasSetBookGoal = true
                editBookGoal = false
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(bookGoalNumber <= 0)
        }
        .onAppear {
            if !bookGoal.isEmpty {
                bookGoalNumber = bookGoal[0].goalNumber
            }
        }
    }
    
    private var goalCounterView: some View {
        HStack(spacing: 20) {
            Button {
                bookGoalNumber -= 1
                checkIfBookNumIsZero()
            } label: {
                Image(systemName: "minus.circle.fill")
                    .font(.title)
                    .foregroundStyle(.blue)
            }
            .disabled(minusButtonDisabled)
            
            Text("\(bookGoalNumber)")
                .font(.title)
                .fontWeight(.semibold)
                .frame(minWidth: 40)
                .foregroundStyle(Color.black)
            
            Button {
                bookGoalNumber += 1
                checkIfBookNumIsZero()
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.title)
                    .foregroundStyle(.blue)
            }
        }
    }
    
    // MARK: - Library Name Card
    private var libraryNameCard: some View {
        VStack(spacing: 16) {
            TextField("", text: $libraryName, prompt: Text("Amelia").foregroundStyle(Color.gray))
                .textFieldStyle(OutlinedTextFieldStyle())
                .tint(.black)
            
            Button("Save") {
                dismiss()
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    // MARK: - Footer Section
    private var footerSection: some View {
        VStack {
            Image("logoTrimmed")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 100)
            
            HStack {
                Spacer()
                Text(getVersion())
                    .font(.caption)
                    .foregroundStyle(Color.black)
                Spacer()
            }
        }
    }
    
    // MARK: - Functions
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
        hasSetBookGoal = false
        editBookGoal = true
        bookGoalNumber = 0
        checkIfBookNumIsZero()
        
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

// MARK: - Custom Button Styles
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.blue)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline)
            .foregroundColor(.black)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: BookModel.self, BookGoalModel.self, configurations: config)
        // Insert a sample BookGoalModel
        let context = container.mainContext
        let sampleGoal = BookGoalModel(goalNumber: 10, currentNumber: 2)
        context.insert(sampleGoal)
        return NavigationStack {
            ContentView()
                .task {
                    try? Tips.resetDatastore()
                    try? Tips.configure([
                        .datastoreLocation(.applicationDefault)
                    ])
                }
        }
        .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}
