//
//  IntentViewController.swift
//  MoviesIntentUI
//
//  Created by Wei-Lun Su on 10/2/20.
//

import IntentsUI
import MovieKit

class IntentViewController: UIViewController, INUIHostedViewControlling {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let repository = MovieRepository.shared
    
    var movies = [Movie]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
        
    // MARK: - INUIHostedViewControlling
    
    // Prepare your view controller for the interaction to handle.
    func configureView(for parameters: Set<INParameter>, of interaction: INInteraction, interactiveBehavior: INUIInteractiveBehavior, context: INUIHostedViewContext, completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
        guard let intent  = interaction.intent as? MoviesIntent,
            let endpointString = intent.endpoint, let endpoint = MovieRepository.Endpoint(description: endpointString) else {
                completion(true, parameters, self.desiredSize)
                return
        }
        
        repository.fetchMovies(from: endpoint, successHandler: { (response) in
            DispatchQueue.main.async {
                let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
                let screenWidth = self.view.bounds.width
                
                layout.minimumInteritemSpacing = 1
                layout.minimumLineSpacing = 2
                layout.sectionInset.top = 1
                layout.sectionInset.bottom = 1
                
                let itemWidth: CGFloat = (screenWidth / 3.0).rounded(.down)
                let itemSize = CGSize(width: itemWidth - 1.0 , height: (itemWidth * 3) / 2)
                layout.itemSize = itemSize
               
                self.movies = response.results
            }
        }) { (error) in
            
        }
        
        completion(true, parameters, self.desiredSize)
    }
    
    var desiredSize: CGSize {
        let size = self.extensionContext!.hostedViewMaximumAllowedSize
        return size
    }
    
}

extension IntentViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MovieCollectionViewCell
        
        cell.movie = movies[indexPath.item]
        return cell
    }
}
