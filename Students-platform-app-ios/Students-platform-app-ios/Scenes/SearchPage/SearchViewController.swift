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
        

    private let refreshControl = UIRefreshControl()

    
    private var subjects: [SubjectEntity] = []
    private var mySubjects: [SubjectEntity] = []
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
        fetchMySubjects()
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
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
       
        tableView.backgroundView?.backgroundColor = Color.background
        tableView.backgroundColor = Color.background
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(SubjectTableViewCell.self, forCellReuseIdentifier: "SubjectCell")
        
        refreshControl.addTarget(self, action: #selector(refreshSubjectsData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc private func refreshSubjectsData() {
        fetchSubjects()
        fetchMySubjects()
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
            }
        }
    }
    
    private func fetchMySubjects() {
        service.CallMySubjectsService { [weak self] result in
            switch result {
            case .success(let subjects):
                self?.mySubjects = subjects
                DispatchQueue.main.async {
                    self?.refreshControl.endRefreshing()
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.refreshControl.endRefreshing()
                }
                print("Failed to fetch my subjects: \(error)")
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
            if let index = self?.mySubjects.firstIndex(where: { $0.id == subject.id }) {
                self?.handleMoreButtonForMySubjectTapped(for: subject)
            }
            else {
                self?.handleMoreButtonTapped(for: subject)
            }
        }
        
        return cell
    }
    
    private func handleMoreButtonForMySubjectTapped(for subject: SubjectEntity) {
         // Handle the action for the more button tap
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
        let firstAction = UIAlertAction(title: MytextBook.SearchTexts.deleteSubject, style: .default) { _ in
            self.service.CallDeleteSubjectService(subjectId: subject.id!) { result in
                switch result {
                case .success:
                    if let index = self.mySubjects.firstIndex(where: { $0.id == subject.id }) {
                        self.mySubjects.remove(at: index)
                    }
                case .failure(let error):
                    print("Failed to delete subject: \(error)")
                }
            }
        }
            
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(firstAction)
        alertController.addAction(cancelAction)
            
        if let topController = UIApplication.shared.windows.first?.rootViewController {
            topController.present(alertController, animated: true, completion: nil)
        }
     }
    
    private func handleMoreButtonTapped(for subject: SubjectEntity) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
        let firstAction = UIAlertAction(title: MytextBook.SearchTexts.addSubject, style: .default) { _ in
            self.service.CallAddSubjectsService(subjectId: subject.id!) { result in
                switch result {
                case .success:
                    self.mySubjects.insert(subject, at: 0)
                case .failure(let error):
                    print("Failed to add subject: \(error)")
                }
            }
        }
       
            
        let cancelAction = UIAlertAction(title: "გაუქმება", style: .cancel)
        
        alertController.addAction(firstAction)
        alertController.addAction(cancelAction)
            
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
