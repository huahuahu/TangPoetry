//
//  SwiftUISwitchCell.swift
//  TangPoetry
//
//  Created by tigerguo on 2021/1/8.
//  Copyright © 2021 huahuahu. All rights reserved.
//

import SwiftUI
import Combine

struct SwiftUISwitchCell: View {
    let title: String
    var tintColor: Color
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            Toggle(isOn: $isOn, label: {
                Text(title)
            }).padding(.horizontal).toggleStyle(SwitchToggleStyle(tint: tintColor))
        }
    }
}

struct SwiftUISwitchCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SwiftUISwitchCell(title: "text", tintColor: .yellow, isOn: .constant(true))
                .previewDevice("iPad (8th generation)")
            SwiftUISwitchCell(title: "text", tintColor: (.black), isOn: .constant(true))
            SwiftUISwitchCell(title: "text", tintColor: (.blue), isOn: .constant(true))
            SwiftUISwitchCell(title: "text", tintColor: (.red), isOn: .constant(false))
        }.previewLayout(.fixed(width: 320, height: 100))
    }
}
