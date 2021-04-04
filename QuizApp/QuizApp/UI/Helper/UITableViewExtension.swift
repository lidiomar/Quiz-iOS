//
//  UITableViewExtension.swift
//  QuizApp
//
//  Created by Lidiomar Fernando dos Santos Machado on 24/03/21.
//

import Foundation
import UIKit

extension UITableView {
    func register(_ type: UITableViewCell.Type) {
        let className = String(describing: type)
        self.register(UINib(nibName: className, bundle: nil), forCellReuseIdentifier: className)
    }
    
    func dequeueReusableCell<T>(_ type: T.Type) -> T? {
        let className = String(describing: type)
        let cell = self.dequeueReusableCell(withIdentifier: className) as? T
        return cell
    }
}
