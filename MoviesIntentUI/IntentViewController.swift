//
//  IntentViewController.swift
//  MoviesIntentUI
//
//  Created by Wei-Lun Su on 10/2/20.
//

import IntentsUI
import MovieKit

class IntentViewController: UIViewController, INUIHostedViewControlling, UITableViewDataSource, UITableViewDelegate {
    let service = MovieService.shared
    @IBOutlet private weak var tableView: UITableView!
    
    var movies = [Movie]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 85.0
        tableView.rowHeight = UITableView.automaticDimension
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let movie = movies[indexPath.row]
        cell?.textLabel?.text = movie.title
        cell?.detailTextLabel?.text = movie.voteAveragePercentText
        return cell ?? UITableViewCell()
    }
}
