import Foundation
import AVFoundation

class SoundManager: ObservableObject {
    static let shared = SoundManager()
    
    private var backgroundPlayer: AVAudioPlayer?
    private var soundEffectPlayer: AVAudioPlayer?
    
    @Published var isMuted: Bool = false
    @Published var backgroundVolume: Float = 0.3
    @Published var effectsVolume: Float = 0.7
    
    private init() {
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    // MARK: - Background Music
    
    func playBackgroundMusic() {
        guard !isMuted else { return }
        
        guard let url = Bundle.main.url(forResource: "background_sound", withExtension: "wav") else {
            print("Could not find background_sound.wav")
            return
        }
        
        do {
            backgroundPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundPlayer?.numberOfLoops = -1 // Loop indefinitely
            backgroundPlayer?.volume = backgroundVolume
            backgroundPlayer?.play()
        } catch {
            print("Error playing background music: \(error)")
        }
    }
    
    func stopBackgroundMusic() {
        backgroundPlayer?.stop()
        backgroundPlayer = nil
    }
    
    func pauseBackgroundMusic() {
        backgroundPlayer?.pause()
    }
    
    func resumeBackgroundMusic() {
        guard !isMuted else { return }
        backgroundPlayer?.play()
    }
    
    // MARK: - Sound Effects
    
    func playCardFlipSound() {
        playSoundEffect(named: "flip_sound", extension: "wav")
    }
    
    func playWinSound() {
        playSoundEffect(named: "win_sound", extension: "mp3")
    }
    
    func playLoseSound() {
        playSoundEffect(named: "lose_sound", extension: "mp3")
    }
    
    private func playSoundEffect(named fileName: String, extension fileExtension: String) {
        guard !isMuted else { return }
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            print("Could not find \(fileName).\(fileExtension)")
            return
        }
        
        do {
            soundEffectPlayer = try AVAudioPlayer(contentsOf: url)
            soundEffectPlayer?.volume = effectsVolume
            soundEffectPlayer?.play()
        } catch {
            print("Error playing sound effect \(fileName): \(error)")
        }
    }
    
    // MARK: - Volume Control
    
    func setBackgroundVolume(_ volume: Float) {
        backgroundVolume = max(0.0, min(1.0, volume))
        backgroundPlayer?.volume = backgroundVolume
    }
    
    func setEffectsVolume(_ volume: Float) {
        effectsVolume = max(0.0, min(1.0, volume))
    }
    
    func toggleMute() {
        isMuted.toggle()
        if isMuted {
            pauseBackgroundMusic()
        } else {
            resumeBackgroundMusic()
        }
    }
    
    // MARK: - Game-specific Sound Methods
    
    func playGameStartSound() {
        playBackgroundMusic()
    }
    
    func playGameEndSound(playerWon: Bool) {
        stopBackgroundMusic()
        if playerWon {
            playWinSound()
        } else {
            playLoseSound()
        }
    }
    
    func playRoundResult(playerWon: Bool, isTie: Bool) {
        if isTie {
            // Play a neutral sound for ties
            playCardFlipSound()
        } else if playerWon {
            playWinSound()
        } else {
            playLoseSound()
        }
    }
} 