//
//  UberMapViewRepresentable.swift
//  UberSwiftUI
//
//  Created by Shivankit on 23/06/24.
//

import SwiftUI
import CoreLocation
import MapKit


struct UberMapViewRepresentable: UIViewRepresentable {
    
    let mapView = MKMapView()
    let locationManager = LocationManager.shared
    @Binding var mapState: MapViewState
    @EnvironmentObject var locationViewModel : LocationSearchViewModel
    
    //UIViewRepresentable protocol of this
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = COREVIDEO_TRUE
        mapView.userTrackingMode = .follow
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
        switch mapState {
        case .noInput:
            context.coordinator.clearMapViewAndRecenterOnUserLocation()
            break
        case .locationSelected:
            if let selectedLocation = locationViewModel.selectedUberLocationCoordinates{
                context.coordinator.addAndSelectAnnotation(withCoordinate: selectedLocation.coordinate)
                context.coordinator.configurePolyLine(withDestinationCoordinate: selectedLocation.coordinate)
            }
            break
        case .searchigForLocation:
            break
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
    
    
    
}

extension UberMapViewRepresentable{
    
    class MapCoordinator: NSObject, MKMapViewDelegate{
        
        let parent: UberMapViewRepresentable
        var userLocationCoordinate: CLLocationCoordinate2D?
        var currentRegion: MKCoordinateRegion?
        init(parent: UberMapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocationCoordinate = userLocation.coordinate
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            self.currentRegion = region
            parent.mapView.setRegion(region, animated: true)
           
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let overLay = MKPolylineRenderer(overlay: overlay)
            overLay.strokeColor = .systemBlue
            overLay.lineWidth = 6
            return overLay
        }
        
        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D){
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            let anno = MKPointAnnotation()
            anno.coordinate = coordinate
            self.parent.mapView.addAnnotation(anno)
            self.parent.mapView.selectAnnotation(anno, animated: true)
           // self.parent.mapView.showAnnotations(parent.mapView.annotations, animated: true)
        }
        
        func configurePolyLine(withDestinationCoordinate coordinate : CLLocationCoordinate2D){
            guard let userLocationCoordinate = self.userLocationCoordinate else {return}
            getDestinationRoute(from: userLocationCoordinate, to: coordinate) { route in
                self.parent.mapView.addOverlay(route.polyline)
                let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect,edgePadding: .init(top: 64, left: 32, bottom: 500, right: 32))
                self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
        
        func getDestinationRoute(from userLocation: CLLocationCoordinate2D, to destinationCoordinates: CLLocationCoordinate2D, comppletion: @escaping(MKRoute) -> Void){
            let userPlaceMark = MKPlacemark(coordinate: userLocation)
            let destPlaceMark = MKPlacemark(coordinate: destinationCoordinates)
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: userPlaceMark)
            request.destination = MKMapItem(placemark: destPlaceMark)
            let direction = MKDirections(request: request)
            
            direction.calculate{ response, error in
                if let error = error {
                    print("DEBUG: Failed to get direction with error \(error.localizedDescription)")
                    return
                }
                guard let route = response?.routes.first else {return}
                comppletion(route)
                
            }
        }
        func clearMapViewAndRecenterOnUserLocation() {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)
            if let currentRegion = currentRegion{
                parent.mapView.setRegion(currentRegion, animated: true)
            }
        }
    }
}
