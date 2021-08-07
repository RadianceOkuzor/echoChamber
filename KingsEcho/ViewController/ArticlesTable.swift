//
//  ArticlesTable.swift
//  KingsEcho
//
//  Created by Radiance Okuzor on 8/6/21.
//


import Firebase
import FirebaseFunctions
import FirebaseFirestore
import FoldingCell
import UIKit

class ArticlesTableVC: UITableViewController {

    enum Const {
        static let closeCellHeight: CGFloat = 179
        static let openCellHeight: CGFloat = 600
    }
    
    var db: Firestore!
    var messages = [Article]()
    
    var cellHeights: [CGFloat] = []

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        
        setUpListeners()
        setUpUserData()
    }

    // MARK: Helpers
    private func setup() {
        cellHeights = Array(repeating: Const.closeCellHeight, count: messages.count)
        tableView.estimatedRowHeight = Const.closeCellHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        if #available(iOS 10.0, *) {
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
    }
    
    // MARK: Actions
    @objc func refreshHandler() {
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
            if #available(iOS 10.0, *) {
                self?.tableView.refreshControl?.endRefreshing()
            }
            self?.tableView.reloadData()
        })
    }
}

// MARK: - TableView

extension ArticlesTableVC {

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return messages.count
    }

    override func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as ArticlesCell = cell else {
            return
        }

        cell.backgroundColor = .clear

        if cellHeights[indexPath.row] == Const.closeCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }

        cell.number = indexPath.row
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! ArticlesCell
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        cell.publisherId = messages[indexPath.row].originalPublisherId
        cell.articleId = messages[indexPath.row].id
        cell.authorLabel.text = messages[indexPath.row].author
        cell.authorLabelOpen.text = messages[indexPath.row].author
        cell.messageBodyLabel.text = messages[indexPath.row].message
        cell.translatorsLabel.text = messages[indexPath.row].translatorName
        cell.messageTranslation = messages[indexPath.row].messageTranslated ?? [:]
        cell.messageTitleLabel.text = messages[indexPath.row].title
        cell.messageTitleOpen.text = messages[indexPath.row].title
        cell.publisherNameLabel.text = messages[indexPath.row].publisherName
        let str = messages[indexPath.row].publisherName?.prefix(2)
        cell.publisherInitials.text = String(str ?? "--")
        cell.publisherInitialsClosed.text =  String(str ?? "--")
        let count = "\(messages[indexPath.row].echoesCount ?? 0)"
        cell.echoesCountLabel.text = count
        cell.echoesCountLabelClosed.text = count 
        /*
         
         cell.publisherIcon.image = messages[indexPath.row].linkToPubImage
         
         */
         
        
        return cell
    }

    override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: indexPath) as! ArticlesCell

        if cell.isAnimating() {
            return
        }

        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == Const.closeCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = Const.openCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = Const.closeCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }

        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
            
            // fix https://github.com/Ramotion/folding-cell/issues/169
            if cell.frame.maxY > tableView.frame.maxY {
                tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
            }
        }, completion: nil)
    }
}

extension ArticlesTableVC {
    func setUpListeners(){
        db.collection("Articles").addSnapshotListener { documentSnapshot, error in
              guard let document = documentSnapshot?.documents else {
                print("Error fetching document: \(error!)")
                return
              }
            self.messages.removeAll()
                for x in document {
                    let data = x.data()
                    let article = Article()
                    if let author = data["author"] as? String {
                        article.author = author
                    }
                    if let id = data["id"] as? String {
                        article.id = id
                    }
                    if let messageT = data["messageTranslated"] as? [String:String] {
                        article.messageTranslated = messageT
                    }
                    if let message = data["message"] as? String {
                        article.message = message
                    }
                    if let messageTitle = data["title"] as? String {
                        article.title = messageTitle
                    }
                    if let echoesCount = data["echoesCount"] as? [String] {
                        article.echoesCount = echoesCount.count
                    }
                    if let likesCount = data["likesCount"] as? [String] {
                        article.likes = likesCount
                    }
                    if let originalPublisherId = data["originalPublisherId"] as? String {
                        article.originalPublisherId = originalPublisherId
                    }
                    if let publisherName = data["publisherName"] as? String {
                        article.publisherName = publisherName
                    }
                    if let translator = data["translatorName"] as? String {
                        article.translatorName = translator
                    }
                    self.messages.append(article)
                }
            self.setup()
            self.tableView.reloadData()
            }
    }
    
    func setUpUserData() {
        let myId = Auth.auth().currentUser!.uid
        let docRef = db.collection("Users").document(myId)

        docRef.addSnapshotListener { (document, error) in
            if let document = document, document.exists {
                
                if let data = document.data() {
                    if let name = data["name"] as? String {
                        UserData.shared.name = name
                    }
                    if let email = data["email"] as? String {
                        UserData.shared.email = email
                    }
                    if let phoneNumber = data["phoneNumber"] as? String {
                        UserData.shared.phoneNumber = phoneNumber
                    }
                    if let language = data["language"] as? String {
                        UserData.shared.language = language
                    }
                    if let phoneNumbers = data["mySubscribers"] as? [String:[String:AnyObject]]{
                        UserData.shared.subscribersPhoneNumbers = Array(phoneNumbers.keys)
                    }
                    if let mySubscriptions = data["mySubscriptions"] as? [String:String]{
                        UserData.shared.mySubscriptions = mySubscriptions
                    }
                }
                  
            } else {
                print("Document does not exist")
            }
        }
    }
}
