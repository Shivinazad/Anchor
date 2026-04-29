import SwiftUI

struct FocusControlCenter: View {
    @Binding var isDoodleEnabled: Bool
    @Binding var isTraceEnabled: Bool
    
    @AppStorage("selectedAudio") private var selectedAudio = "none"
    @ObservedObject var audioManager: AudioManager
    
    
    let soundLibrary = [
        ("rain", "Soft Rain", "cloud.rain.fill"),
        ("stream", "Deep Stream", "water.waves"),
        ("brown_noise", "Brown Noise", "waveform.path.ecg"),
        ("white_noise", "White Noise", "waveform"),
        ("pink_noise", "Pink Noise", "waveform.path"),
        ("ocean", "Ocean Waves", "wave.3.forward"),
        ("wind", "Forest Wind", "wind"),
        ("fire", "Crackling Fire", "flame.fill"),
        ("crickets", "Night Crickets", "moon.stars.fill"),
        ("cafe", "Cafe Murmur", "cup.and.saucer.fill"),
        ("library", "Quiet Library", "books.vertical.fill"),
        ("binaural", "Binaural Focus", "headphones")
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Kinetic Environment"), footer: Text("Choose a mindless physical outlet to anchor your working memory.")) {
                    Toggle(isOn: Binding(
                        get: { isDoodleEnabled },
                        set: { newValue in
                            isDoodleEnabled = newValue
                            if newValue { isTraceEnabled = false }
                        }
                    )) {
                        Label { Text("Doodle Canvas") } icon: {
                            Image(systemName: "scribble.variable").foregroundColor(.primary)
                        }
                    }
                    .tint(.blue)
                    
                    Toggle(isOn: Binding(
                        get: { isTraceEnabled },
                        set: { newValue in
                            isTraceEnabled = newValue
                            if newValue { isDoodleEnabled = false }
                        }
                    )) {
                        Label { Text("Infinity Trace") } icon: {
                            Image(systemName: "infinity").foregroundColor(.primary)
                        }
                    }
                    .tint(.blue)
                }
                
                Section(header: Text("Ambient Audio")) {
                    Button(action: {
                        selectedAudio = "none"
                        audioManager.playSound(named: "none")
                    }) {
                        HStack {
                            Image(systemName: "speaker.slash.fill")
                            Text("None")
                            Spacer()
                            if selectedAudio == "none" { Image(systemName: "checkmark").foregroundColor(.blue) }
                        }
                    }
                    .contentShape(Rectangle())
                    .foregroundColor(.primary)
                    
                    ForEach(soundLibrary, id: \.0) { sound in
                        Button(action: {
                            selectedAudio = sound.0
                            audioManager.playSound(named: sound.0) 
                        }) {
                            HStack(spacing: 16) {
                                Image(systemName: sound.2).font(.system(size: 20))
                                Text(sound.1)
                                Spacer()
                                if selectedAudio == sound.0 { Image(systemName: "checkmark").foregroundColor(.blue) }
                            }
                        }
                        .contentShape(Rectangle())
                        .foregroundColor(.primary)
                    }
                }
            }
            .navigationTitle("Focus Controls")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
