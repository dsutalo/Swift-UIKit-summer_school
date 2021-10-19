//
//  ViewController.swift
//  Project16
//
//  Created by Domagoj Sutalo on 16.08.2021..
//
import MapKit
import UIKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCities()
        chooseMapType()
        setBarButton()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil{
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else{
            annotationView?.annotation = annotation
        }
        //challenge 1
        annotationView?.pinTintColor = .blue
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else {return}
        //challenge 3
        let vc = WebViewController()
        vc.capitalCityName = capital.title
        navigationController?.pushViewController(vc, animated: true)
        
//        let placeName = capital.title
//        let placeInfo = capital.info
//
//        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "Ok", style: .default))
//        present(ac, animated: true)
    }
    
    @objc func chooseMapType(){
        let ac = UIAlertController(title: "Select map type", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Standard", style: .default, handler: setMapType))
        ac.addAction(UIAlertAction(title: "Satellite", style: .default, handler: setMapType))
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: setMapType))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    //challenge 2
    func setMapType(action: UIAlertAction){
        guard let actionTitle = action.title else {return}
        switch actionTitle{
        case "Standard":
            mapView.mapType = MKMapType.standard
        case "Satellite":
            mapView.mapType = MKMapType.satellite
        case "Hybrid":
            mapView.mapType = MKMapType.hybrid
        default:
            mapView.mapType = MKMapType.standard
        }
    }
    
    func setCities(){
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Host of 2012 olympic games")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Eiffel tower is here")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Very old city")
        let zagreb = Capital(title: "Zagreb", coordinate: CLLocationCoordinate2D(latitude: 45.815399, longitude: 15.966568), info: "Kaptol and Gradec were here before")
        
        mapView.addAnnotations([london,paris,oslo,zagreb])
    }
    
    func setBarButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Map type", style: .plain, target: self, action: #selector(chooseMapType))
    }
}

