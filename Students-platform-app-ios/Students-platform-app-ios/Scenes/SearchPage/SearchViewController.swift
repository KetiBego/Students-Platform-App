//
//  SubjectsViewController.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 26.08.24.
//

import UIKit
import MyAssetBook
import Networking
import Combine
class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CustomNavigatable {
        
    private var subjects: [SubjectEntity] = []
    private var filteredSubjects: [SubjectEntity] = []
    private let tableView = UITableView()
    private let  service = Service()
    private var subscriptions = Set<AnyCancellable>()

    
    private lazy var searchTextField: TextFieldView = {
        let textField = TextFieldView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let searchIcon: UIImageView = {
        let imageView = UIImageView(image: Icons.search.image.resizeImage(targetSize: .init(width: .XL4, height: .XL3))) // System search icon
       imageView.translatesAutoresizingMaskIntoConstraints = false
       imageView.tintColor = Color.Blue2 // Adjust color as needed
        
       return imageView
    }()
    
    
    // Container view for searchTextField and search icon
      private let searchContainerView: UIView = {
          let view = UIView()
          view.translatesAutoresizingMaskIntoConstraints = false
          view.backgroundColor = Color.Yellow2
          view.layer.cornerRadius = 8.0
          view.height(equalTo: .XL7)
          return view
      }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        view.backgroundColor = Color.background
        fetchSubjects()
        configureNavigationBar()
        navigationItem.hidesBackButton = true
        setupSearch()
    }
    
    private func setUp() {
        setupTableView()
        AddSubviews()
        addConstraints()

        searchTextField.bind(model: .init(
            placeholder: MytextBook.SearchTexts.search,
            onEditingDidEnd: { subject in
                print(subject)
        }))
    }
    
    private func setupSearch() {
        searchTextField.textPublisher
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main) // Add a delay to reduce the number of filter operations
            .sink { [weak self] searchText in
                self?.filterSubjects(with: searchText ?? "")
            }
            .store(in: &subscriptions)
    }
  
    private func filterSubjects(with searchText: String) {
            if searchText.isEmpty {
                filteredSubjects = subjects
            } else {
                filteredSubjects = subjects.filter { subject in
                    guard let subjectName = subject.subjectName else { return false }
                    return subjectName.lowercased().hasPrefix(searchText.lowercased())
                }
            }
            tableView.reloadData()
    }
    
    private func AddSubviews() {
        
        view.addSubview(searchContainerView)  // Add the container view to the main view
        searchContainerView.addSubview(searchTextField)  // Add searchTextField to container view
        searchContainerView.addSubview(searchIcon)  //
        view.addSubview(tableView)
    }
    
    private func addConstraints() {
        
        searchIcon.left(toView: searchContainerView, constant: .L)
        searchIcon.centerVertically(to: searchContainerView)
        searchTextField.centerVertically(to: searchContainerView)
        searchTextField.relativeLeft(toView: searchIcon, constant: .L)
        searchTextField.right(toView: searchContainerView)
        
        searchContainerView.top(toView: view, constant: .XL)
        searchContainerView.left(toView: view, constant: .XL)
        searchContainerView.right(toView: view, constant: .XL)
        
        tableView.relativeTop(toView: searchContainerView, constant: .XL2)
        tableView.left(toView: view)
        tableView.right(toView: view)
        tableView.bottom(toView: view)
    
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.topAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//        ])
//        NSLayoutConstraint.activate([
//            searchTextField.topAnchor.constraint(equalTo: view.topAnchor),
////            searchTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//        ])
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
       
        tableView.backgroundView?.backgroundColor = Color.background
        tableView.backgroundColor = Color.background
        tableView.dataSource = self
        tableView.delegate = self
        
        // Register your custom cell class
        tableView.register(SubjectTableViewCell.self, forCellReuseIdentifier: "SubjectCell")
    }
    
    private func fetchSubjects() {
        service.CallSubjectsService { [weak self] result in
            switch result {
            case .success(let subjects):
                self?.subjects = subjects
                self?.filteredSubjects = subjects
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
        return filteredSubjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectCell", for: indexPath) as? SubjectTableViewCell else {
            return UITableViewCell()
        }
        
        let subject = filteredSubjects[indexPath.row]
        cell.configure(with: subject)
        
        cell.moreButtonTapped = { [weak self] in
            self?.handleMoreButtonTapped(for: subject)
        }
        
        return cell
    }
    
    private func handleMoreButtonTapped(for subject: SubjectEntity) {
         // Handle the action for the more button tap
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
        let firstAction = UIAlertAction(title: MytextBook.SearchTexts.addSubject, style: .default) { _ in
                print("Action 1 tapped")
                // Add your action 1 code here
            }
            
        let secondAction = UIAlertAction(title: MytextBook.SearchTexts.deleteSubject, style: .default) { _ in
                print("Action 2 tapped")
                // Add your action 2 code here
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            alertController.addAction(firstAction)
            alertController.addAction(secondAction)
            alertController.addAction(cancelAction)
            
            // Present the action sheet
            if let topController = UIApplication.shared.windows.first?.rootViewController {
                topController.present(alertController, animated: true, completion: nil)
            }
     }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return .XL8 // Set your desired height
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let subject = subjects[indexPath.row]
        print("Selected subject: \(subject.subjectName ?? "No Name")")
        // Handle row selection (e.g., navigate to a detail view)
    }
    

}

extension SearchViewController {
    var navTitle: NavigationTitle {
        .init(text: "ყველა საგანი", color: Color.Blue1)
    }
    var leftBarItems: [UIBarButtonItem]? { nil }

}
