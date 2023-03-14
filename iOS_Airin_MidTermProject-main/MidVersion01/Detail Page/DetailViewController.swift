//
//  DetailViewController.swift
//  MidVersion01
//
//  Created by Bjit on 14/1/23.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    
    var desc = ""
    var content = ""
    var img = ""
    var url = ""
    
    @IBOutlet weak var articleDescriptionLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    
    @IBOutlet weak var enlargedImgView: UIImageView!
    @IBOutlet weak var continueReadingBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articleDescriptionLabel.text = desc
        contentLabel.text = content
        enlargedImgView.sd_setImage(with: URL(string: img))
        
        
        enlargedImgView.layer.cornerRadius = 10
        enlargedImgView.layer.masksToBounds = true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.detailToWebPage {
            let destinationVC = segue.destination as! WebPageViewController
            destinationVC.url = url
        }
    }

    @IBAction func continueReadingAction(_ sender: Any) {
        performSegue(withIdentifier: Constant.detailToWebPage, sender: nil)
    }
    
}
