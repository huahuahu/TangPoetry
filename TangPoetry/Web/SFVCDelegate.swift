//
//  SFVCDelegate.swift
//  TangPoetry
//
//  Created by huahuahu on 2020/8/6.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import Foundation
import SafariServices

class SFVCDelegate: NSObject, SFSafariViewControllerDelegate {

    /** @abstract Called when the view controller is about to show UIActivityViewController after the user taps the action button.
        @param URL the URL of the web page.
        @param title the title of the web page.
        @result Returns an array of UIActivity instances that will be appended to UIActivityViewController.
     */
    func safariViewController(_ controller: SFSafariViewController, activityItemsFor URL: URL, title: String?) -> [UIActivity] {
        HLog.log(scene: .sfvc, str: "\(#function)")
        let activity = TestActivity()
        return [activity]
    }

    /** @abstract Allows you to exclude certain UIActivityTypes from the UIActivityViewController presented when the user taps the action button.
        @discussion Called when the view controller is about to show a UIActivityViewController after the user taps the action button.
        @param URL the URL of the current web page.
        @param title the title of the current web page.
        @result Returns an array of any UIActivityType that you want to be excluded from the UIActivityViewController.
     */
    @available(iOS 11.0, *)
    func safariViewController(_ controller: SFSafariViewController, excludedActivityTypesFor URL: URL, title: String?) -> [UIActivity.ActivityType] {
        HLog.log(scene: .sfvc, str: "\(#function)")
        return []
    }

    /** @abstract Delegate callback called when the user taps the Done button. Upon this call, the view controller is dismissed modally. */
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        HLog.log(scene: .sfvc, str: "safariViewControllerDidFinish")
    }

    /** @abstract Invoked when the initial URL load is complete.
        @param didLoadSuccessfully YES if loading completed successfully, NO if loading failed.
        @discussion This method is invoked when SFSafariViewController completes the loading of the URL that you pass
        to its initializer. It is not invoked for any subsequent page loads in the same SFSafariViewController instance.
     */
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        HLog.log(scene: .sfvc, str: "\(#function)")
    }

    /** @abstract Called when the browser is redirected to another URL while loading the initial page.
        @param URL The new URL to which the browser was redirected.
        @discussion This method may be called even after -safariViewController:didCompleteInitialLoad: if
        the web page performs additional redirects without user interaction.
     */
    @available(iOS 11.0, *)
    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
        HLog.log(scene: .sfvc, str: "\(#function)")
    }

    /** @abstract Called when the user opens the current page in the default browser by tapping the toolbar button.
     */
    @available(iOS 14.0, *)
    func safariViewControllerWillOpenInBrowser(_ controller: SFSafariViewController) {
        HLog.log(scene: .sfvc, str: "\(#function)")
    }
}

private final class TestActivity: UIActivity {
    override var activityTitle: String? {
        return "testActivity"
    }

    override var activityType: UIActivity.ActivityType? {
        return UIActivity.ActivityType(rawValue: "testType")
    }

    override var activityImage: UIImage? {
        return nil
    }

    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return true
    }

    override func prepare(withActivityItems activityItems: [Any]) {
        print("\(#function)")
    }

    override class var activityCategory: UIActivity.Category {
        return .action
    }

    override func perform() {
        print("activity called perfrom")
    }

    override func activityDidFinish(_ completed: Bool) {
        print("activityDidFinish \(completed)")
    }
}
