//
//  VCMapView.swift
//  i_am_here
//
//  Created by Edward Yoo on 7/17/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

extension MapViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? Marker {
            let identifier = "marker"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.pinColor = annotation.pinColor()
                if view.pinColor == .Green {
                    view.rightCalloutAccessoryView = UIButton.buttonWithType(.ContactAdd) as! UIView
                }
            }
            
            return view
        }
        return nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showFullPostFromAnnotation" {
            let fullPostViewController = segue.destinationViewController as! FullPostViewController

            fullPostViewController.wholePost = selectedPost
        }
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        performSegueWithIdentifier("showFullPostFromAnnotation", sender: self)
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        let annotationMarker: Marker = view.annotation as! Marker
        
        selectedPost = annotationMarker.post

    }
    
    
}