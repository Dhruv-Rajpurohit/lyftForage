//
//  MapViewController.swift
//  RideSharer
//
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        
        // Check for location services authorization
        checkLocationAuthorizationStatus()
    }
    
    func checkLocationAuthorizationStatus() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            // Permission granted; show user's location on the map
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            // Permission denied or restricted; show an alert
            showLocationDeniedAlert()
        case .notDetermined:
            // Request location authorization
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
    
    func showLocationDeniedAlert() {
        let alertController = UIAlertController(
            title: "Location Access Denied",
            message: "Please enable location access in Settings to use this feature.",
            preferredStyle: .alert
        )
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
    }
    
}
