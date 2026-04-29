import SwiftUI

struct DoodleView: View {
    @State private var lines: [[CGPoint]] = []
    @State private var currentLine: [CGPoint] = []
    var onInteract: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if lines.isEmpty && currentLine.isEmpty {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("Draw to anchor focus...")
                            .font(.headline)
                            .foregroundColor(.secondary.opacity(0.3))
                        Spacer()
                    }
                    Spacer()
                }
            }
            
            Canvas { context, size in
                for line in lines {
                    var path = Path()
                    path.addLines(line)
                    context.stroke(path, with: .color(.primary.opacity(0.4)), style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                }
                var activePath = Path()
                activePath.addLines(currentLine)
                context.stroke(activePath, with: .color(.primary.opacity(0.4)), style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
            }
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        currentLine.append(value.location)
                    }
                    .onEnded { _ in
                        lines.append(currentLine)
                        currentLine = []
                        onInteract() 
                    }
            )
            
            if !lines.isEmpty || !currentLine.isEmpty {
                Button(action: {
                    let impact = UIImpactFeedbackGenerator(style: .rigid)
                    impact.impactOccurred()
                    withAnimation(.easeInOut(duration: 0.2)) {
                        lines.removeAll()
                        currentLine.removeAll()
                    }
                }) {
                    Text("Clear")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.secondary.opacity(0.7))
                        .padding(.top, 16)
                        .padding(.trailing, 20)
                }
            }
        }
        .contentShape(Rectangle())
    }
}
