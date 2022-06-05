//
//  TableViewCell.swift
//  ChatApp
//
//  Created by Laptop World on 28/10/1443 AH.
//

import UIKit
import Kingfisher

class TableViewCell: UITableViewCell {
    
    //---------------------- outlet ---------------
    
    @IBOutlet weak var viewMyMessage: UIView!
    @IBOutlet weak var lblMyMessage: UILabel!
    @IBOutlet weak var imgViewMyMessage: UIImageView!
    
    
    
    //---------------------- LifeCycle ---------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblMyMessage.layer.cornerRadius =  10
        imgViewMyMessage.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setURLImage(url:URL,placeholderImage:UIImage){
        self.imgViewMyMessage.kf.indicatorType = .activity
        self.imgViewMyMessage.kf.setImage(
            with: url,
            placeholder: placeholderImage,
            options: [
                .loadDiskFileSynchronously, .cacheOriginalImage
            ],
            progressBlock: { receivedSize, totalSize in
            // Progress updated
            },
            completionHandler: { result in
            // Done
            })
    }
    
}
