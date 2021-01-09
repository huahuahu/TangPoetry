//
//  SwiftUISettings.swift
//  TangPoetry
//
//  Created by tigerguo on 2021/1/6.
//  Copyright © 2021 huahuahu. All rights reserved.
//

import SwiftUI
import UIKit

struct SwiftUISettings: View {
    @ObservedObject var settingData: SettingsData
    var body: some View {
        return NavigationView {
            VStack {
                List {
                    ForEach(SettingSection.allCases) { settingSection in
                        Section(header: Text(settingSection.description)) {
                            ForEach(settingSection.swiftUICellModelsWith(settingData)) { cellModel -> SwiftUISwitchCell in
                                print("SwiftUISwitchCell for \(cellModel.title), value is \(settingData.uuid)")
                                return SwiftUISwitchCell(title: cellModel.title, showGreeting: $settingData.colorPickerSupportAlpha)
                            }
                        }

                    }
                }
            }
        }.navigationTitle("Settings").navigationBarTitleDisplayMode(.inline).navigationBarItems(trailing: Text("bar"))
    }
}

struct SwiftUISettings_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SwiftUISettings(settingData: SettingsData())
        }.previewDevice(.init(stringLiteral: "iPhone 8"))

    }
}

extension SwiftUISettings {
    struct CellModel: Identifiable {
        let title: String
        let secondaryText: String?
        let valueType: SettingSection.OptionType
        let id = UUID()
        @Binding var value: Any
    }
}
