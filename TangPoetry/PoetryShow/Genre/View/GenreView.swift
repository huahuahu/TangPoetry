//
//  GenreView.swift
//  TangPoetry
//
//  Created by tigerguo on 2020/5/1.
//  Copyright © 2020 huahuahu. All rights reserved.
//

import UIKit

class GenreView: UIView {
    let collectionView: UICollectionView
    let collectionViewLayout: UICollectionViewLayout = CompositionalFlowLayout.demoCompositionalFlowLayout()
    var dataSource: CustomDataSource<Poem>!
    // swiftlint:disable weak_delegate
    private var dragDelegate: CollectionViewDragDelegate!
    private var dropDelegate: CollectionViewDropDelegate!
    // swiftlint:enable weak_delegate

    init() {
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: collectionViewLayout)
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        //        backgroundColor = .red
        addSubview(collectionView)
        setupConstraints()
        collectionView.backgroundColor = .systemBackground
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUp(with poems: [Poem]) {
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.reuseIdentifier)
        let models = [
            Array(poems.prefix(upTo: 5)),
            Array(poems.suffix(100))
        ]
        dataSource = CustomDataSource.init(models: models, modelToCellBlock: { (poem, indexPath) -> UICollectionViewCell in
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.reuseIdentifier, for: indexPath) as? CollectionCell
            cell?.setup(with: poem)
            return cell!
        })
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        //        collectionView.reloadData()
        dragDelegate = CollectionViewDragDelegate(collectionView: collectionView)
        collectionView.dragDelegate = dragDelegate
        dragDelegate.models = models

        dropDelegate = CollectionViewDropDelegate(collectionView: collectionView)
        collectionView.dropDelegate = dropDelegate
        dropDelegate.dataSource = dataSource
    }

    func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)

    }
}

extension GenreView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return nil
    }

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: "id" as NSCopying, previewProvider: nil) { _ -> UIMenu? in
            let editMenu = UIMenu(title: "edit..", children: [
                UIAction.init(title: "copy", handler: { (_) in
                    print("clicked copy")
                }),
                UIAction.init(title: "dup", handler: { (_) in
                    print("clicked dup")
                })
            ])

            return UIMenu(title: "", children: [
                UIAction(title: "Share") {_ in
                    print("clicked share")
                },
                editMenu,
                UIAction(title: "Delete") {_ in
                    print("clicked delete")
                }
            ])
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let poem = dataSource.models[indexPath.section][indexPath.row]
        if traitCollection.userInterfaceIdiom == .pad {
            let userActivity = poem.userActivity()
            let existingScene = UIApplication.shared.connectedScenes.first { (scene) -> Bool in
                guard let windowScene = scene as? UIWindowScene else {
                    return false
                }
                let tabVC = windowScene.windows.first?.rootViewController as? UITabBarController
                let navVC = tabVC?.selectedViewController as? UINavigationController
                let topVC = navVC?.topViewController as? DetailVC
                return topVC != nil
            }
            let options = UIScene.ActivationRequestOptions.init()
            options.requestingScene = collectionView.window?.windowScene
            UIApplication.shared.requestSceneSessionActivation(
                existingScene?.session,
                userActivity: userActivity,
                options: options
            ) { error in
                sceneLog("request scene \(error)")
            }
        } else {
            guard let scene = collectionView.window?.windowScene else {
                fatalError("no scene")
            }
            Route.goTo(poem: poem, scene: scene)
        }

    }
}
