//
//  HDebugNetVC.swift
//  TangPoetry
//
//  Created by huahuahu on 2020/8/22.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import UIKit
import Foundation

class HDebugNetVC: UIViewController {
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .systemGroupedBackground
        textView.contentInset = .init(top: 5, left: 5, bottom: 5, right: 5)
        textView.font = .preferredFont(forTextStyle: .body)
        return textView
    }()

    private let restartButton: UIButton = {
        let button = UIButton()
        button.setTitle("restart", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configNav()
        configureView()
        restartButton.sendActions(for: .touchUpInside)
    }

    private func configNav() {
        navigationItem.title = "debug get"
    }

    private func configureView() {
        view.backgroundColor = .white
        let stackView = UIStackView(arrangedSubviews: [textView, restartButton])
        stackView.setCustomSpacing(20, after: textView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            textView.heightAnchor.constraint(equalToConstant: 200),
            textView.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -20)
        ])

        restartButton.addTarget(self, action: #selector(onRestartTapped), for: .touchUpInside)
    }

    @objc private func onRestartTapped() {
        print("onRestartTapped")
        textView.text = "Connecting ..."
        let url = URL.init(staticString: "https://www.tigerpro.org:8099/d")
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let error = error {
                HLog.log(scene: .debug, str: "net error: \(error)")
                self.textView.text = self.textView.text.appending("\n\(error)")
            } else if let data = data {
                let serverString = String(data: data, encoding: .utf8) ?? "nil"
                let mimeType = response?.mimeType ?? "nil"
                let displayText = "\nmimiType: \(mimeType)\nserverString: \(serverString)"
                DispatchQueue.main.async {
                    self.textView.text = self.textView.text.appending(displayText)
                }
            }
        }
        dataTask.resume()
    }
}
