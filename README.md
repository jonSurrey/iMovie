<h1 align="center">iMovie!</h1>
<p align="center">
A simple SWIFT app using the MVP pattern to discover and search any popular movies.
</p>

### API
This app makes use of the API from Movie DB to fetch the results.
The endpoints in this project:
- discover: https://developers.themoviedb.org/3/discover/movie-discover
- search: https://developers.themoviedb.org/3/search/search-movies
- details: https://developers.themoviedb.org/3/movies/get-movie-details
- genres: https://developers.themoviedb.org/3/genres/get-movie-list

for more information refer to: https://developers.themoviedb.org/3/getting-started/introduction

### Layout
The app interface was builded using StoryBoard with a few custom views using View Code. 
The app flux consists in 4 Screens:
- Popular Movies
- Favorite Movies
- Movie Details
- Filter
- Search

### Pagination
The "Popular Movies" and "Search" screens makes use of EndlessScroll to fetch more results according to the given page number and filters.

### Persistence
This app uses CoreData to to save the first movie results and the his/her favorite movies, so the he/she can see them a next time even if there is no internet conection.

### Error Handling
The performed requests handle successful results, failure results and no internet connection, so we can give the right feedback to the user.

### Tests
The app was built using MVP architecture and (DIP)Dependency Injection Pattern to make it easier for Unit-Testing
