//
//  MovieListViewControlller.swift
//  Movie
//
//  Created by Wei-Lun Su on 10/2/20.
//

import UIKit
import MovieKit
import Intents

class MovieListViewControlller: UICollectionViewController {
    
    var list: MovieList
    var service: MovieService
    
    var movies = [Movie]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private static let compositionalLayout: UICollectionViewCompositionalLayout = {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.33)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 10, leading: 10, bottom: 0, trailing: 10)
        return UICollectionViewCompositionalLayout(section: section)
    }()
    
    // MARK: - Initializer
    
    init(list: MovieList, service: MovieService = MovieService.shared) {
        self.list = list
        self.service = service
        super.init(collectionViewLayout: Self.compositionalLayout)
        collectionView.collectionViewLayout = Self.compositionalLayout
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = list.description
        collectionView.backgroundColor = .white
        let refreshControl = UIRefreshControl(frame: .zero)
        refreshControl.addTarget(self, action: #selector(getMovies), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        getMovies()
        donateIntent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func donateIntent() {
       INPreferences.requestSiriAuthorization { [weak self] (authorization) in
           guard let self = self else { return }
//           guard authorization == INSiriAuthorizationStatus.authorized else {
//                return
//           }
           let intent = BrowseMoviesIntent()
           intent.endpoint = self.list.description
           intent.suggestedInvocationPhrase = "Search for \(self.list.description) movies for Wei-Lun"
           let interaction = INInteraction(intent: intent, response: nil)
           interaction.donate(completion: { (error) in
               if let error = error {
                    print(error.localizedDescription)
               }
           })
       }
    }
    
    @objc
    private func getMovies() {
        service.getMovies(from: list, params: ["page": String(1)], successHandler: {[weak self] (response) in
            DispatchQueue.main.async {
                self?.collectionView.refreshControl?.endRefreshing()
                self?.movies = response.results
            }
        }) {[weak self] (error) in
            DispatchQueue.main.async {
                self?.collectionView.refreshControl?.endRefreshing()
                self?.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return movies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MovieCollectionViewCell
        let movie = movies[indexPath.row]
        cell.movie = movie
        return cell
    }
    
}

