//
//  IntentHandler.swift
//  MoviesIntent
//
//  Created by Wei-Lun Su on 10/2/20.
//

import Intents

class IntentHandler: INExtension {
    override func handler(for intent: INIntent) -> Any {
        guard intent is MoviesIntent else {
            return self
        }
        return MoviesIntentHandler()
    }
}

class MoviesIntentHandler: NSObject, MoviesIntentHandling {
    func resolveEndpoint(for intent: MoviesIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        //
    }
    
    func handle(intent: MoviesIntent, completion: @escaping (MoviesIntentResponse) -> Void) {
        guard let endpoint = intent.endpoint else {
            completion(MoviesIntentResponse(code: .failure, userActivity: nil))
            return
        }
        completion(MoviesIntentResponse.success(type: endpoint))
    }
}
