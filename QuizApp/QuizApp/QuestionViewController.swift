//
//  QuestionViewController.swift
//  QuizApp
//
//  Created by Lidiomar Fernando dos Santos Machado on 21/03/21.
//

import UIKit

class QuestionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerLabel: UILabel!
    
    private let reusableIdentifier = "Cell"
    private var question = ""
    private var options = [String]()
    private var selection: (([String]) -> Void)? = nil
    
    convenience init(question: String, options: [String], selection: @escaping (([String]) -> Void)) {
        self.init()
        self.question = question
        self.options = options
        self.selection = selection
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerLabel.text = question
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = dequeueCell(in: tableView)
        tableViewCell.textLabel?.text = options[indexPath.row]
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.allowsMultipleSelection {
            selection?(selectedOptions(in: tableView))
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selection?(selectedOptions(in: tableView))
    }
    
    private func selectedOptions(in tableView: UITableView) -> [String] {
        guard let indexPaths = tableView.indexPathsForSelectedRows else { return [] }
        return indexPaths.map { options[$0.row] }
    }
    
    private func dequeueCell(in tableView: UITableView) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) {
            return cell
        }
        return UITableViewCell(style: .default, reuseIdentifier: reusableIdentifier)
    }
}
