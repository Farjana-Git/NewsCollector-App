//
//  ViewController.swift
//  MidVersion01
//
//  Created by Bjit on 12/1/23.
//

import UIKit
import CoreData
import SDWebImage

class ViewController: UIViewController {
    
    var dataArry = [Article]()
    var articleArray = [ArticleSourceEntity]()
    var articleArrayforBookMark = [BookMarkEntity]()
    
    var result: Welcome!
    var articles: [Article]!
    var toNumOfRows: Int!
    var flag: Bool!
    var search = " "
    var category = "category=\(Category.Categories.allCases[0].rawValue)"
    
    var desc = ""
    var content = ""
    var img = ""
    var url = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(category)
        tableView.delegate = self
        tableView.dataSource = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchTextField.delegate = self
        
        searchBarMethod()
        

         
        flag = UserDefaults.standard.bool(forKey: Constant.userDefaultsKey)
        
        getData() {
            articleArray = CoreDataModel.shared.getAllRecordsForAllCategory()
            tableView.reloadData()
        }
        if flag! == false {
            APIModel.shared.fetchData(category: category, completion: {(data) in
                guard let data = data else {return}
            
            DispatchQueue.main.async {
                let datalist = data.articles ?? []
                for data in datalist{
                    CoreDataModel.shared.addRecord(title: data.title ?? "", author: data.author ?? "", publishedAt: data.publishedAt ?? "", url: data.url ?? "", urlToImage: data.urlToImage ?? "", desc: data.description ?? "", content: data.content ?? "", category: "All", context: self.context)
                }
            
                self.tableView.reloadData()
            }
            })
            UserDefaults.standard.set(!flag, forKey: Constant.userDefaultsKey)
        }
        
        articleArray = CoreDataModel.shared.getAllRecordsForAllCategory()
        tableView.reloadData()
        
        
        // MARK: - Pull to Refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
    }
    
    
    
    @objc func refresh() {
        CoreDataModel.shared.deleteRecordsFromCoreData(context: context)
        
        APIModel.shared.fetchData(category: category, completion: {(data) in
            guard let data = data else {return}
        
        DispatchQueue.main.async {
            let datalist = data.articles ?? []
            for data in datalist{
                self.articleArray = CoreDataModel.shared.addRecord(title: data.title ?? "", author: data.author ?? "", publishedAt: data.publishedAt ?? "", url: data.url ?? "", urlToImage: data.urlToImage ?? "", desc: data.description ?? "", content: data.content ?? "", category: "All", context: self.context)
            }
        
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.homeCellToDetail {
            
            let detailVC = segue.destination as! DetailViewController
            
            detailVC.desc = desc
            detailVC.content = content
            detailVC.img = img
            detailVC.url = url
        }
    }
}

// MARK: extension of ViewController

extension ViewController {
    
    func searchBarMethod() {
        let searchIcon  = UIImageView()
        searchIcon.image = UIImage(systemName: "magnifyingglass")
        searchIcon.tintColor = .darkGray
        
        
        let uiView = UIView()
        uiView.addSubview(searchIcon)
        
        uiView.frame = CGRect(x: 0, y: 0, width: UIImage(systemName: "magnifyingglass")!.size.width+15, height: UIImage(systemName: "magnifyingglass")!.size.height)
        
        searchIcon.frame = CGRect(x:15, y: 0, width: UIImage(systemName: "magnifyingglass")!.size.width, height: UIImage(systemName: "magnifyingglass")!.size.height)
        
        searchTextField.leftView = uiView
        searchTextField.leftViewMode = .always
        searchTextField.clearButtonMode = .whileEditing
        
    }
    
    
    func getAllRecords(category: String) {
        articleArray = CoreDataModel.shared.getAllRecords(category: category, search: search)
    }

    
    func addRecord(title: String, author: String, publishedAt: String, url: String, urlToImage: String, desc: String, content: String, category: String) {
        articleArray = CoreDataModel.shared.addRecord(title: title, author: author, publishedAt: publishedAt, url: url, urlToImage: urlToImage, desc: desc, content: content, category: category, context: context)
    }

    
    func getData(completion: () -> Void) {
        for category in Category.Categories.allCases {
            APIModel.shared.fetchData(category: category.rawValue) { [weak self] result in
                if let self = self,
                    let result = result {
                    
                    self.result = result
                    if let articles = result.articles {
                        for article in articles {
                            if let title = article.title,
                               let author = article.author,
                               let publishedAt = article.publishedAt,
                               let desc = article.description,
                               let url = article.url,
                               let urlToImg = article.urlToImage,
                               let content = article.content
                            {
                                DispatchQueue.main.async {
                                    self.addRecord(title: title, author: author, publishedAt: publishedAt, url: url, urlToImage: urlToImg, desc: desc, content: content, category: "category=\(category.rawValue)")
                                }
                            }
                        }
                    }
                    self.articles = result.articles
                }
            }
        }
    }
}


//MARK: Extension of ViewController: UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         search = searchTextField.text!
         articleArray = CoreDataModel.shared.getAllRecords(category: category, search: search)
         tableView.reloadData()
         return true
     }
}


