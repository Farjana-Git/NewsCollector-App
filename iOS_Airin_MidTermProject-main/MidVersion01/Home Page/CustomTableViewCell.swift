//
//  CustomTableViewCell.swift
//  MidVersion01
//
//  Created by Bjit on 12/1/23.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        thumbnailImgView.layer.cornerRadius = 15
        thumbnailImgView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

    }

}
