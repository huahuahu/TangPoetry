//
//  SwiftUISwitchCell.swift
//  TangPoetry
//
//  Created by tigerguo on 2021/1/8.
//  Copyright © 2021 huahuahu. All rights reserved.
//

import SwiftUI

struct SwiftUISwitchCell: View {
    let title: String
    @Binding var showGreeting: Bool
    var body: some View {
        HStack {
            Toggle(isOn: $showGreeting, label: {
                Text(title)
            }).padding(.horizontal)
        }
    }
}

struct SwiftUISwitchCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SwiftUISwitchCell(title: "text", showGreeting: .constant(true))
            SwiftUISwitchCell(title: "text", showGreeting: .constant(true))
            SwiftUISwitchCell(title: "text", showGreeting: .constant(false))
        }.previewLayout(.fixed(width: 320, height: 100))

    }
}
