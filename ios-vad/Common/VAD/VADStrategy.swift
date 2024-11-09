//
//  VADStrategy.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import Foundation

public struct VADConfig {
    let type: VADType                           // VAD 类型，0：
    let minSpeechDuration: Int64            // 最小说话时长，单位：毫秒
    let maxPauseDuration: Int64             // 最大停顿时间，单位：毫秒

    static var defaultValue: VADConfig {
        return VADConfig(type: .silero, minSpeechDuration: 50, maxPauseDuration: 2000)
    }
}

enum AudioStream {
    case pcm(Data)           // PCM
}

protocol VADStrategy {
    func setup(minSilenceDurationMs: Int64, minSpeechDurationMs: Int64)
    func checkVAD(stream: AudioStream, handler: @escaping (VADState) -> Void)
    func currentState() -> VADState
}


// MARK: - SileroVADStrategy

class SileroVADStrategy: VADStrategy {
    // 采样率：16000Hz
    // pcm 10ms 回调一次
    // 声道数：1
    // 位深：16bit

    private let bufferSize: Int64 = 512 // 单位: 采样次数; 容量： 512 x 2 = 1024 bytes; 媒资 SDK 麦克风采集: 每 10ms 返回数据值 80 x 2 = 160 bytes。换算下来，每采集 7 次（70ms），做一次 vad 检测。
    private var sileroVAD: SileroVAD?
    private var silenceStart: Int = 0
    private var state: VADState = .silence
    private var handler: ((VADState) -> Void)?
    private var timer: Timer?
    private var pcmBuffer: [Float] = []

    func setup(minSilenceDurationMs: Int64, minSpeechDurationMs: Int64) {
        sileroVAD = SileroVAD(sampleRate: 16000, sliceSize: bufferSize, mode: .aggressive, minSilenceDurationMs: minSilenceDurationMs, minSpeechDurationMs: minSpeechDurationMs)
        sileroVAD?.delegate = self
    }

    func checkVAD(stream: AudioStream, handler: @escaping (VADState) -> Void) {
        guard case AudioStream.pcm(let pcm) = stream else { return }
        self.handler = handler
        let data: [Float] = pcm.int16Array().map { Float($0) / 32768.0 } // 归一化处理
        pcmBuffer += data
        // 判断缓存是否已满，如果已满，则调用 vad 判断
        let length = pcmBuffer.count
        if length >= bufferSize {
            let inputSize = Int(bufferSize)
            let input = Array(pcmBuffer.prefix(inputSize))
            pcmBuffer = Array(pcmBuffer.suffix(length - inputSize))
            predict(data: input)
        }
    }

    func currentState() -> VADState {
        return state
    }

    private func predict(data: [Float]) {
        do {
            try sileroVAD?.predict(data: data)
        } catch _ {
            fatalError()
        }
    }
}

extension SileroVADStrategy: SileroVADDelegate {
    func sileroVADDidDetectSpeechStart() {
        state = .start
        handler?(.start)
    }

    func sileroVADDidDetectSpeechEnd() {
        state = .end
        handler?(.end)
    }

    func sileroVADDidDetectSilence() {
        state = .silence
        handler?(.silence)
    }

    func sileroVADDidDetectSpeeching() {
        state = .speeching
        handler?(.speeching)
    }
}