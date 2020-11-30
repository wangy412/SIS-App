//
//  MapView.swift
//  SIS App
//
//  Created by Wang Yunze on 17/10/20.
//

import CoreLocation
import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    @EnvironmentObject var userLocationManager: UserLocationManager

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)

        // Delegate
        mapView.delegate = context.coordinator

        // Overlays (for debugging geofences)
        for block in DataProvider.getBlocks() { // Blocks
            print("adding overlay... \(block.name)")
            mapView.addOverlay(MKCircle(
                center: block.location.toCLLocation().coordinate,
                radius: block.radius
            )
            )
        }
        mapView.addOverlay(
            MKCircle(
                center: Constants.schoolLocation.coordinate,
                radius: Constants.schoolRadius
            )
        )
        
        // Overlays for blocks
        let blockOutlines = FileUtility.getDataFromJsonAppbundleFile(filename: "overlay_coords.json", dataType: [BlockOutlineInfo].self)!
        
        for outline in blockOutlines {
            
            let boundary = outline.boundary.map {
                CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
            }
            print("adding outline: \(outline.block), \(boundary)")
            mapView.addOverlay(
                MKPolygon(
                    coordinates: boundary,
                    count: outline.boundary.count
                )
            )
        }

        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context _: Context) {
        // Follow User Location
        let coordinate = userLocationManager.userLocation?.coordinate ?? CLLocationCoordinate2D()
        let span = MKCoordinateSpan(
            latitudeDelta: 0.001,
            longitudeDelta: 0.001
        )
        let region = MKCoordinateRegion(
            center: coordinate,
            span: span
        )
        mapView.showsUserLocation = true
        mapView.setRegion(region, animated: true)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            print("overlay: \(overlay)")
            if overlay is MKCircle {
                let circle = MKCircleRenderer(overlay: overlay)
                circle.strokeColor = UIColor.red
                circle.fillColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.1)
                circle.lineWidth = 1
                return circle
            }
            if overlay is MKPolygon {
                print("drawing outline")
                let polygonView = MKPolygonRenderer(overlay: overlay)
                polygonView.strokeColor = .magenta
                return polygonView
            }

            return MKOverlayRenderer()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(UserLocationManager())
    }
}

struct BlockOutlineInfo: Decodable {
    var block: String
    var boundary: [Location]
}
