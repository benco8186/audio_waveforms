import Foundation

import AVKit

class AudioPlayer: NSObject, AVAudioPlayerDelegate {
    private var seekToStart = true
    private var stopWhenCompleted = false
    private var timer: Timer?
    private var player: AVAudioPlayer?
    private var finishMode:FinishMode = FinishMode.stop
    private var updateFrequency = 200
    var plugin: SwiftAudioWaveformsPlugin
    var playerKey: String
    var flutterChannel: FlutterMethodChannel
    

    init(plugin: SwiftAudioWaveformsPlugin, playerKey: String, channel: FlutterMethodChannel) {
        self.plugin = plugin
        self.playerKey = playerKey
        flutterChannel = channel
    }
    
    func preparePlayer(path: String?, volume: Double?, updateFrequency: Int?,result: @escaping FlutterResult, overrideAudioSession : Bool) {
        if(!(path ?? "").isEmpty) {
            self.updateFrequency = updateFrequency ?? 200
            let audioUrl = URL.init(string: path!)
            if(audioUrl == nil){
                result(FlutterError(code: Constants.audioWaveforms, message: "Failed to initialise Url from provided audio file", details: "If path contains `file://` try removing it"))
                return
            }
            do {
                stopPlayer()
                player = nil
                player = try AVAudioPlayer(contentsOf: audioUrl!)
                do {
                    if overrideAudioSession {
                        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                        try AVAudioSession.sharedInstance().setActive(true)
                    }
                } catch {
                    result(FlutterError(code: Constants.audioWaveforms, message: "Couldn't set audio session.", details: error.localizedDescription))

                }
                
            } catch {
                result(FlutterError(code: Constants.audioWaveforms, message: "Failed to prepare player", details: error.localizedDescription))
            }
            player?.enableRate = true
            player?.rate = 1.0
            player?.prepareToPlay()
            player?.volume = Float(volume ?? 1.0)
            result(true)
        } else {
            result(FlutterError(code: Constants.audioWaveforms, message: "Audio file path can't be empty or null", details: nil))
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer,successfully flag: Bool) {
        var finishType = 2

        switch self.finishMode{

        case .loop:
            self.player?.currentTime = 0
            self.player?.play()
            finishType = 0

        case .pause:
            self.player?.pause()
            stopListening()
            finishType = 1

        case .stop:
            self.player?.stop()
            stopListening()
            self.player = nil
            finishType = 2


        }
        
        plugin.flutterChannel.invokeMethod(Constants.onDidFinishPlayingAudio, arguments: [
            Constants.finishType: finishType,
            Constants.playerKey: playerKey])

    }

    func startPlyer(result: @escaping FlutterResult) {
        player?.play()
        player?.delegate = self
        startListening()
        result(true)
    }


    func pausePlayer() {
        stopListening()
        player?.pause()
    }
    
    func stopPlayer() {
        stopListening()
        player?.stop()
        timer = nil
    }
    
    func release(result: @escaping FlutterResult) {
        player = nil
        result(true)
    }
    
    func getDuration(_ type: DurationType, _ result: @escaping FlutterResult) throws {
        if type == .Current {
            let ms = (player?.currentTime ?? 0) * 1000
            result(Int(ms))
        } else {
            let ms = (player?.duration ?? 0) * 1000
            result(Int(ms))
        }
    }
    
    func setVolume(_ volume: Double?, _ result: @escaping FlutterResult) {
        player?.volume = Float(volume ?? 1.0)
        result(true)
    }

    func setRate(_ rate: Double?, _ result: @escaping FlutterResult) {
        player?.rate = Float(rate ?? 1.0);
        result(true)
    }

    func seekTo(_ time: Int?, _ result: @escaping FlutterResult) {
        if(time != nil) {
            player?.currentTime = Double(time! / 1000)
            sendCurrentDuration()
            result(true)
        } else {
            result(false)
        }
    }
    
    func setFinishMode(result : @escaping FlutterResult, releaseType : Int?){
        if(releaseType != nil && releaseType == 0){
            self.finishMode = FinishMode.loop
        }else if(releaseType != nil && releaseType == 1){
            self.finishMode = FinishMode.pause
        }else{
            self.finishMode = FinishMode.stop
        }
        result(nil)
    }

    func startListening() {
        if #available(iOS 10.0, *) {
            timer = Timer.scheduledTimer(withTimeInterval: (Double(updateFrequency) / 1000), repeats: true, block: { _ in
                self.sendCurrentDuration()
            })
        } else {
            // Fallback on earlier versions
        }
    }
    
    func stopListening() {
        timer?.invalidate()
        timer = nil
        sendCurrentDuration()
    }

    func sendCurrentDuration() {
        let ms = (player?.currentTime ?? 0) * 1000
        flutterChannel.invokeMethod(Constants.onCurrentDuration, arguments: [Constants.current: Int(ms), Constants.playerKey: playerKey])
    }
}
