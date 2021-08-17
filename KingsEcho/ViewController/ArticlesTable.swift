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

class ArticlesTableVC: UITableViewController, ArticleServerDelegate {
    func updateArticles() {
        articles = UserData.shared.articles ?? []
        setup()
        tableView.reloadData()
    }
    
    func updateMySubscribers() {
        
    }
    
    func updateMySubscriptions() {
        
    }
    

    enum Const {
        static let closeCellHeight: CGFloat = 179
        static let openCellHeight: CGFloat = 600
    }
    
    var articles = [Article]()
    
    var cellHeights: [CGFloat] = []
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ArticleServerSingleton.shared.delegate = self
        ArticleServerSingleton.shared.fetchArticles()
    }

    // MARK: Helpers
    private func setup() {
        cellHeights = Array(repeating: Const.closeCellHeight, count: articles.count)
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
        return articles.count
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
        cell.publisherId = articles[indexPath.row].originalPublisherId
        cell.articleId = articles[indexPath.row].id
        cell.authorLabel.text = articles[indexPath.row].author
        cell.authorLabelOpen.text = articles[indexPath.row].author
        cell.messageBodyLabel.text = articles[indexPath.row].message
        cell.translatorsLabel.text = articles[indexPath.row].translatorName
        cell.messageTranslation = articles[indexPath.row].messageTranslated ?? [:]
        cell.messageTitleLabel.text = articles[indexPath.row].title
        cell.messageTitleOpen.text = articles[indexPath.row].title
        cell.publisherNameLabel.text = articles[indexPath.row].publisherName
        let str = articles[indexPath.row].publisherName?.prefix(2)
        cell.publisherInitials.text = String(str ?? "--")
        cell.publisherInitialsClosed.text =  String(str ?? "--")
        let count = "\(articles[indexPath.row].echoesCount ?? 0)"
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

