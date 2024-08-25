//
//  MovieDetailView.swift
//  Movie
//
//  Created by Bishwajit Yadav on 26/08/24.
//

import UIKit
import SDWebImage

class MovieDetailView: UIView {

    // UI Elements
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let yearLabel = UILabel()
    private let ratedLabel = UILabel()
    private let genreLabel = UILabel()
    private let directorLabel = UILabel()
    private let ratingsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let detailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // Initialize and set up the view
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        // Configure the UI elements
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byTruncatingTail
        
        // Poster ImageView configuration
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.clipsToBounds = true
        
        // Configure Labels
        yearLabel.font = UIFont.systemFont(ofSize: 16)
        ratedLabel.font = UIFont.systemFont(ofSize: 16)
        genreLabel.font = UIFont.systemFont(ofSize: 16)
        directorLabel.font = UIFont.systemFont(ofSize: 16)
        
        // Set up details stack view
        detailsStackView.addArrangedSubview(titleLabel)
        detailsStackView.addArrangedSubview(yearLabel)
        detailsStackView.addArrangedSubview(ratedLabel)
        detailsStackView.addArrangedSubview(genreLabel)
        detailsStackView.addArrangedSubview(directorLabel)
        
        // Add subviews
        addSubview(posterImageView)
        addSubview(detailsStackView)
        addSubview(ratingsStackView)
        
        // Set up constraints
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        detailsStackView.translatesAutoresizingMaskIntoConstraints = false
        ratingsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            posterImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            posterImageView.heightAnchor.constraint(equalToConstant: 300),
            
            detailsStackView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 10),
            detailsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            detailsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            ratingsStackView.topAnchor.constraint(equalTo: detailsStackView.bottomAnchor, constant: 20),
            ratingsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            ratingsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            ratingsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    
    func configure(with movieDetail: MovieDetail) {
        titleLabel.text = movieDetail.title
        yearLabel.text = "Year: \(movieDetail.year ?? "N/A")"
        ratedLabel.text = "Rated: \(movieDetail.rated ?? "N/A")"
        genreLabel.text = "Genre: \(movieDetail.genre ?? "N/A")"
        directorLabel.text = "Director: \(movieDetail.director ?? "N/A")"
        
        if let posterURL = movieDetail.poster, let url = URL(string: posterURL) {
            posterImageView.sd_setImage(with: url, completed: nil)
        } else {
            posterImageView.image = nil
        }
        
        ratingsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if let ratings = movieDetail.ratings {
            for rating in ratings {
                let label = createRatingLabel(source: rating.source ?? "N/A", value: rating.value ?? "N/A")
                ratingsStackView.addArrangedSubview(label)
            }
        }
    }
    
    private func createRatingLabel(source: String, value: String) -> UILabel {
        let label = UILabel()
        label.text = "\(source): \(value)"
        label.textColor = .label
        return label
    }
}
