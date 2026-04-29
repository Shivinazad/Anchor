import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome = false
    
    @State private var showingFilePicker = false
    @State private var selectedPDFUrl: URL?
    
    @StateObject private var audioManager = AudioManager()
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "books.vertical.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue.opacity(0.8))
                .shadow(color: .blue.opacity(0.2), radius: 10, x: 0, y: 5)
            
            Text("Ready to Focus.")
                .font(.title2.weight(.bold))
            
            Text("Import a dense PDF to enter your deep reading environment.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.bottom, 10)
            
            Button(action: {
                let impact = UIImpactFeedbackGenerator(style: .light)
                impact.impactOccurred()
                showingFilePicker = true
            }) {
                Text("Open a PDF")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: 250)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .cornerRadius(14)
                    .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemGroupedBackground))
        
        
        .sheet(isPresented: Binding(
            get: { !hasSeenWelcome && selectedPDFUrl == nil },
            set: { _ in }
        )) {
            WelcomeView(
                showingFilePicker: $showingFilePicker,
                showWelcomeSheet: Binding(
                    get: { !hasSeenWelcome },
                    set: { if !$0 { hasSeenWelcome = true } }
                )
            )
            .interactiveDismissDisabled()
        }
        .fileImporter(
            isPresented: $showingFilePicker,
            allowedContentTypes: [UTType.pdf],
            allowsMultipleSelection: false
        ) { result in
            if let selectedFile = try? result.get().first,
               selectedFile.startAccessingSecurityScopedResource() {
                selectedPDFUrl = selectedFile
            }
        }
        .fullScreenCover(isPresented: Binding(
            get: { selectedPDFUrl != nil },
            set: { if !$0 { selectedPDFUrl = nil } }
        )) {
            if let url = selectedPDFUrl {
                ReadingView(url: url, audioManager: audioManager, rootPDFUrl: $selectedPDFUrl)
            }
        }
    }
}
