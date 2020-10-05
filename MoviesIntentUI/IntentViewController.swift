//
//  IntentViewController.swift
//  MoviesIntentUI
//
//  Created by Wei-Lun Su on 10/2/20.
//

import IntentsUI
import MovieKit

class IntentViewController: UIViewController, INUIHostedViewControlling, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let service = MovieService.shared
    @IBOutlet private weak var collectionView: UICollectionView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = Self.compositionalLayout
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
        
    // MARK: - INUIHostedViewControlling
    
    // Prepare your view controller for the interaction to handle.
    func configureView(
        for parameters: Set<INParameter>,
        of interaction: INInteraction,
        interactiveBehavior: INUIInteractiveBehavior,
        context: INUIHostedViewContext,
        completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void
    ) {
        
//        guard let intent = interaction.intent as? BrowseMoviesIntent else {
//            completion(true, parameters, self.desiredSize)
//            return
//        }
//
//        guard let endpointString = intent.endpoint,
//              let endpoint = MovieRepository.Endpoint(description: endpointString) else {
//            completion(true, parameters, self.desiredSize)
//            return
//        }
        
        service.getMovies(from: .topRated, successHandler: { response in
//        repository.fetchMovies(from: endpoint, successHandler: { (response) in
            DispatchQueue.main.async {
                self.movies = response.results
            }
        }) { (error) in
            self.movies = []
        }
        
        completion(true, parameters, self.desiredSize)
    }
    
    var desiredSize: CGSize {
        let size = self.extensionContext!.hostedViewMaximumAllowedSize
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MovieCollectionViewCell
        let movie = movies[indexPath.row]
        cell.updateUI(movie: movie)
        return cell
    }
}
