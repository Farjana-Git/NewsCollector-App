//
//  BookMarkViewController.swift
//  MidVersion01
//
//  Created by Bjit on 14/1/23.
//

import UIKit

class BookMarkViewController: UIViewController {
    var search = " "
    var desc = ""
    var content = ""
    var img = ""
    var url = ""
    var category = "category=\(Category.Categories.allCases[0].rawValue)"
    var articleArrayforBookMark = [BookMarkEntity]()
    
    @IBOutlet weak var searchLabelForBookMark: UILabel!
    @IBOutlet weak var searchTxtFieldForBookMark: UITextField!
    @IBOutlet weak var colllectionViewForBookMark: UICollectionView!
    @IBOutlet weak var tableViewForBookMark: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        colllectionViewForBookMark.delegate = self
        colllectionViewForBookMark.dataSource = self
        
        tableViewForBookMark.delegate = self
        tableViewForBookMark.dataSource = self
        
        searchTxtFieldForBookMark.delegate = self
        
        searchBarMethod()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        articleArrayforBookMark = CoreDataModel.shared.getAllRecordsBookMarked(category: category, search: search)
        tableViewForBookMark.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.bookMarkToDetail {
            
            let detailVC = segue.destination as! DetailViewController
            
            detailVC.desc = desc
            detailVC.content = content
            detailVC.img = img
            detailVC.url = url
        }
    }
}

// MARK: Extension of BookMarkViewController

extension BookMarkViewController {
    
    func searchBarMethod() {
        let searchIcon  = UIImageView()
        searchIcon.image = UIImage(systemName: "magnifyingglass")
        searchIcon.tintColor = .darkGray
        
        
        let uiView = UIView()
        uiView.addSubview(searchIcon)
        
        uiView.frame = CGRect(x: 0, y: 0, width: UIImage(systemName: "magnifyingglass")!.size.width+15, height: UIImage(systemName: "magnifyingglass")!.size.height)
        
        searchIcon.frame = CGRect(x:15, y: 0, width: UIImage(systemName: "magnifyingglass")!.size.width, height: UIImage(systemName: "magnifyingglass")!.size.height)
        
        searchTxtFieldForBookMark.leftView = uiView
        searchTxtFieldForBookMark.leftViewMode = .always
        searchTxtFieldForBookMark.clearButtonMode = .whileEditing
        
    }
    
    
    func getAllRecordsForBookMark(category: String) {
        articleArrayforBookMark = CoreDataModel.shared.getAllRecordsBookMarked(category: category, search: search)
    }
}


//MARK: Extension of ViewController: UITextFieldDelegate
extension BookMarkViewController: UITextFieldDelegate {
    
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         search = searchTxtFieldForBookMark.text!
         articleArrayforBookMark = CoreDataModel.shared.getAllRecordsBookMarked(category: category, search: search)
         tableViewForBookMark.reloadData()
         return true
     }

}


// MARK: BookMark_CollectionView

extension BookMarkViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = colllectionViewForBookMark.cellForItem(at: indexPath) as? BookMarkCustomCollectionViewCell {
        
        cell.categoryLabelForBookMark.highlightedTextColor = .darkGray
            
        }
        
        if indexPath.row == 0 {
            articleArrayforBookMark = CoreDataModel.shared.getAllRecordsForAllCategory()
            tableViewForBookMark.reloadData()
        }
        else {
            category = "category=\(Category.Categories.allCases[indexPath.row])"
            articleArrayforBookMark = CoreDataModel.shared.getAllRecordsBookMarked(category: category, search: search)
            
            tableViewForBookMark.reloadData()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cell = colllectionViewForBookMark.cellForItem(at: indexPath) as? BookMarkCustomCollectionViewCell
        cell?.categoryLabelForBookMark.textColor = .black
    }

    
}

extension BookMarkViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Category.Categories.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.bookMarkCollectionViewCell, for: indexPath) as! BookMarkCustomCollectionViewCell
        
// MARK: need to check (line no 75)
        cell.categoryLabelForBookMark.text = Category.Categories.allCases[indexPath.row].rawValue
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension BookMarkViewController: UICollectionViewDelegateFlowLayout {
    
}


// MARK: BooKMark_TableView
extension BookMarkViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        if let desc3 = articleArrayforBookMark[indexPath.row].desc,
            let content3 = articleArrayforBookMark[indexPath.row].content,
            let img3 = articleArrayforBookMark[indexPath.row].urlToImg,
            let url3 = articleArrayforBookMark[indexPath.row].url {
            desc = desc3
            content = content3
            img = img3
            url = url3
        }
        performSegue(withIdentifier: Constant.bookMarkToDetail, sender: nil)
    }
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let bookMarkAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _,_,completion in
            guard let self = self else {return}
            
            self.handleBookMarkAction(indexPath: indexPath)

        }
        
        bookMarkAction.image = UIImage(systemName: "trash")
        bookMarkAction.backgroundColor = .systemRed
        
        let swipeAction = UISwipeActionsConfiguration(actions: [bookMarkAction])
        swipeAction.performsFirstActionWithFullSwipe = false
        return swipeAction
        
    }
    
    
    func handleBookMarkAction(indexPath: IndexPath) {
        articleArrayforBookMark = CoreDataModel.shared.deleteRecordsFromBookMarks(index: indexPath.row, bookMarkArray: &articleArrayforBookMark, context: context)
        tableViewForBookMark.reloadData()
    }
}

extension BookMarkViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleArrayforBookMark.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableViewCellForBookMark = tableView.dequeueReusableCell(withIdentifier: Constant.bookMarkTableViewCell) as! BookMarkCustomTableViewCell
        
        tableViewCellForBookMark.titleLabelForBookMark.text =  articleArrayforBookMark[indexPath.row].title ?? ""
        tableViewCellForBookMark.authorLabelForBookMark.text =  articleArrayforBookMark[indexPath.row].author ?? ""
        tableViewCellForBookMark.dateLabelForBookMark.text =  articleArrayforBookMark[indexPath.row].publishedAt ?? ""
        
        let image = articleArrayforBookMark[indexPath.row].urlToImg
                if let image = image {
                    tableViewCellForBookMark.thumbnailImgForBookMark.sd_setImage(with: URL(string: image))
                }
                else {
                    tableViewCellForBookMark.thumbnailImgForBookMark.image = UIImage(systemName: "trash")
                }
        
        return tableViewCellForBookMark
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
}

