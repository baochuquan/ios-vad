//
//  ContentViewModel.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import Foundation


@Observable
class ContentData {
    var selection: VADType = .webRTC

    var configs = [
        // WebRTC
        Configuration(
            type: VADType.webRTC,
            sampleRate: SampleRateConfiguration(
                selectedOption: .rate_8k,
                options: [
                    .rate_8k,
                    .rate_16k,
                    .rate_32k,
                    .rate_48k
                ]
            ),
            frameSize: FrameSizeConfiguration(
                selectedOption: .size_240,
                options: [
                    .size_80,
                    .size_160,
                    .size_240
                ]
            ),
            mode: ModeConfiguration(
                selectedOption: .very_aggressive,
                options: [
                    .normal,
                    .low_bitrate,
                    .aggressive,
                    .very_aggressive
                ]
            )
        ),

        // Silero
        Configuration(
            type: VADType.silero,
            sampleRate: SampleRateConfiguration(
                selectedOption: .rate_8k,
                options: [
                    .rate_8k,
                    .rate_16k
                ]
            ),
            frameSize: FrameSizeConfiguration(
                selectedOption: .size_256,
                options: [
                    .size_256,
                    .size_512,
                    .size_768
                ]
            ),
            mode: ModeConfiguration(
                selectedOption: .normal,
                options: [
                    .normal,
                    .aggressive,
                    .very_aggressive
                ]
            )
        ),

        // Yamnet
        Configuration(
            type: VADType.yamnet,
            sampleRate: SampleRateConfiguration(
                selectedOption: .rate_16k,
                options: [
                    .rate_8k,
                    .rate_16k
                ]
            ),
            frameSize: FrameSizeConfiguration(
                selectedOption: .size_240,
                options: [
                    .size_240,
                    .size_512,
                    .size_768
                ]
            ),
            mode: ModeConfiguration(
                selectedOption: .normal,
                options: [
                    .normal,
                    .aggressive,
                    .very_aggressive
                ]
            )
        )
    ]
}
