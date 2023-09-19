//
//  UICollectionView+Extensions.swift
//  EmlakjetIndividual
//
//  Created by Yunus Emre Celebi on 8.10.2021.
//

import UIKit

// MARK: creator
extension UICollectionView {
    
    func scrollToHorizontallyItem(index: Int, animated: Bool = true) {
        if self.numberOfItems(inSection: 0) > index {
            self.scrollToItem(at: .init(row: index, section: 0), at: .centeredHorizontally, animated: animated)
        }
    }

   /* func scrollToTop(animated: Bool = false) {
        let contentTopInset = contentInset.top
        let sectionTopInset = (collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset.top ?? 0
        self.setContentOffset(.init(x: 0, y: -(contentTopInset + sectionTopInset)), animated: animated)
    } */

    // MARK: TODO - biraz sorunlu çalışıyor daha sonra bakılacak. (Şuan iş görüyor)
    func didScrollHandleForPaginationListener(
        isLoading: inout Bool,
        maxResultCount: Int,
        skipOffsetCount: inout Int,
        loadItems: @escaping (() -> Void)
    ) {
        if contentSize.height == 0 { return }

        // if (isScrolledToBottomWithBuffer && !isLoading) {
        let height = frame.size.height
        let contentYoffset = contentOffset.y
        let distanceFromBottom = contentSize.height - contentYoffset
        if distanceFromBottom < height {
            if (!isLoading) {
                isLoading = true
                skipOffsetCount += maxResultCount
                setContentOffset(contentOffset, animated: false) // stop scroll

                print("general -> skipOffset: \(skipOffsetCount)")
                print("general -> maxResultCount: \(maxResultCount)")
                print("general -> #######> #######> #######> #######> #######")
                DispatchQueue.delay(1) {
                    loadItems()
                }
            }
        }
    }

    // base dynamic collection cell içinde cellWidth değeri var.
    // estimatedSize width ile cellWidth yakın değerler verilmeli
    static func createVerticalCollectionView(
        isSetDynamicSize: Bool = true,
        estimatedItemSize: CGSize = .init(width: UIScreen.main.bounds.size.width, height: 61),
        contentInset: UIEdgeInsets = .init(top: 20, left: 0, bottom: 0, right: 0))
        -> UICollectionView {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0

            if isSetDynamicSize {
                layout.itemSize = UICollectionViewFlowLayout.automaticSize
                layout.estimatedItemSize = .init(width: UIScreen.main.bounds.size.width, height: 61)
            }

            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.backgroundColor = .white
            collectionView.contentInset = contentInset

            collectionView.isPagingEnabled = false
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.showsVerticalScrollIndicator = false

            return collectionView
    }
}

extension UICollectionView {

    func deselectAllItems(animated: Bool = false) {
        for indexPath in self.indexPathsForSelectedItems ?? [] {
            self.deselectItem(at: indexPath, animated: animated)
        }
    }

    func registerCells<T: BaseCollectionViewCell>(_ instances: [T.Type]) {
        for instance in instances {
            self.registerCell(instance)
        }
    }
    
    func registerNibCell<T: BaseCollectionViewCell>(_ instance: T.Type) {
        self.register(UINib(nibName:"\(instance.self)",bundle:nil), forCellWithReuseIdentifier: instance.reuseIdentifier)
    }

    func registerCell<T: BaseCollectionViewCell>(_ instance: T.Type) {
        self.register(instance.self, forCellWithReuseIdentifier: instance.reuseIdentifier)
    }

    func registerHeader<T: BaseCollectionReusableView>(_ instance: T.Type) {
        self.register(instance.self,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: instance.reuseIdentifier)
    }

    func registerFooter<T: BaseCollectionReusableView>(_ instance: T.Type) {
        self.register(instance.self,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                      withReuseIdentifier: instance.reuseIdentifier)
    }

    func generateReusableCell<T: BaseCollectionViewCell>(_ instance: T.Type, indexPath: IndexPath) -> T {
        guard let cell =
            self.dequeueReusableCell(withReuseIdentifier: instance.reuseIdentifier, for: indexPath) as? T else {
                fatalError("cell not found -> \(instance.reuseIdentifier)")
        }

        return cell
    }

    func generateReusableHeader<T: BaseCollectionReusableView>(_ instance: T.Type, indexPath: IndexPath) -> T {
        guard let header = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: instance.reuseIdentifier, for: indexPath) as? T else {
            fatalError("header not found -> \(instance.reuseIdentifier)")
        }
        return header
    }

    func generateReusableFooter<T: BaseCollectionReusableView>(_ instance: T.Type, indexPath: IndexPath) -> T {
        guard let header = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: instance.reuseIdentifier, for: indexPath) as? T else {
            fatalError("header not found -> \(instance.reuseIdentifier)")
        }
        return header
    }
    
    func dequeueReusableCell<T: BaseCollectionViewCell> (forIndexPath indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath as IndexPath) as! T
    }
}

extension UICollectionView {

    var isScrolledToBottomWithBuffer: Bool {
        let buffer = bounds.height - contentInset.top - contentInset.bottom
        let maxVisibleY = contentOffset.y + bounds.size.height
        let actualMaxY = contentSize.height + contentInset.bottom
        return maxVisibleY + buffer >= actualMaxY
    }
}
