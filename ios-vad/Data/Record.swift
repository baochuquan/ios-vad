//
//  Test.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import Foundation

struct VADRecord: Hashable {
    enum State {
        case idle
        case work
    }

    let type: VADType
    let state: State

    func startRecord() {
        PermissionUtil.requestMicrophonePermission { result in
            guard result.granted else {
                fatalError()
            }
            print("HHHH: record")
        }
    }
}