import SwiftUI

struct WelcomeView: View {
    @Binding var showingFilePicker: Bool
    @Binding var showWelcomeSheet: Bool

    var body: some View {
        VStack(spacing: 0) {
            Text("Welcome to\nAnchor")
                .font(.system(size: 40, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(.top, 60)
                .padding(.bottom, 50)
            
            VStack(spacing: 36) {
                
                FeatureRow(
                    icon: "scribble.variable",
                    title: "Doodle Canvas",
                    description: "Offload nervous energy onto a blank slate."
                )
                
                FeatureRow(
                    icon: "infinity",
                    title: "Infinity Trace",
                    description: "Relax your mind with a continuous, rule-less path."
                )
                
                FeatureRow(
                    icon: "waveform",
                    title: "Ambient Audio",
                    description: "Trigger deep study states with acoustic baselines."
                )
            }
            .padding(.horizontal, 32)
            
            Spacer()
            
            Button(action: {
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
                showWelcomeSheet = false
                showingFilePicker = true
            }) {
                Text("Continue")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .cornerRadius(14)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 30)
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 32, weight: .light))
                .foregroundColor(.blue)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                Text(description)
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
    }
}
