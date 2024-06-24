//
//  LocationSearchViewModel.swift
//  UberSwiftUI
//
//  Created by Shivankit on 23/06/24.
//

import Foundation
import MapKit

class LocationSearchViewModel: NSObject,ObservableObject{
    
    //MARK: Properties
    
    @Published var result = [MKLocalSearchCompletion]()
    @Published var selectedUberLocationCoordinates: UberLocation?
    @Published var pickUpTime: String?
    @Published var dropOffTime: String?
    private let searchCompleter = MKLocalSearchCompleter()
    
    var queryFragment: String = "" {
        didSet{
            print("Debug \(queryFragment)")
            searchCompleter.queryFragment = queryFragment
        }
    }
    var userLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    
    func selectedLocation(_ localSearch: MKLocalSearchCompletion){
        locationSearch(forLocalSearchCompletion: localSearch) { response, errror in
            if let error = errror{
                print("DEBUG: error \(error.localizedDescription) ")
                return
                
            }
            guard let item = response?.mapItems.first else {return}
            let coordinate = item.placemark.coordinate
            self.selectedUberLocationCoordinates = UberLocation(title: localSearch.title, coordinate: coordinate)
            print("DEBUG: location coordinates \(coordinate)")
        }
    }
    
    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion, completion: @escaping MKLocalSearch.CompletionHandler){
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: completion)
    }
    
    func computeRidePrice(forType type: RideType) -> Double {
        guard let coordinate = selectedUberLocationCoordinates?.coordinate else {return 0.0}
        guard let userLocation = self.userLocation else {return 0.0}
        
        let usersLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let destination = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        let tripDestinceInMeter = usersLocation.distance(from: destination)
        
        return type.computePrice(for: tripDestinceInMeter)
        
    }
}

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.result = completer.results
    }
    
}
