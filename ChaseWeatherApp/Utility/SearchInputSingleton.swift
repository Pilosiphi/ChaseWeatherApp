import Foundation

//Primary function of this singleton is to have a way to track the users intended method of searching.
//Additionally adds a route to pass Search String values back into Weather View Controller.

class SearchInputSingleton {
    static let sharedInstance = SearchInputSingleton()
    var searchString: (String,String)?
    var searchType: SearchType = .inputCancelled
    
    func clearSearchValues() {
        searchString = nil
        searchType = .inputCancelled
    }
    
}

enum SearchType: Int {
    case inputCancelled = 0
    case byCityState
    case byGeoCoordinates
    
}
