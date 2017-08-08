//
//  ViewController.swift
//  PixelCity
//
//  Created by Jeremy Clerico on 08/08/2017.
//  Copyright © 2017 Jeremy Clerico. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    
    //Variables
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        
    }
    
    @IBAction func centerMapBtnWasPressed(_ sender: Any) {
    }
    
    
    
}

extension MapVC: MKMapViewDelegate {
    
}
