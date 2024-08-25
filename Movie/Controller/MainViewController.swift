import UIKit
import SDWebImage

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    
    
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    private var movies: [Search] = [] // Updated model
    private var filteredMovies: [Search] = []
    private var currentPage = 1
    private var isFetching = false
    private let pageSize = 10
    private var searchQuery: String = "Don"
    private var debounceTimer: Timer?
    private let favoritesManager = FavoritesManager()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchMovies(s: searchQuery, page: currentPage)

    }
    
    private func setupUI() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
                tableView.register(MainMovieCell.self, forCellReuseIdentifier: MainMovieCell.identifier)
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainMovieCell.identifier, for: indexPath) as? MainMovieCell else {
            return UITableViewCell()
        }
        
        let movie = filteredMovies[indexPath.row]
        cell.nameLabel.text = movie.title
        cell.dateLabel.text = movie.year
      
        
        if let posterURL = movie.poster, let url = URL(string: posterURL) {
            DispatchQueue.main.async {
                cell.movieImageView.sd_setImage(with: url, completed: nil)
            }
        } else {
            cell.movieImageView.image = nil
        }
        let isFavorite = favoritesManager.isFavorite(movieID: movie.imdbID ?? "")
                cell.favoriteButton.setTitle(isFavorite ? "Unfavorite" : "Favorite", for: .normal)
                cell.favoriteButton.tag = indexPath.row
                cell.favoriteButton.addTarget(self, action: #selector(didTapFavoriteButton(_:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            let lastItemIndex = filteredMovies.count - 1
            if indexPath.row == lastItemIndex {
                if !isFetching {
                    currentPage += 1
                    fetchMovies(s: searchQuery, page: currentPage)
                }
            }
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the row after selection
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Get the selected movie
        let movie = filteredMovies[indexPath.row]
        
        // Initialize the detail view controller
        let detailVC = MovieDetailViewContoller()
        
        // Set the movie title on the detail view controller
        detailVC.movieTitle = movie.title
        
        // Ensure we are on the main thread
        DispatchQueue.main.async {
            // Check if navigationController is not nil
            if let navigationController = self.navigationController {
                navigationController.pushViewController(detailVC, animated: true)
            } else {
                print("Error: NavigationController is nil. Ensure that MainViewController is embedded in a UINavigationController.")
            }
        }
    }

    
    // MARK: - UISearchBarDelegate Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            debounceTimer?.invalidate()
            debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
                guard let self = self else { return }
                if searchText.isEmpty {
                    self.searchQuery = "Don"
                    self.currentPage = 1
                    self.fetchMovies(s: self.searchQuery, page: self.currentPage)
                } else {
                    self.searchQuery = searchText
                    self.currentPage = 1
                    self.fetchMovies(s: self.searchQuery, page: self.currentPage)
                }
            }
        }
       
       func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
           searchBar.text = ""
           searchQuery = "Don"
           currentPage = 1
           fetchMovies(s: searchQuery, page: currentPage)
       }
    @objc private func didTapFavoriteButton(_ sender: UIButton) {
            let movie = filteredMovies[sender.tag]
            let movieID = movie.imdbID ?? ""
            favoritesManager.toggleFavorite(movieID: movieID)
            
            tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
        }

}

extension MainViewController {
    
    func fetchMovies(s: String, page: Int) {
        guard !isFetching else { return }
        isFetching = true
        
        let parameters = [
            "s": s,   // Search term
            "type": "movie",
            "page": "\(page)" // Page number for pagination
        ]
        
        OMDBApiClient.shared.fetch(parameters: parameters, responseType: MovieTableCellViewModel.self) { result in
            self.isFetching = false
            switch result {
            case .success(let response):
                if let responseStatus = response.response, responseStatus == "False" {
                               // Handle the error message from the API
                               let errorMessage = response.error ?? "An unknown error occurred."
                               DispatchQueue.main.async {
                                   self.showError(message: errorMessage)
                               }
                               return
                           }
                if let newMovies = response.search {
                    if page == 1 {
                        self.movies = newMovies
                    } else {
                        self.movies.append(contentsOf: newMovies)
                    }
                    self.filteredMovies = self.movies
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
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
