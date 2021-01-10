//
//  SwiftUITitleCell.swift
//  TangPoetry
//
//  Created by tigerguo on 2021/1/10.
//  Copyright © 2021 huahuahu. All rights reserved.
//

import SwiftUI

struct SwiftUITitleCell: View {
    let title: String
    let onTap: () -> Void

    var body: some View {
        HStack {
            Text(title)
                .multilineTextAlignment(.leading)
                .padding(.leading)

            Spacer()
        }
        .onTapGesture {
            onTap()
        }
    }
}

struct SwiftUITitleCell_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUITitleCell(title: "test") {
            print("tapped")
        }
    }
}
