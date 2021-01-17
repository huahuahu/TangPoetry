//
//  SwiftUIContextMenuCell.swift
//  TangPoetry
//
//  Created by tigerguo on 2021/1/17.
//  Copyright © 2021 huahuahu. All rights reserved.
//

import SwiftUI

struct SwiftUIContextMenuCell<T: CustomStringConvertible & Identifiable>: View {
    let title: String
    @Binding var currentValue: T
    let allValues: [T]

    var currentDescription: String {
        return "\($currentValue)"
    }
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(currentValue.description)
        }
        .edgesIgnoringSafeArea(.horizontal)
        .contextMenu(
            ContextMenu(menuItems: {
                ForEach(allValues) {
                    value in
                    Button(value.description) {
                        currentValue = value
                    }
                }

            })

        )

    }
}

struct SwiftUIContextMenuCell_Previews: PreviewProvider {
    enum TestEnum: String, CaseIterable, CustomStringConvertible, Identifiable {
        case name1
        case name2

        var id: String { description }
        var description: String {
            switch self {
            case .name1:
                return "name1"
            case .name2:
                return "name2"
            }
        }
    }

    static var previews: some View {
        SwiftUIContextMenuCell(title: "test", currentValue: .constant(TestEnum.name1), allValues: TestEnum.allCases)
    }
}
