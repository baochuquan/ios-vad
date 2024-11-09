//
//  SampleRateView.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import SwiftUI

struct SampleRateView: View {
    @Environment(ContentData.self) var data

    var type: VADType
    var config: SampleRateConfiguration

    var index: Int {
        data.configs.firstIndex(where: { $0.type == type })!
    }

    var body: some View {
        @Bindable var data = data

        VStack {
            HStack {
                Text("Sample Rate")
                    .font(.subheadline)
                Spacer()
                Picker(selection: $data.configs[index].sampleRate, label: Text("Sample Rate")) {
                    ForEach(config.options, id: \.self) { option in
                        Text(option.desc).tag(option)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding(EdgeInsets())
            }
        }
        .background()
        .padding()
    }
}

#Preview {
    let data = ContentData()
    let config = data.configs[0]
    return SampleRateView(type: config.type, config: config.sampleRate).environment(data)
}