// MARK: CollectionView
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell {
            cell.categoryLabel.highlightedTextColor = .darkGray
        }
        
        if indexPath.row == 0 {
    
            print(Category.Categories.allCases[indexPath.row])
            articleArray = CoreDataModel.shared.getAllRecordsForAllCategory()
            tableView.reloadData()

        }
        else{
        
            category = "category=\(Category.Categories.allCases[indexPath.row])"
            //print(category)
            getAllRecords(category: category)
            tableView.reloadData()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell {
            cell.categoryLabel.textColor = .black
        }
    }
}


extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Category.Categories.allCases.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CustomCollectionViewCell
        
        cell.categoryLabel.text = Category.Categories.allCases[indexPath.row].rawValue
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
}




// MARK: TableView
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath)
        if let desc1 = articleArray[indexPath.row].desc,
            let content1 = articleArray[indexPath.row].content,
            let img1 = articleArray[indexPath.row].urlToImg,
            let url1 = articleArray[indexPath.row].url {
            desc = desc1
            content = content1
            img = img1
            url = url1
        }
        
        performSegue(withIdentifier: Constant.homeCellToDetail, sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let bookMarkAction = UIContextualAction(style: .normal, title: nil) { [weak self] _,_,completion in
            guard let self = self else {return}
            
            self.handleBookMarkAction(indexPath: indexPath)
            //            completion(true)
        }
        
        bookMarkAction.image = UIImage(systemName: "bookmark")
        bookMarkAction.backgroundColor = .systemGray
        
        let swipeAction = UISwipeActionsConfiguration(actions: [bookMarkAction])
        swipeAction.performsFirstActionWithFullSwipe = false
        return swipeAction
        
    }
    
    
    func handleBookMarkAction(indexPath: IndexPath) {
        
        CoreDataModel.shared.addRecordBookMark(title: articleArray[indexPath.row].title ?? "", author: articleArray[indexPath.row].author ?? "", publishedAt: articleArray[indexPath.row].publishedAt ?? "", url: articleArray[indexPath.row].url ?? "", urlToImage: articleArray[indexPath.row].urlToImg ?? "", desc: articleArray[indexPath.row].desc ?? "", content: articleArray[indexPath.row].content ?? "", category: category, context: context)
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleArray.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! CustomTableViewCell

        tableViewCell.titleLabel.text =  articleArray[indexPath.row].title ?? ""
        tableViewCell.authorLabel.text =  articleArray[indexPath.row].author ?? ""
        tableViewCell.dateLabel.text =  articleArray[indexPath.row].publishedAt ?? ""
        
        tableViewCell.layer.cornerRadius = 20
        
        let image = articleArray[indexPath.row].urlToImg
                if let image = image {
                    tableViewCell.thumbnailImgView.sd_setImage(with: URL(string: image))
                }
                else {
                    tableViewCell.thumbnailImgView.image = UIImage(systemName: "trash")
                }
        
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
}





