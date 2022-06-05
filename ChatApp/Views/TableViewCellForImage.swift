//
//  TableViewCellForImage.swift
//  ChatApp
//
//  Created by Laptop World on 06/11/1443 AH.
//

import UIKit
import Kingfisher

class TableViewCellForImage: UITableViewCell {
    //--------------outlet--------------
    @IBOutlet weak var viewYourMessage: UIView!
    @IBOutlet weak var lblYourMessage: UILabel!
    @IBOutlet weak var imgViewYourMessage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblYourMessage.layer.cornerRadius =  10
        imgViewYourMessage.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setURLImage(url:URL,placeholderImage:UIImage){
        self.imgViewYourMessage.kf.indicatorType = .activity
        self.imgViewYourMessage.kf.setImage(
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
