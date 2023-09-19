//
//  UITableView+Extensions.swift
//  EmlakjetIndividual
//
//  Created by Yunus Emre Celebi on 8.10.2021.
//

import UIKit

extension UITableView {

    func makeMyDefaultTableView(forSeparatorStyle: UITableViewCell.SeparatorStyle = UITableViewCell.SeparatorStyle.none) -> UITableView {
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.separatorStyle = forSeparatorStyle
        return self
    }
}

extension UITableView {

    func reloadDataWithoutScrolling() {
        // reload data without scrolling top
        let currentOffset = contentOffset
        reloadData()
        layoutIfNeeded()
        DispatchQueue.main.async {
            self.setContentOffset(currentOffset, animated: false)
        }
    }

    func reloadSections(_ sections: IndexSet, with rowAnimation: RowAnimation, completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)

        self.reloadSections(sections, with: rowAnimation)

        CATransaction.commit()
    }
}


extension UITableView {

    func registerCell<T: BaseTableViewCell>(_ instance: T.Type) {
        self.register(instance.nibInstance, forCellReuseIdentifier: instance.reuseIdentifier)
    }

    func registerCellWithoutNib<T: BaseTableViewCell>(_ instance: T.Type) {
        self.register(instance.self, forCellReuseIdentifier: instance.reuseIdentifier)
    }

    func generateReusableCell<T: BaseTableViewCell>(_ instance: T.Type, indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: instance.reuseIdentifier, for: indexPath) as! T
    }

    func generateReusableCell<T: BaseTableViewCell>(_ instance: T.Type) -> T {
        return self.dequeueReusableCell(withIdentifier: instance.reuseIdentifier) as! T
    }

    func registerHeaderFooterView<T: BaseTableViewHeaderFooterView>(_ instance: T.Type) {
        self.register(T.self, forHeaderFooterViewReuseIdentifier: instance.reuseIdentifier)
    }

    func registerNibHeaderFooterView<T: BaseTableViewHeaderFooterView>(_ instance: T.Type) {
        self.register(UINib(nibName: "\(instance.self)", bundle: nil), forHeaderFooterViewReuseIdentifier: instance.reuseIdentifier)
    }

    func generateReusableHeaderFooterView<T: BaseTableViewHeaderFooterView>(_ instance: T.Type) -> T {
        return self.dequeueReusableHeaderFooterView(withIdentifier: instance.reuseIdentifier) as! T
    }

    func scrollTableViewToBottom(animated: Bool) {
        guard let dataSource = dataSource else { return }

        var lastSectionWithAtLeasOneElements = (dataSource.numberOfSections?(in: self) ?? 1) - 1

        while dataSource.tableView(self, numberOfRowsInSection: lastSectionWithAtLeasOneElements) < 1 {
            lastSectionWithAtLeasOneElements -= 1
        }

        let lastRow = dataSource.tableView(self, numberOfRowsInSection: lastSectionWithAtLeasOneElements) - 1

        guard lastSectionWithAtLeasOneElements > -1 && lastRow > -1 else { return }

        let bottomIndex = IndexPath(item: lastRow, section: lastSectionWithAtLeasOneElements)
        scrollToRow(at: bottomIndex, at: .bottom, animated: animated)
    }
}

// MARK: UITableViewCell+Extension
extension UITableViewCell {

    func visibleSeperator(isVisible: Bool) {
        if isVisible {
            separatorInset.left = 16 // default
        } else {
            separatorInset.left = UIScreen.main.bounds.size.width // ekranın dışına atarak, gizliyoruz.
        }
    }
}
