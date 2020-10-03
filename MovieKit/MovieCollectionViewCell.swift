//
//  MovieCollectionViewCell.swift
//  Movie
//
//  Created by Wei-Lun Su on 10/2/20.
//

import UIKit
import Kingfisher
import Foundation

public class MovieCollectionViewCell: UICollectionViewCell {
    
    private var ratingLabel: UILabel = UILabel()
    private var imageView: UIImageView = UIImageView()
    private var titleLabel: UILabel = UILabel()
    
    public var movie: Movie! {
        didSet {
            self.titleLabel.text = movie?.title
            self.imageView.kf.setImage(with: movie?.posterURL, placeholder: nil, options: nil, progressBlock: nil) { (_, error, _, _) in
                self.titleLabel.isHidden = error == nil
            }
            
            let voteCount = movie?.voteCount ?? 0
            if voteCount > 0 {
                ratingLabel.text = movie.voteAveragePercentText
            } else {
                ratingLabel.isHidden = true
            }
            
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        [ratingLabel,
         imageView,
         titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 240),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            
            titleLabel.heightAnchor.constraint(equalToConstant: 44),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            
            ratingLabel.heightAnchor.constraint(equalToConstant: 44),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.isHidden = false
        ratingLabel.isHidden = false
    }

}
