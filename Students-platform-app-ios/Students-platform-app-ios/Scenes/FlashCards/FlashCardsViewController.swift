//
//  FlashCardsViewController.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 06.09.24.
//

import UIKit
import Networking
import MyAssetBook


class FlashcardsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CustomNavigatable {

    private var flashcardPacks: [FlashcardPack] = []
    private let tableView = UITableView()
    private let service = Service()
    private var subjectId: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setUp()
        tableView.estimatedRowHeight = 100 
        view.backgroundColor = Color.background
        fetchFlashcardPacks()
    }
    
    public func setSubject(subjectId: Int) {
        self.subjectId = subjectId
    }

    private func setUp() {
        setupTableView()
        addSubviews()
        addConstraints()
    }

    private func addSubviews() {
        view.addSubview(tableView)
    }

    private func addConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.top(toView: view, constant: .XL2)
        tableView.left(toView: view, constant: .XL2)
        tableView.right(toView: view, constant: .XL2)
        tableView.bottom(toView: view)
    }

    private func setupTableView() {
        tableView.backgroundColor = Color.background
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FlashcardPackTableViewCell.self, forCellReuseIdentifier: "FlashcardPackCell")
        tableView.register(SpacerTableViewCell.self, forCellReuseIdentifier: "SpacerCell")
    }

    private func fetchFlashcardPacks() {
        service.fetchFlashcardPacks(for: subjectId) { [weak self] result in
            switch result {
            case .success(let flashcardPacks):
                self?.flashcardPacks = flashcardPacks
                DispatchQueue.main.async {
                    self?.view.layoutSubviews()
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch flashcard packs: \(error)")
            }
        }
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (flashcardPacks.count * 2 - 1)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 1 { // Spacer cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "SpacerCell", for: indexPath) as! SpacerTableViewCell
            return cell
        } else { // Flashcard pack cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "FlashcardPackCell", for: indexPath) as! FlashcardPackTableViewCell
            let pack = flashcardPacks[indexPath.row / 2]
            cell.configure(with: pack)
            return cell
        }
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row % 2 == 0 {
            let pack = flashcardPacks[indexPath.row / 2]
            let flashcardsVC = FlashCardsPackViewController(flashcards: pack.flashcards, name: pack.name, flashcardPackId: pack.id )
            navigationController?.pushViewController(flashcardsVC, animated: true)
        }
    }
    
    
    var navTitle: NavigationTitle {
        .init(text: "Flashcards", color: Color.Blue1)
    }
    
    var rightBarItems: [UIBarButtonItem]? {
        let button = AddBarButtonItem()
        button.setIMage(named: "folder.badge.plus")
        button.addButtonTappedAction = { [weak self] in
            self?.presentFlashcardPackMaker()
        }
        return [button]
    }
    
    
    
    private func presentFlashcardPackMaker() {
       let createVC = CreateFlashcardPackViewController()
       createVC.modalPresentationStyle = .overCurrentContext
       createVC.onCreate = { [weak self] packName in
           self?.createFlashcardPack(name: packName)
       }
        self.present(createVC, animated: true, completion: nil)
    }
       
   private func createFlashcardPack(name: String) {
       service.createFlashcardPack(name: name, subjectId: subjectId, flashcards: []) { [weak self] result in
           switch result {
           case .success:
               DispatchQueue.main.async {
                   self?.fetchFlashcardPacks()
               }
           case .failure(let error):
               DispatchQueue.main.async {
                   self?.displayBanner(with: "შეფერხებაა, მოგვიანებით სცადე", state: .failure)
               }
           }
       }
   }

    
    
    
    
}


