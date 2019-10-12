//
//  FilterDetailPresenter.swift
//  Movies
//
//  Created by Jonathan Martins on 09/10/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import Foundation

// MARK: - FilterDetailPresenterDelegate
protocol FilterDetailPresenterDelegate:class {
    
    /// The number of items in the dates datasource
    var numberOfDates:Int{ get }
    
    /// The number of items in the genres datasource
    var numberOfGenres:Int{ get }

    /// Bindas the view to this presenter
    func bind(to view:FilterDetailViewDelegate, _ service:MovieService)
    
    /// RRequests the list of genres
    func getGenres()
}

// MARK: - FilterDetailPresenter
class FilterDetailPresenter{
    
    /// The array to hold the items's values for dates
    let dates = ["2019", "2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", "2009", "2008", "2007", "2006","2005", "2004", "2003", "2002", "2001", "2000", "1999","1998", "1997", "1996", "1995", "1994", "1993", "1992","1991", "1990"]
    
    /// The array to hold the items's values for genres
    var genres:[Genre] = []
    
    /// The service responsible for the requests
    private var service:MovieService!{
        didSet{
            service.delegate = self
        }
    }
    
    /// Callback to update the view
    private weak var view:FilterDetailViewDelegate!
}

// MARK: - FilterDetailPresenterDelegate
extension FilterDetailPresenter: FilterDetailPresenterDelegate{
    
    var numberOfDates: Int {
        return dates.count
    }
    
    var numberOfGenres: Int {
        return genres.count
    }
    
    func getGenres() {
        service.genres()
    }
    
    func bind(to view: FilterDetailViewDelegate, _ service: MovieService) {
        self.view    = view
        self.service = service
    }
}

// MARK: - MovieServiceDelegate
extension FilterDetailPresenter:MovieServiceDelegate{
    
    func didReceiveGenres(_ genres: [Genre]) {
        self.genres = genres
        view.updateFilterList()
    }
    
    func onRequestError(_ error: String) {
        
    }
    
    func noInternetConection() {
        
    }
}
