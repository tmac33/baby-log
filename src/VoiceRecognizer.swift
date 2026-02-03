import Foundation
import Speech
import AVFoundation

final class VoiceRecognizer: NSObject, ObservableObject {
    @Published var transcript: String = ""
    @Published var isRecording: Bool = false
    @Published var errorMessage: String? = nil

    private let audioEngine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private var recognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh-CN"))

    func setLocale(_ locale: Locale) {
        recognizer = SFSpeechRecognizer(locale: locale)
    }

    func requestPermission(completion: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { auth in
            DispatchQueue.main.async {
                completion(auth == .authorized)
            }
        }
        AVAudioSession.sharedInstance().requestRecordPermission { ok in
            // mic permission handled separately
        }
    }

    func start() {
        errorMessage = nil
        transcript = ""
        task?.cancel()
        task = nil

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            errorMessage = "Audio session error: \(error.localizedDescription)"
            return
        }

        request = SFSpeechAudioBufferRecognitionRequest()
        guard let request = request else {
            errorMessage = "Unable to create request"
            return
        }
        request.shouldReportPartialResults = true

        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            request.append(buffer)
        }

        audioEngine.prepare()
        do {
            try audioEngine.start()
            isRecording = true
        } catch {
            errorMessage = "Audio engine failed: \(error.localizedDescription)"
            return
        }

        task = recognizer?.recognitionTask(with: request) { result, error in
            if let result = result {
                DispatchQueue.main.async {
                    self.transcript = result.bestTranscription.formattedString
                }
            }
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.stop()
                }
            }
        }
    }

    func stop() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        request?.endAudio()
        isRecording = false
    }
}
