//
//  BookMarkCustomTableViewCell.swift
//  MidVersion01
//
//  Created by Bjit on 14/1/23.
//

import UIKit

class BookMarkCustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailImgForBookMark: UIImageView!
    
    @IBOutlet weak var titleLabelForBookMark: UILabel!
    @IBOutlet weak var authorLabelForBookMark: UILabel!
    @IBOutlet weak var dateLabelForBookMark: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        thumbnailImgForBookMark.layer.cornerRadius = 15
        thumbnailImgForBookMark.layer.masksToBounds = true
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
