//
//  Constants.swift
//  PixelCity
//
//  Created by Jeremy Clerico on 08/08/2017.
//  Copyright © 2017 Jeremy Clerico. All rights reserved.
//

import Foundation

let apiKey = "bba6f1369b5d910c43d8323f28e24b4e"

func flickrUrl(forApiKey key: String, withAnnotation annotation: DroppablePin, andNumberOfPhotos number: Int) -> String {
    return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&lat=\(annotation.coordinate.latitude)&lon=\(annotation.coordinate.longitude)&radius=1&radius_units=mi&per_page=\(number)&format=json&nojsoncallback=1"
}
