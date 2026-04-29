import SwiftUI


class SessionManager: ObservableObject {
    @Published var activeTime: TimeInterval = 0
    @Published var maxStreak: TimeInterval = 0
    @Published var fidgetCount: Int = 0
    
    private var currentStreak: TimeInterval = 0
    private var segmentStart: Date? = nil
    
    func start() {
        if segmentStart == nil { segmentStart = Date() }
    }
    
    func pause() {
        guard let start = segmentStart else { return }
        let elapsed = Date().timeIntervalSince(start)
        activeTime += elapsed
        currentStreak += elapsed
        if currentStreak > maxStreak { maxStreak = currentStreak }
        segmentStart = nil
    }
    
    func registerFidget() {
        pause()
        fidgetCount += 1
        currentStreak = 0
        start()
    }
}


struct ReadingView: View {
    let url: URL
    @ObservedObject var audioManager: AudioManager
    @Binding var rootPDFUrl: URL?
    
    @State private var isDoodleEnabled = false
    @State private var isTraceEnabled = false
    @AppStorage("selectedAudio") private var selectedAudio = "none"
    
    @State private var showSettings = false
    @State private var showSummarySheet = false
    
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject private var session = SessionManager()
    @State private var isSessionEnded = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                Color(uiColor: .secondarySystemGroupedBackground).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    PDFKitView(url: url)
                        .frame(height: (isDoodleEnabled || isTraceEnabled) ? geo.size.height * 0.6 : geo.size.height)
                    
                    if isDoodleEnabled || isTraceEnabled {
                        Rectangle()
                            .fill(Color.primary.opacity(0.15))
                            .frame(height: 1)
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: -2)
                        
                        ZStack {
                            if isDoodleEnabled { DoodleView(onInteract: { session.registerFidget() }) }
                            else if isTraceEnabled { InfinityTraceView(onInteract: { session.registerFidget() }) }
                        }
                        .frame(height: geo.size.height * 0.4)
                        .background(Color(uiColor: .systemGray6).shadow(.inner(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)))
                    }
                }
                
                
                HStack {
                    Button(action: {
                        session.pause()
                        showSummarySheet = true
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.primary)
                            .padding(.vertical, 12)
                    }
                    Spacer()
                    Button(action: { showSettings = true }) {
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.primary)
                            .padding(.vertical, 12)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 40)
                .background(.ultraThinMaterial)
                .ignoresSafeArea(edges: .top)
            }
        }
        .onAppear {
            session.start()
            audioManager.playSound(named: selectedAudio == "none" ? nil : selectedAudio)
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                if !showSummarySheet && !isSessionEnded { session.start() }
            } else if newPhase == .background || newPhase == .inactive {
                session.pause()
            }
        }
        .sheet(isPresented: $showSettings) {
            FocusControlCenter(
                isDoodleEnabled: $isDoodleEnabled,
                isTraceEnabled: $isTraceEnabled,
                audioManager: audioManager
            ).presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showSummarySheet, onDismiss: {
            if !isSessionEnded { session.start() }
        }) {
            SessionSummarySheet(
                session: session,
                onReturnHome: {
                    isSessionEnded = true
                    showSummarySheet = false
                    audioManager.stopImmediately()
                    rootPDFUrl = nil
                },
                onContinueReading: {
                    showSummarySheet = false
                }
            )
            .presentationDetents([.medium])
        }
    }
}


struct SessionSummarySheet: View {
    @ObservedObject var session: SessionManager
    let onReturnHome: () -> Void
    let onContinueReading: () -> Void
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        if minutes == 0 { return "\(seconds)s" }
        return "\(minutes)m \(seconds)s"
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                
                HStack(alignment: .bottom, spacing: 0) {
                    
                    SideMetricVStack(title: "Active Time", value: formatTime(session.activeTime))
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 2)
                    
                    
                    CenterMetricVStack(title: "Anchors", value: "\(session.fidgetCount)", iconName: "bolt.fill")
                        .frame(maxWidth: .infinity)
                    
                    
                    SideMetricVStack(title: "Best Streak", value: formatTime(session.maxStreak))
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 2)
                }
                .padding(.horizontal, 10)
                .padding(.top, 50)
                .padding(.bottom, 40)
                
                Spacer()
                
                
                VStack(spacing: 12) {
                    Button(action: onContinueReading) {
                        Text("Continue Reading")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.secondary.opacity(0.15))
                            .cornerRadius(14)
                    }
                    
                    Button(action: onReturnHome) {
                        Text("End Session")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.red)
                            .cornerRadius(14)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 30)
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("Session Progress")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: MetricDetailsView()) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 18, weight: .medium))
                    }
                }
            }
        }
    }
}




struct CenterMetricVStack: View {
    let title: String
    let value: String
    let iconName: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: iconName)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.blue)
                .padding(.bottom, 4)
            
            Text(value)
                .font(.system(size: 46, weight: .heavy, design: .rounded))
                .foregroundColor(.primary)
            
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.blue)
        }
    }
}


struct SideMetricVStack: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.secondary)
            
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.secondary)
        }
    }
}




struct MetricDetailsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                InfoDefinitionRow(title: "Active Time", description: "Total time spent reading during this session.")
                InfoDefinitionRow(title: "Best Streak", description: "Your longest unbroken focus without needing a tactile anchor.")
                InfoDefinitionRow(title: "Anchors Used", description: "Times you successfully redirected nervous energy into the app.")
            }
            .padding(32)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct InfoDefinitionRow: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
            Text(description)
                .font(.system(size: 15))
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(4)
        }
    }
}
