//
//  MovieList.swift
//  Movie
//
//  Created by Wei-Lun Su on 10/4/20.
//

import Foundation

public enum MovieList: String, CustomStringConvertible, CaseIterable {
    case nowPlaying = "now_playing"
    case upcoming
    case popular
    case topRated = "top_rated"
    
    public var description: String {
        switch self {
        case .nowPlaying: return "Now Playing"
        case .upcoming: return "Upcoming"
        case .popular: return "Popular"
        case .topRated: return "Top Rated"
        }
    }
    
    public init?(description: String) {
        guard let first = MovieList.allCases.first(where: { $0.description == description }) else {
            return nil
        }
        self = first
    }
    
}
