//
//  FlashCardsPackController.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 06.09.24.
//

//
//  FlashCardsViewController.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 06.09.24.
//

import UIKit
import Networking
import MyAssetBook
class FlashCardsPackViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CustomNavigatable {

    private var flashcards: [FlashcardEntity] = []
    private let tableView = UITableView()
    private let service = Service()
    private var name: String? = nil
    private var flashcardPackId: Int

    init(flashcards: [FlashcardEntity], name: String, flashcardPackId: Int) {
        self.flashcards = flashcards
        self.name = name
        self.flashcardPackId = flashcardPackId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        configureNavigationBar()
        tableView.estimatedRowHeight = 100
        view.backgroundColor = Color.background
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
        tableView.register(FlashcardTableViewCell.self, forCellReuseIdentifier: "FlashcardCell")
        tableView.register(SpacerTableViewCell.self, forCellReuseIdentifier: "SpacerCell")

    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flashcards.count * 2 - 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 1 {
            return 20
        } else {
            return UITableView.automaticDimension
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 1 { // Example condition to identify spacer rows
            let cell = tableView.dequeueReusableCell(withIdentifier: "SpacerCell", for: indexPath) as! SpacerTableViewCell
            return cell
        }
        else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FlashcardCell", for: indexPath) as? FlashcardTableViewCell else {
                return UITableViewCell()
            }
            
            let flashcard = flashcards[indexPath.row / 2]
            cell.configure(with: flashcard)
            
            return cell
        }
    }
    
    var navTitle: NavigationTitle {
        .init(text: "\(name!)", color: Color.Blue1)
    }
    
    var rightBarItems: [UIBarButtonItem]? {
        let button = AddBarButtonItem()
        button.addButtonTappedAction = { [weak self] in
            self?.addFlashcardTapped()
        }
        return [button]
    }
    
    
    private func addFlashcardTapped() {
          let addFlashcardVC = AddFlashcardViewController()
          addFlashcardVC.onCreate = { [weak self] question, answer in
              self?.addFlashcard(question: question, answer: answer)
          }
        self.present(addFlashcardVC, animated: true, completion: nil)
      }
       
    private func addFlashcard(question: String, answer: String) {
           let flashcardData = [["question": question, "answer": answer]]
           
           service.updateFlashcardPack(flashcardPackId: flashcardPackId, flashcards: flashcardData) { [weak self] result in
               switch result {
               case .success:
                   DispatchQueue.main.async {
                       self?.fetchFlashcards(question: question, answer: answer)
                   }
               case .failure(let error):
                   DispatchQueue.main.async {
                       self?.displayBanner(with: "შეფერხებაა, მოგვიანებით სცადე", state: .failure)
                   }
               }
           }
       }
    
    private func fetchFlashcards(question: String, answer: String) {
        let newFlashcard = FlashcardEntity(id: flashcards.count + 1, packId: flashcardPackId, question: question, answer: answer)
        flashcards.append(newFlashcard)
        self.view.layoutSubviews()
        tableView.reloadData()
    }
    
}

