//
//  MovieService.swift
//  Movies
//
//  Created by Jonathan Martins on 09/10/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - MovieServiceDelegate
protocol MovieServiceDelegate:class {
    
    /// Notifies the result of the  movies
    func didReceiveMovies(_ movies:[Movie])
    
    /// Notifies the result of the details of a movie
    func didReceiveDetailOf(_ movie:Movie)
    
    /// Notifies the result of the genres
    func didReceiveGenres(_ genres:[Genre])
    
    /// Notifies that an error occured
    func onRequestError(_ error:String)
    
    /// Notifies hte there is no internet connection
    func noInternetConection()
}

// MARK: - MovieServiceDelegate Default Implemnetation
extension MovieServiceDelegate {
    func didReceiveMovies(_ movies:[Movie]){}
    func didReceiveDetailOf(_ movie:Movie){}
    func didReceiveGenres(_ genres:[Genre]){}
}

class MovieService{
    
    /// Callback to notify the caller of the request
    weak var delegate:MovieServiceDelegate?
    
    // MARK: - Requests
    /// Requests a list of movies according to the given parameters
    func popular(page: Int, _ filter:Filter){
        var parameters = Parameters()
        parameters["page"]        = page
        parameters["year"]        = filter.date
        parameters["with_genres"] = filter.genre?.id
        RequestManager<Result>.get(to: .movies, parameters: parameters) { [weak self] (response) in
            switch response{
                case .success(let result):
                    self?.delegate?.didReceiveMovies(result.movies ?? [])
                    break
                case .failure(let error):
                    self?.delegate?.onRequestError(error)
                    break
                case .noInternetConection:
                    self?.delegate?.noInternetConection()
                    break
            }
        }
    }
    
    /// Requests a list of movies according to the search parameter
    func search(_ term:String?, page: Int = 1){
        var parameters = Parameters()
            parameters["page"]  = page
            parameters["query"] = term
        RequestManager<Result>.get(to: .search, parameters: parameters) { [weak self] (response) in
            switch response{
                case .success(let result):
                    self?.delegate?.didReceiveMovies(result.movies ?? [])
                    break
                case .failure(let error):
                    self?.delegate?.onRequestError(error)
                    break
                case .noInternetConection:
                    self?.delegate?.noInternetConection()
                    break
            }
        }
    }
    
    /// Requests the informations of a given movie
    func detail(of movie:Movie){
        guard let id = movie.id else {
            delegate?.onRequestError("Movie Id invalid")
            return
        }

        RequestManager<Movie>.get(to: Endpoint.detail.add("\(id)")) { [weak self] (result) in
            switch result{
                case .success(let movie):
                    self?.delegate?.didReceiveDetailOf(movie)
                    break
                case .failure(let error):
                    self?.delegate?.onRequestError(error)
                    break
                case .noInternetConection:
                    self?.delegate?.noInternetConection()
                    break
            }
        }
    }
    
    /// Requests the genres of the movies
    func genres(){
        RequestManager<Result>.get(to: .genres) { [weak self] (response) in
            switch response{
                case .success(let result):
                    self?.delegate?.didReceiveGenres(result.genres ?? [])
                    break
                case .failure(let error):
                    self?.delegate?.onRequestError(error)
                    break
                case .noInternetConection:
                    self?.delegate?.noInternetConection()
                    break
            }
        }
    }
}
