//
//  DeletableTableViewDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 2/16/21.
//  Copyright © 2021 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class DeletableTableViewDelegate: NSObject {
    
    var viewController: UIViewController
    var tableView: UITableView
    
    var items = [Entity]()
    
    var undoToast: UIView?
    var shouldBeDeleted = true
    var deletedIndexPath: IndexPath?
    var deletedItem: Entity?
    
    init(viewController: UIViewController, tableView: UITableView, items: [Entity]?) {
        self.viewController = viewController
        self.tableView = tableView
        if let items = items {
            self.items = items
        }
        super.init()
        self.undoToast = getUndoToast()
    }
    
    func deleteItem(at indexPath: IndexPath, item: Entity) {
        setDeleted(indexPath: indexPath, item: item)
        deleteItemInTableView()
        showUndoToast()
    }
    
     func setDeleted(indexPath: IndexPath?, item: Entity?) {
        deletedIndexPath = indexPath
        deletedItem = item
    }
    
    @objc func undo() {
        shouldBeDeleted = false
        undoToast?.removeFromSuperview()
        insertItemInTableView()
        setDeleted(indexPath: nil, item: nil)
    }
    
    private func delete() {
        if let item = deletedItem {
            item.delete()
        }
        setDeleted(indexPath: nil, item: nil)
    }
    
    func deleteItemInTableView() {
        if let indexPath = deletedIndexPath {
            tableView.beginUpdates()
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    func insertItemInTableView() {
        if let item = deletedItem, let indexPath = deletedIndexPath {
            tableView.beginUpdates()
            items.insert(item, at: indexPath.row)
            tableView.insertRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    private func showUndoToast() {
        guard let undoToast = undoToast else {
            return
        }
        self.viewController.view.addSubview(undoToast)
        undoToast.alpha = 1
        UIView.animate(withDuration: 2.0, delay: 3, options: [.curveEaseOut, .allowUserInteraction], animations: {
            undoToast.alpha = 0.010000001 // can not be less :||||
        }, completion: {(isCompleted) in
            if self.shouldBeDeleted {
                undoToast.alpha = 1
                undoToast.removeFromSuperview()
                self.delete()
            }
            self.shouldBeDeleted = true
        })
    }

    private func getUndoToast() -> UIView {
        let toastView = getToastView()
        let toastLabel = getToastLabel(toastView: toastView)
        toastView.addSubview(toastLabel)
        let undoButton = getUndoButton(toastView: toastView)
        toastView.addSubview(undoButton)
        return toastView
    }
    
    private func getToastView() -> UIView {
        let toastView = UIView(frame: CGRect(x: 24, y: self.viewController.view.frame.size.height - 130, width: self.viewController.view.frame.size.width - 48, height: 44))
        toastView.backgroundColor = Color.navyBlue.componentColor
        toastView.alpha = 1.0
        toastView.layer.cornerRadius = 10;
        toastView.clipsToBounds = true
        return toastView
    }
    
    private func getToastLabel(toastView: UIView) -> UILabel {
        let toastLabel = UILabel(frame: CGRect(x: toastView.frame.size.width - (110 + 16), y: (toastView.frame.size.height - 25) / 2, width: 110, height: 25))
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont(name: "Vazir", size: 16)
        toastLabel.textAlignment = .center;
        toastLabel.text = "مورد حذف گردید."
        return toastLabel
    }
    
    private func getUndoButton(toastView: UIView) -> UIButton {
        let title = NSAttributedString(string: "بازگردانی", attributes: [NSAttributedString.Key.font: UIFont(name: "Vazir", size: 16)!, NSAttributedString.Key.foregroundColor: Color.lightGreen.componentColor])
        let undoButton = UIButton(type: .custom)
        undoButton.frame = CGRect(x: 16, y: (toastView.frame.size.height - 25) / 2, width: 65, height: 25)
        undoButton.setAttributedTitle(title, for: .normal)
        undoButton.addTarget(self, action: #selector(undo), for: .touchUpInside)
        return undoButton
    }
}

//TODO: Deleting 2 items immediately
