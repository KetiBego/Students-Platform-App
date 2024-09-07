//
//  MysubjectsViewController.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 02.09.24.
//

import UIKit
import Lottie
import MyAssetBook
import Networking

class MySubjectsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CustomNavigatable {
        
    private var subjects: [SubjectEntity] = []
    private let tableView = UITableView()
    private let service = Service()
    
    private let refreshControl = UIRefreshControl()

    let animationView: LottieAnimationView = {
        let animation = LottieAnimationView()
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.loopMode = .loop
        animation.animation = .named(MyLottie.emptyAnimation, bundle: Bundle(identifier: "Free-University.MyAssetBook")!)
        animation.height(equalTo: 250)
        animation.width(equalTo: 200)
        animation.isHidden = true
        return animation
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        view.backgroundColor = Color.background
        fetchSubjects()
        configureNavigationBar()
        navigationItem.hidesBackButton = true
    }
    
    private func setUp() {
        setupTableView()
        AddSubviews()
        addConstraints()
    }
    
    private func AddSubviews() {
        view.addSubview(animationView)
        animationView.play()
        view.addSubview(tableView)
    }
    
    private func addConstraints() {
        
        animationView.centerVertically(to: view)
        animationView.centerHorizontally(to: view)
        
        tableView.top(toView: view, constant: .XL2)
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
    }
    
    private func fetchSubjects() {
        service.CallMySubjectsService(completion: { [weak self] result in
            switch result {
            case .success(let subjects):
                self?.subjects = subjects
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.refreshControl.endRefreshing()
                }
                if subjects.isEmpty {
                    DispatchQueue.main.async {
                        self?.animationView.isHidden = false
                        self?.tableView.isHidden = true
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.refreshControl.endRefreshing()
                }
                print("Failed to fetch subjects: \(error)")
            }
        })
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectCell", for: indexPath) as? SubjectTableViewCell else {
            return UITableViewCell()
        }
        
        let subject = subjects[indexPath.row]
        cell.configure(with: subject)
        
        cell.moreButtonTapped = { [weak self] in
            self?.handleMoreButtonTapped(for: subject)
        }
        
        return cell
    }
    
    private func handleMoreButtonTapped(for subject: SubjectEntity) {
         // Handle the action for the more button tap
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
        let firstAction = UIAlertAction(title: MytextBook.SearchTexts.deleteSubject, style: .default) { _ in
            self.service.CallDeleteSubjectService(subjectId: subject.id!) { result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        if let index = self.subjects.firstIndex(where: { $0.id == subject.id }) {
                            self.subjects.remove(at: index)
                            
                            self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                        }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return .XL8 // Set your desired height
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let subject = subjects[indexPath.row]
        self.navigationController?.pushViewController(SubjectFilesViewController(subjectId: subject.id!, subjectName: subject.subjectName!), animated: true)
    }

}

extension MySubjectsViewController {
    var navTitle: NavigationTitle {
        .init(text: "ჩემი საგნები", color: Color.Blue1)
    }
    var leftBarItems: [UIBarButtonItem]? { nil }

}
