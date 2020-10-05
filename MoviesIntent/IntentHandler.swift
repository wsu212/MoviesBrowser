//
//  IntentHandler.swift
//  BrowseMoviesIntent
//
//  Created by Wei-Lun Su on 10/2/20.
//

import Intents

class IntentHandler: INExtension, BrowseMoviesIntentHandling {
    
    override func handler(for intent: INIntent) -> Any? {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        return self
    }
    
    func handle(intent: BrowseMoviesIntent,
                completion: @escaping (BrowseMoviesIntentResponse) -> Void) {
        guard let list = intent.list else {
            completion(BrowseMoviesIntentResponse(code: .failure, userActivity: nil))
            return
        }
        completion(BrowseMoviesIntentResponse.success(type: list))
    }
    
    func resolveList(for intent: BrowseMoviesIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        guard let list = intent.list else {
            completion(INStringResolutionResult.disambiguation(with: ["Now Playing", "Upcoming", "Popular", "Top Rated"]))
            return
        }
        let spotlightSearchTitle = list
        completion(INStringResolutionResult.success(with: spotlightSearchTitle))
    }
}
