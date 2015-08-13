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
        
        var forwardButton = UIButton()
        forwardButton.setImage(UIImage(named:"FullPostButton"), forState: nil)
        forwardButton.frame = CGRectMake(0.0, 0.0, 25, 25)
        
        if let annotation = annotation as? Marker {
            let identifier = "marker"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
                view.pinColor = annotation.pinColor()
                
            } else {
                let id = "\(arc4random())"
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: id)
                view.canShowCallout = true
                view.userInteractionEnabled = true
                view.enabled = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                
                view.pinColor = annotation.pinColor()
                
                //what the fuck why isnt this working
                
                
                if view.pinColor == .Green {
                    view.rightCalloutAccessoryView = forwardButton as UIView
                } else if view.pinColor == .Red {
                    view.userInteractionEnabled = false
                    view.canShowCallout = false
                    view.enabled = false
                    println(view.annotation)
                } else if view.pinColor == .Purple {
                    view.rightCalloutAccessoryView = forwardButton as UIView
                } else {
                    view.enabled = false
                    view.userInteractionEnabled = false
                }
                
            }
            
            return view
        }
        return nil
    }

    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        performSegueWithIdentifier("showFullPostFromAnnotation", sender: self)
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        
        //that is some shitty error checking
        //need a better way- but for now it's to check that the view.annotation.title doesn't equal that string. 
        
        if "\(view.annotation.title)" != "Optional(Current Location)" {
            let annotationMarker: Marker = view.annotation as! Marker
            selectedPost = annotationMarker.post
        }

    }
    
    
}