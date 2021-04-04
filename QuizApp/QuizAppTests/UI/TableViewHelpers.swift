//
//  TableViewHelpers.swift
//  QuizAppTests
//
//  Created by Lidiomar Fernando dos Santos Machado on 23/03/21.
//

import Foundation
import UIKit

extension UITableView {
    func cell(at row: Int) -> UITableViewCell? {
        let indexPath = IndexPath(row: row, section: 0)
        return self.dataSource?.tableView(self, cellForRowAt: indexPath)
    }
    
    func title(at row: Int) -> String? {
        return cell(at: row)?.textLabel?.text
    }
    
    func select(row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        self.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        self.delegate?.tableView?(self, didSelectRowAt: indexPath)
    }
    
    func deselect(row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        self.deselectRow(at: indexPath, animated: false)
        self.delegate?.tableView?(self, didDeselectRowAt: indexPath)
    }
}

