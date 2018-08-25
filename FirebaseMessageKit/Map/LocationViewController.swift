

import Foundation
import MapKit

class LocationViewController : UIViewController {
    
    var location: CLLocation!
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var addressLabel: UILabel!
    override func viewDidLoad() {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(self.location, completionHandler: { (placemarks, error) -> Void in
            if let placemark = placemarks?.first, let _ = placemark.location {
                let topResult:CLPlacemark = placemarks![0];
                let placeMark = MKPlacemark(placemark: topResult)
                self.dropPinZoomIn(placemark: placeMark)
                // Location name
                if let locationName = placeMark.name  {
                    print(locationName)
                    self.addressLabel.text = locationName
                }
            }
            // Place details
         
        })
    }
    
    func dropPinZoomIn(placemark:MKPlacemark){
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
    }
}
