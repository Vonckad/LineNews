//
//  MapViewController.swift
//  LineNews
//
//  Created by Vlad Ralovich on 18.02.2023.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    private lazy var appleMapView: MKMapView = {
        let appleMapView = MKMapView()
        appleMapView.delegate = self
        appleMapView.frame = view.bounds
        
        let initialLocation = CLLocation(latitude: 64.538686, longitude: 40.518267)
        appleMapView.centerToLocation(initialLocation, regionRadius: 2000)
        appleMapView.overrideUserInterfaceStyle = .light
        appleMapView.addAnnotations(artworks)
        return appleMapView
    }()
    
    private let currentPositionButton: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 140, weight: .bold, scale: .large)
        let largelocationIcon = UIImage(systemName: "location.magnifyingglass", withConfiguration: largeConfig)
        
        button.setImage(largelocationIcon, for: .normal)
        button.tintColor = Theme.defaultButtonBackgroundColor
        button.addTarget(nil, action: #selector(camera), for: .touchUpInside)
        return button
    }()
    
    private var artworks: [Artwork] = [
        Artwork(title: "Пешеходный проспект Чумбарова-Лучинского", locationName: "", discipline: "", coordinate: CLLocationCoordinate2D(latitude: 64.53552490468529, longitude: 40.52725168714141)),
        Artwork(title: "Набережная Северной Двины", locationName: "", discipline: "", coordinate: CLLocationCoordinate2D(latitude: 64.538789, longitude: 40.508615)),
        Artwork(title: "Петровский сквер", locationName: "", discipline: "", coordinate: CLLocationCoordinate2D(latitude: 64.53619073003384, longitude: 40.512906206959336)),
        Artwork(title: "Памятник жертвам интервенции", locationName: "", discipline: "", coordinate: CLLocationCoordinate2D(latitude: 64.53517048298956, longitude: 40.51493828805515)),
        Artwork(title: "Обелиск Севера", locationName: "", discipline: "", coordinate: CLLocationCoordinate2D(latitude: 64.54091406729562, longitude: 40.514305230384494))]
    
    //Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.addSubview(appleMapView)
        setupButtons()
    }
    
    //private
    private func setupButtons() {
        view.addSubview(currentPositionButton)
        currentPositionButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16.0)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16.0)
            make.height.equalTo(32.0)
            make.width.equalTo(32.0)
        }
    }
    
    @objc
    private func camera() {
        let locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        appleMapView.setUserTrackingMode(.follow, animated: true)
    }
}

//MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if !(annotation is Artwork) { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationIdentifier")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "annotationIdentifier")
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: "map_point")
        
        return annotationView
    }
}

//MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard let location = appleMapView.userLocation.location else { return }
        appleMapView.centerToLocation(location, regionRadius: 1000)
    }
}

//MARK: - MKMapView
private extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
