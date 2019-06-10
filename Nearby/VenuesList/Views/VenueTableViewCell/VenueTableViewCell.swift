//
//  VenueTableViewCell.swift
//  Nearby
//
//  Created by Tung Vo on 10.6.2019.
//  Copyright © 2019 Tung Vo. All rights reserved.
//

import UIKit
import Kingfisher

protocol VenueTableViewCellDelegate: AnyObject {
    func venueTableViewCell(_ cell: VenueTableViewCell, favoriteDidChange favorite: Bool)
}

final class VenueTableViewCell: UITableViewCell {
    
    weak var delegate: VenueTableViewCellDelegate?
    
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var mainImageView: UIImageView!
    @IBOutlet private var favoriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainImageView.layer.cornerRadius = 10
        mainImageView.layer.masksToBounds = true
        selectionStyle = .none
        separatorInset.left = 80
        
        favoriteButton.setImage(UIImage(named: "like"), for: .normal)
        favoriteButton.setImage(UIImage(named: "liked")?.updated(with: .red), for: .selected)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainImageView.kf.cancelDownloadTask() // Stop downloading images
    }
    
    @IBAction func favoriteAction() {
        favoriteButton.isSelected.toggle()
        delegate?.venueTableViewCell(self, favoriteDidChange: favoriteButton.isSelected)
    }
    
    func populate(from venue: Venue, isFavorited: Bool) {
        nameLabel.text = venue.name
        descriptionLabel.text = venue.shortDescription
        favoriteButton.isSelected = isFavorited
        
        if let url = venue.imageURL {
            mainImageView.kf.setImage(with: url)
        }
    }
    
}
