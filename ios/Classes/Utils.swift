enum DurationType {
    case Current
    case Max
}

struct Constants {
    static let methodChannelName = "simform_audio_waveforms_plugin/methods"
    static let audioWaveforms = "AudioWaveforms"
    static let startRecording = "startRecording"
    static let pauseRecording = "pauseRecording"
    static let stopRecording = "stopRecording"
    static let getDecibel = "getDecibel"
    static let checkPermission = "checkPermission"
    static let path = "path"
    static let encoder = "encoder"
    static let sampleRate = "sampleRate"
    static let bitRate = "bitRate"
    static let fileNameFormat = "YY-MM-dd-HH-mm-ss"
    static let resumeRecording = "resumeRecording"

    static let kAudioFormatMPEG4AAC = 0
    static let kAudioFormatMPEGLayer1 = 1
    static let kAudioFormatMPEGLayer2 = 2
    static let kAudioFormatMPEGLayer3 = 3
    static let kAudioFormatMPEG4AAC_ELD = 4
    static let kAudioFormatMPEG4AAC_HE = 5
    static let kAudioFormatOpus = 6
    static let kAudioFormatAMR = 7
    static let kAudioFormatAMR_WB = 8
    static let kAudioFormatLinearPCM = 9
    static let kAudioFormatAppleLossless = 10
    static let kAudioFormatMPEG4AAC_HE_V2 = 11

    static let readAudioFile = "readAudioFile"
    static let durationEventChannel = "durationEventChannel"
    static let startPlayer = "startPlayer"
    static let stopPlayer = "stopPlayer"
    static let pausePlayer = "pausePlayer"
    static let releasePlayer = "releasePlayer"
    static let seekTo = "seekTo"
    static let progress = "progress"
    static let setVolume = "setVolume"
    static let setRate = "setRate"
    static let rate = "rate"
    static let volume = "volume"
    static let finishMode = "finishMode"
    static let finishType = "finishType"
    static let getDuration = "getDuration"
    static let durationType = "durationType"
    static let preparePlayer = "preparePlayer"
    static let onCurrentDuration = "onCurrentDuration"
    static let current = "current"
    static let playerKey = "playerKey"
    static let stopAllPlayers = "stopAllPlayers"
    static let onDidFinishPlayingAudio = "onDidFinishPlayingAudio"
    static let extractWaveformData = "extractWaveformData"
    static let noOfSamples = "noOfSamples"
    static let onCurrentExtractedWaveformData = "onCurrentExtractedWaveformData"
    static let waveformData = "waveformData"
    static let onExtractionProgressUpdate = "onExtractionProgressUpdate"
    static let useLegacyNormalization = "useLegacyNormalization"
    static let updateFrequency = "updateFrequency"
    static let overrideAudioSession = "overrideAudioSession"
    static let resultFilePath = "resultFilePath"
    static let resultDuration = "resultDuration"
    static let linearPCMBitDepth = "linearPCMBitDepth";
    static let linearPCMIsBigEndian = "linearPCMIsBigEndian";
    static let linearPCMIsFloat = "linearPCMIsFloat";
    static let pauseAllPlayers = "pauseAllPlayers"
    static let stopExtraction = "stopExtraction"
}


/// Creates an 2D array of floats
public typealias FloatChannelData = [[Float]]

/// Extension to fill array with zeros
public extension RangeReplaceableCollection where Iterator.Element: ExpressibleByIntegerLiteral {
    init(zeros count: Int) {
        self.init(repeating: 0, count: count)
    }
}

enum FinishMode : Int{
    case loop = 0
    case pause = 1
    case stop = 2
}
