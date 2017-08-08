//
//  ViewController.swift
//  PixelCity
//
//  Created by Jeremy Clerico on 08/08/2017.
//  Copyright © 2017 Jeremy Clerico. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController, UIGestureRecognizerDelegate {
    
    //Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    //Variables
    var locationManager = CLLocationManager()
    
    //Constants
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: Double = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        configureLocationServices()
        addDoubleTap()
        
    }
    
    func addDoubleTap() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(dropPin(sender:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        mapView.addGestureRecognizer(doubleTap)
    }
    
    @IBAction func centerMapBtnWasPressed(_ sender: Any) {
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            centerMapOnUserLocation()
        }
    }
    
    
    
}

//Extensions
extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //Prevent function from changing user location blue circle
        if annotation is MKUserLocation {
            return nil
        }
        //Customize Pin Colour
        let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
        pinAnnotation.pinTintColor = #colorLiteral(red: 0.9771530032, green: 0.7062081099, blue: 0.1748393774, alpha: 1)
        //Annotate pin drop
        pinAnnotation.animatesDrop = true
        return pinAnnotation
    }
    
    func centerMapOnUserLocation() {
        guard let coordinate = locationManager.location?.coordinate else { return }
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @objc func dropPin(sender: UITapGestureRecognizer) {
        //Before dropping a pin call removePin (see comments in that func)
        removePin()
        //Get screen coordinates where user drops pin
        let touchPoint = sender.location(in: mapView)
        //Convert the screen coordinates into GPS Coordinates
        let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        //Create instance of droppable pin
        let annotation = DroppablePin(coordinate: touchCoordinate, identifier: "droppablePin")
        //Add to mapView
        mapView.addAnnotation(annotation)
        //Center map on pin when dropped
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(touchCoordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func removePin() {
        //Only want one pin to show at a time, so when user adds a new one, delete the rest - so only keep latest pin
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
        }
    }
}

extension MapVC: CLLocationManagerDelegate {
    func configureLocationServices() {
        if authorizationStatus == .notDetermined {
            //This requests authorization to use location always
            locationManager.requestAlwaysAuthorization()
            //mapView.showsUserLocation = true
        } else {
            //Authorization already approved / denied so just return.
            //mapView.showsUserLocation = true
            return
        }
    }
    
    //When Authorization status changes call centerMapOnUserLocation()
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        centerMapOnUserLocation()
    }
}
