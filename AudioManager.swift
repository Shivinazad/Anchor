import Foundation
import AVFoundation
import UIKit

@MainActor
class AudioManager: ObservableObject {
    var audioPlayer: AVAudioPlayer?

    init() {
        do {
            
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session setup failed: \(error)")
        }
    }

    func playSound(named soundName: String?) {
        
        guard let soundName = soundName, soundName != "none" else {
            audioPlayer?.setVolume(0, fadeDuration: 0.8)
            
            
            Task {
                try? await Task.sleep(nanoseconds: 800_000_000)
                self.audioPlayer?.stop()
            }
            return
        }

        
        guard let soundAsset = NSDataAsset(name: soundName) else {
            print("CRITICAL ERROR: Cannot find '\(soundName)' in the Media Catalog. Did you name the Data Set exactly '\(soundName)'?")
            return
        }

        
        do {
            audioPlayer?.stop()
            audioPlayer = try AVAudioPlayer(data: soundAsset.data)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.volume = 1.0
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Playback error: \(error.localizedDescription)")
        }
    }
    
    
    func stopImmediately() {
        audioPlayer?.stop()
    }
}
