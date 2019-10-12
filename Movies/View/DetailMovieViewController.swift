//
//  DetailMovieViewController.swift
//  Movies
//
//  Created by Jonathan Martins on 10/10/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit

protocol DetailMovieViewDelegate:class {
    
    /// Sets the poster of the movie
    func updateMoviePoster(_ url:String?)
    
    /// Sets the title of the movie
    func updateMovieTitle(_ title:String?)
    
    /// Sets the genres of the movie
    func updateMovieGenre(_ genres:String?)
    
    /// Sets the date of the movie
    func updateMovieReleaseDate(_ date:String?)
    
    /// Sets the description of the movie
    func updateMovieOverview(_ overview:String?)
    
    /// indicate sif the movie was favorited or not by the user
    func updateIsMovieFavorite(_ isFavorite:Bool)
    
    /// Shows a feedback message to the user
    func showFeedback(_ message:String)
}

class DetailMovieViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var movieGenre:UILabel!
    @IBOutlet weak var movieTitle:UILabel!
    @IBOutlet weak var moviePoster:UIImageView!
    @IBOutlet weak var movieRelease:UILabel!
    @IBOutlet weak var movieOverview:UILabel!
    
    // MARK: - Constants
    private let presenter = DetailMoviePresenter()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTranslucentNavigationBar()
        presenter.getMovieDetails()
    }
    
    /// Sets up the presenter
    func setup(with movie:Movie){
        presenter.bind(to: self, movie, service: MovieService(), storage: LocalStorageManager())
    }

    /// Makes the NavigationBar translucent
    private func setTranslucentNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }

    /// Action to favorite the movie
    @objc private func favoriteAction(){
        presenter.favorite()
    }
}

// MARK: - DetailMovieViewDelegate
extension DetailMovieViewController:DetailMovieViewDelegate{
    
    func showFeedback(_ message: String) {
        showAlert(title: "Ops!", message: message)
    }
    
    func updateMoviePoster(_ url: String?) {
        if let url = url{
            moviePoster.load(url)
        }
    }
    
    func updateMovieTitle(_ title: String?) {
        movieTitle.text = title
    }
    
    func updateMovieGenre(_ genres: String?) {
        movieGenre.text = genres
    }
    
    func updateMovieReleaseDate(_ date: String?) {
        movieRelease.text = date
    }
    
    func updateMovieOverview(_ overview: String?) {
        movieOverview.text = overview
    }
    
    func updateIsMovieFavorite(_ isFavorite: Bool) {
        let favorite = UIBarButtonItem(image: UIImage(named: isFavorite ? "icon_favorite_over":"icon_favorite"), style: .plain, target: self, action: #selector(favoriteAction))
        navigationItem.rightBarButtonItem = favorite
    }
}
