//
//  SubjectsViewController.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 26.08.24.
//

import UIKit
import MyAssetBook
import Networking

class SubjectsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
        
    private var subjects: [SubjectEntity] = []
    private let tableView = UITableView()
    private let  service = Service()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchSubjects()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func fetchSubjects() {
        service.CallSubjectsService { [weak self] result in
            switch result {
            case .success(let subjects):
                self?.subjects = subjects
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch subjects: \(error)")
                // Handle error (e.g., show an alert)
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let subject = subjects[indexPath.row]
        cell.textLabel?.text = subject.subjectName ?? "No Name"
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let subject = subjects[indexPath.row]
        print("Selected subject: \(subject.subjectName ?? "No Name")")
        // Handle row selection (e.g., navigate to a detail view)
    }
}




extension SubjectsViewController: CustomNavigatable {
    var navTitle: NavigationTitle {
        .init(text: "საგნები")
    }
}
