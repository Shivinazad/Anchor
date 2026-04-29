import SwiftUI

struct InfinityTraceView: View {
    @State private var orbPosition: CGSize = .zero
    @State private var isDragging = false
    var onInteract: () -> Void
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(systemName: "infinity")
                    .font(.system(size: 140, weight: .ultraLight))
                    .foregroundColor(Color.primary.opacity(0.15))
                
                Circle()
                    .fill(Color(uiColor: .systemBackground).opacity(0.6))
                    .background(.ultraThinMaterial, in: Circle())
                    .overlay(Circle().stroke(LinearGradient(colors: [.white.opacity(0.8), .clear], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1.5))
                    .shadow(color: isDragging ? .blue.opacity(0.4) : .black.opacity(0.15), radius: isDragging ? 20 : 8, x: 0, y: isDragging ? 0 : 5)
                    .frame(width: 74, height: 74)
                    .offset(orbPosition)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if !isDragging {
                                    isDragging = true
                                    let impact = UIImpactFeedbackGenerator(style: .medium)
                                    impact.impactOccurred()
                                }
                                orbPosition = value.translation
                                
                                if Int(value.translation.width + value.translation.height) % 15 == 0 {
                                    let impact = UIImpactFeedbackGenerator(style: .light)
                                    impact.impactOccurred()
                                }
                            }
                            .onEnded { _ in
                                isDragging = false
                                let impact = UIImpactFeedbackGenerator(style: .rigid)
                                impact.impactOccurred()
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.65)) {
                                    orbPosition = .zero
                                }
                                onInteract() 
                            }
                    )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
        }
    }
}
