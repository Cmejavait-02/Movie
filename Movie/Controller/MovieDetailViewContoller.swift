//
//  MovieDetailViewContoller.swift
//  Movie
//
//  Created by Bishwajit Yadav on 26/08/24.
//

import Foundation
import UIKit
import SDWebImage

class MovieDetailViewContoller :UIViewController {
    
    var movieTitle:String?
    private var movies: [MovieDetail] = [] // Updated model
    private let detailView = MovieDetailView()

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(movieTitle)
        view.backgroundColor = .white
        view.addSubview(detailView)
        setupConstraints()
        fetchMovieDetails(title: movieTitle ?? "")
    }
    
    
    private func setupConstraints() {
            detailView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                detailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                detailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        }
    
    
}

extension MovieDetailViewContoller {
    
    func fetchMovieDetails(title: String) {
        let parameters = [
            "t": title // Title of the movie
        ]
        
        OMDBApiClient.shared.fetch(parameters: parameters, responseType: MovieDetail.self) { result in
            switch result {
            case .success(let movieDetail):
                DispatchQueue.main.async {
                    // Update your UI with movieDetail
                    self.detailView.configure(with: movieDetail)
                    print("Movie Details: \(movieDetail)")
                }
            case .failure(let error):
                self.showError(message: error.localizedDescription)
            }
        }
    }

    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
}
