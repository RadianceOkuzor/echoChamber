//
//  ChamberTableViewCell.swift
//  KingsEcho
//
//  Created by Radiance Okuzor on 8/6/21.
//

import UIKit

class ChamberTableViewCell: UITableViewCell {

    @IBOutlet weak var subscriberName: UILabel!
    @IBOutlet weak var imageVIewCell: UIImageView!
    @IBOutlet weak var viewPlacement: UIView!
    @IBOutlet weak var subscriptionName: UILabel!
    @IBOutlet weak var imageViweCellSubscription: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewPlacement.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
