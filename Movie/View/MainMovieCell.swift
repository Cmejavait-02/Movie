import UIKit

class MainMovieCell: UITableViewCell {
    
    // UI Elements
    let backView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.label.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let favoriteButton: UIButton = {
           let button = UIButton(type: .system)
            button.setTitle("Favorite", for: .normal)
            button.setTitleColor(.systemBlue, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.layer.borderColor = UIColor.systemBlue.cgColor
            button.layer.borderWidth = 1.0
            button.layer.cornerRadius = 5.0
           return button
       }()
    
    // Reuse identifier
    public static var identifier: String {
        return "MainMovieCell"
    }
    
    // Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Set up the cell UI
    private func setupUI() {
        contentView.addSubview(backView)
        backView.addSubview(movieImageView)
        backView.addSubview(nameLabel)
        backView.addSubview(dateLabel)
        backView.addSubview(favoriteButton)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            // BackView constraints
            backView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            // MovieImageView constraints
            movieImageView.topAnchor.constraint(equalTo: backView.topAnchor, constant: 10),
            movieImageView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 10),
            movieImageView.widthAnchor.constraint(equalToConstant: 80),
            movieImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // NameLabel constraints
            nameLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -10),
            
            // DateLabel constraints
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -10),
            
            // FavoriteButton constraints
            favoriteButton.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            favoriteButton.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 10),
            favoriteButton.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -10),
            favoriteButton.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -10)
        ])
    }
}
