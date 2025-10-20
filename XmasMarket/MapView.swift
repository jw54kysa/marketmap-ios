//
//  MapView.swift
//  XmasMarket
//
//  Created by Private Jon  on 26.09.25.
//
import SwiftUI
import MapKit

struct MapView: View {
    
    @StateObject var locationManager = LocationManager()
    
    @StateObject private var standManager = StandManager()
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.340469, longitude: 12.374703),
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )
    
    @State private var selectedTypes: Set<BoothType> = []
    @State private var selectedStand: Stand? = nil
    @State private var isListViewPresented: Bool = false
    
    var filteredLocations: [Stand] {
        if selectedTypes.isEmpty {
            return standManager.stands
        } else {
            return standManager.stands.filter { return selectedTypes.map{$0.rawValue}.contains($0.type) }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                
                // MARK: Map
                
                Map(coordinateRegion: $region,
                    showsUserLocation: true,
                    annotationItems: filteredLocations
                ) { stand in
                    MapAnnotation(coordinate: stand.coordinate) {
                        VStack(spacing: 4) {
                            Button(action: {
                                withAnimation(.easeInOut) {
                                    selectedStand = stand
                                    
                                    var showLocation = stand.coordinate
                                    showLocation.latitude -= 0.00025
                                    
                                    region.center = showLocation
                                    region.span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
                                }
                            }) {
                                Text(stand.boothType.icon)
                                    .font(.title)
                                    .shadow(radius: 3)
                            }
                            
                            if selectedStand == stand {
                                Text(stand.name)
                                    .font(.caption)
                                    .bold()
                                    .padding(6)
                                    .background(RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(.systemBackground))
                                        .shadow(radius: 2))
                            }
                        }
                    }
                }
                .mapStyle(.standard(pointsOfInterest: .including([.publicTransport])))
                .edgesIgnoringSafeArea(.all)

                VStack {
                    
                    // MARK: Schriftzug
                    
                    VStack ( spacing: -10 ) {
                        OutlinedText(text: "MarktKarte", font: .custom("Modak", size: 50, relativeTo: .title),
                                     foreground: .accent, outline: .white, lineWidth: 2)
                        
                        // MARK: Bubble View
                        
                        BubbleView(selectedTypes: $selectedTypes)
                    }
                    
                    Spacer()
                    
                    // MARK: Buttons
                    
                    HStack {
                        
                        Button(action: { isListViewPresented.toggle() }) {
                            Image(systemName: "list.bullet")
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                            
                        Spacer()
                        
                        Button(action: centerOnUser) {
                            Image(systemName: "location.fill")
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                            
                        }
                        
                    }
                    .padding()
                }
                
                if standManager.isLoading {
                    SnowfallLoadingOverlay()
                }
            }
            //.navigationTitle("MarketMap")
            .sheet(item: $selectedStand) { stand in
                BoothDetailSheet(stand: stand)
                    .presentationDetents([.medium, .large])
            }
            // ListView
            .sheet(isPresented: $isListViewPresented) {
                StandListView(standManager: standManager, selectedTypes: $selectedTypes)
                    .presentationDetents([.medium, .large])
            }
        }
    }
    
    func centerOnUser() {
        locationManager.requestLocation()
        
        if let userLocation = locationManager.userLocation {
            withAnimation {
                region.center = userLocation
            }
        }
    }

}

struct MapViewPreviews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

