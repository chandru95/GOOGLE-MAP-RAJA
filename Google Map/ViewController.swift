
import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces


class ViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate,UISearchBarDelegate{
  
    
   
    let manager = CLLocationManager()
    var mapView: GMSMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        manager.delegate = self
        
        GMSServices.provideAPIKey("AIzaSyBkv5Ae8qqT43Q98EFhgFGahQ38G0P9Scw")
        GMSPlacesClient.provideAPIKey("AIzaSyBkv5Ae8qqT43Q98EFhgFGahQ38G0P9Scw")
       
        
        // search Bar
     
        let searchButton = UIButton(type: .system)
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search for a place"
        navigationItem.titleView = searchBar
        view.addSubview(searchBar)
     

      

        
        
        let camera = GMSCameraPosition.camera(withLatitude: 13.08, longitude: 80.27, zoom: 8.0)
        mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
        mapView?.delegate = self
        mapView?.isMyLocationEnabled = true
//        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView?.settings.compassButton = true
        view.addSubview(mapView!)
        
      
      

        
        let currentLocationButton = UIButton(type: .system)
        currentLocationButton.setTitle("Current Location ", for: .normal)
        currentLocationButton.tintColor = .white
        currentLocationButton.addTarget(self, action: #selector(showCurrentLocation), for: .touchUpInside)
        view.addSubview(currentLocationButton)
        
        currentLocationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currentLocationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            currentLocationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        // Tap gesture to mark the location
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        mapView?.addGestureRecognizer(tapGesture)
        
        // Create a Zoom-In button
        let zoomInButton = UIButton(type: .system)
        zoomInButton.setTitle("+", for: .normal)
        zoomInButton.addTarget(self, action: #selector(zoomInButtonTapped), for: .touchUpInside)
        zoomInButton.frame = CGRect(x: 200, y: -300, width: 20, height: 5)
        view.addSubview(zoomInButton)
        
        // Create a Zoom-Out button
        let zoomOutButton = UIButton(type: .system)
        zoomOutButton.setTitle("-", for: .normal)
        zoomOutButton.addTarget(self, action: #selector(zoomOutButtonTapped), for: .touchUpInside)
        view.addSubview(zoomOutButton)
        
        // Add Auto Layout constraints for the buttons
        zoomInButton.translatesAutoresizingMaskIntoConstraints = false
        zoomOutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            zoomInButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            zoomInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            zoomOutButton.topAnchor.constraint(equalTo: zoomInButton.bottomAnchor, constant: 8),
            zoomOutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
        
        // Print the license information
        print("License:\n\n\(GMSServices.openSourceLicenseInfo())")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            
          
            
            return
        }
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        // Use 'latitude' and 'longitude' to work with the current location.
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     //GMSServices.provideAPIKey("")
        return true
    }

   
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            let touchPoint = gestureRecognizer.location(in: mapView)
            let coordinate = mapView?.projection.coordinate(for: touchPoint)
            
            if let coord = coordinate {
                // Create a new marker at the tapped location
                let marker = GMSMarker(position: coord)
                marker.title = "Custom Location"
                marker.snippet = "This is a custom location"
                marker.map = mapView
            }
        }
    }
    
    @objc func zoomInButtonTapped() {
        // Increase the map's zoom level
        let currentZoom = mapView?.camera.zoom ?? 0
        let newZoom = min(currentZoom + 1.0, 21.0) // Adjust the maximum zoom level as needed
        mapView?.animate(toZoom: newZoom)
    }
    
    @objc func zoomOutButtonTapped() {
        // Decrease the map's zoom level
        let currentZoom = mapView?.camera.zoom ?? 0
        let newZoom = max(currentZoom - 1.0, 1.0) // Adjust the minimum zoom level as needed
        mapView?.animate(toZoom: newZoom)
    }
    
    // Current location button
    @objc func showCurrentLocation() {
        if let userLocation = mapView?.myLocation {
            let camera = GMSCameraPosition.camera(withLatitude: userLocation.coordinate.latitude,
            longitude: userLocation.coordinate.longitude, zoom: 15.0)
            mapView?.animate(to: camera)
        }
    }
    

}
