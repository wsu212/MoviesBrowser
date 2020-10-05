//
//  MovieCollectionViewCell.swift
//  Movie
//
//  Created by Wei-Lun Su on 10/2/20.
//

import UIKit
import Foundation

public class MovieCollectionViewCell: UICollectionViewCell {
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 16.0)
        label.textColor = .black
        return label
    }()
    
    private var ratingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .italicSystemFont(ofSize: 11.0)
        label.textColor = .darkGray
        return label
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        [titleLabel,
         imageView,
         ratingLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        NSLayoutConstraint.activate([imageView.heightAnchor.constraint(equalToConstant: 194.0),
                                     imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                                     imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
                                     imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            
                                     titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10.0),
                                     titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10.0),
                                     titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10.0),
            
                                     ratingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6.0),
                                     ratingLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.0),
                                     ratingLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10.0),
                                     ratingLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10.0)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.isHidden = false
        ratingLabel.isHidden = false
    }
    
    public func updateUI(movie: Movie) {
        titleLabel.text = movie.title
        ratingLabel.text = movie.voteAveragePercentText
        imageView.setAsyncImage(url: movie.posterURL)
    }

}

extension UIImageView {
    public func setAsyncImage(url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        }
    }
}
