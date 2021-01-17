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
    @State var presentChangeTintColor = false
    var body: some View {
        print("presentChangeTintColor \(presentChangeTintColor)")
        return NavigationView {
            VStack {
                List {
                    ForEach(SettingSection.allCases) { settingSection in
                        Section(header: Text(settingSection.description)) {
                            ForEach(settingSection.items) { item in
                                cellForItem(item)
                            }
                        }

                    }
                }
            }.sheet(isPresented: $presentChangeTintColor, content: {
                ColorPicker("select color", selection: ($settingData.tintColor), supportsOpacity: settingData.colorPickerSupportAlpha).frame( height: 200)
            })
        }.navigationTitle("Settings").navigationBarTitleDisplayMode(.automatic).navigationBarItems(trailing: Text("bar"))
    }
}

struct SwiftUISettings_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                SwiftUISettings(settingData: SettingsData())
            }
        }.previewDevice(.init(stringLiteral: "iPhone 8"))

    }
}

extension SwiftUISettings {
    func cellForItem(_ item: SettingsVC.Item) -> some View {
        switch item.valueType {
        case .bool:
            return  AnyView( switchCellForItem(item))
        case .empty :
            return AnyView( emptyCellForItem(item))
        case .select:
            return AnyView(selectCellForItem(item))
        default:
            return  AnyView(SwiftUISwitchCell(title: item.title, tintColor: .yellow, isOn: .constant(false)))
        }
    }

    func selectCellForItem(_ item: SettingsVC.Item) -> some View {
        switch item.title {
        case SettingSection.SplitVCOption.preferredDisplayMode.description:
            return AnyView(SwiftUIContextMenuCell(title: item.title, currentValue: $settingData.splitVCPreferredDisplayMode, allValues: UISplitViewController.DisplayMode.allModes))
        case SettingSection.VCOption.modalPresentationStyle.description:
            return AnyView(SwiftUIContextMenuCell(title: item.title, currentValue: $settingData.vcDefaultModalPresentationStyle, allValues: UIModalPresentationStyle.allStyles))

        case SettingSection.SplitVCOption.splitBehavior.description:
            return AnyView(SwiftUIContextMenuCell(title: item.title, currentValue: $settingData.splitVCSplitBehavior, allValues: UISplitViewController.SplitBehavior.all))

        default:
            fatalError()
        }
    }

    func emptyCellForItem(_ item: SettingsVC.Item) -> SwiftUITitleCell {
        switch item.title {
        case SettingSection.ColorOption.changeTintColor.description:
            return SwiftUITitleCell(title: item.title) {
                presentChangeTintColor.toggle()
            }

        case SettingSection.debug.description:
            return SwiftUITitleCell(title: item.title) {
                print("tap debug")
            }
        default:
            fatalError("un handled setting title \(item.title)")
        }
    }

    func switchCellForItem(_ item: SettingsVC.Item) -> SwiftUISwitchCell {
        switch item.title {
        case  SettingSection.ColorOption.supportAlpha.description:
            return SwiftUISwitchCell(title: item.title, tintColor: settingData.tintColor, isOn: $settingData.colorPickerSupportAlpha)
        case SettingSection.SplitVCOption.showSecondaryOnlyButton.description:
            return SwiftUISwitchCell(title: item.title, tintColor: settingData.tintColor, isOn: $settingData.splitVCShowSecondaryOnlyButton)

        case SettingSection.SplitVCOption.presentsWithGesture.description:
            return SwiftUISwitchCell(title: item.title, tintColor: settingData.tintColor, isOn: $settingData.splitVCPresentsWithGesture)
        case SettingSection.useSwiftUI.description:
            return SwiftUISwitchCell(title: item.title, tintColor: settingData.tintColor, isOn: $settingData.useSwiftUISettings)
        default:
            fatalError("not implemented toggle for \(item.title)")
        }
    }
}
