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
    let activityIndicator = UIActivityIndicatorView(style: .large)
    var endpoint: MovieRepository.Endpoint
    var movieRepository: MovieRepository
    var movies = [Movie]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    init(endpoint: MovieRepository.Endpoint, movieRepository: MovieRepository = MovieRepository.shared) {
        self.endpoint = endpoint
        self.movieRepository = movieRepository
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        setupCollectionView()
        refresh()
        donateIntent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func donateIntent() {
       INPreferences.requestSiriAuthorization { [weak self] (authorization) in
           guard let strongSelf = self else { return }
//           guard authorization == INSiriAuthorizationStatus.authorized else {
//                return
//           }
        
           let intent = BrowseMoviesIntent()
           intent.endpoint = strongSelf.endpoint.description
           intent.suggestedInvocationPhrase = "\(strongSelf.endpoint.description) movies"
           let interaction = INInteraction(intent: intent, response: nil)
           interaction.donate(completion: { (error) in
               if let error = error {
                    print(error.localizedDescription)
               }
           })
       }
    }
    
    private func setupCollectionView() {
        title = endpoint.description
        
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        
        let refreshControl = UIRefreshControl(frame: .zero)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
      
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let screenWidth = UIScreen.main.bounds.width
        
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 2
        layout.sectionInset.top = 1
        layout.sectionInset.bottom = 1
        
        let itemWidth: CGFloat = (screenWidth / 3.0).rounded(.down)
        let itemSize = CGSize(width: itemWidth - 1.0 , height: (itemWidth * 3) / 2)
        layout.itemSize = itemSize
    }
    

    @objc private func refresh() {
        fetchMovies()
    }
    
    private func fetchMovies() {
        if movies.isEmpty {
            activityIndicator.startAnimating()
        }
        
        movieRepository.fetchMovies(from: endpoint, params: ["page": String(1)], successHandler: {[weak self] (response) in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.collectionView.refreshControl?.endRefreshing()
                self?.movies = response.results
            }
        }) {[weak self] (error) in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.collectionView.refreshControl?.endRefreshing()
                self?.collectionView.reloadData()
            }
        }
    }
    
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

