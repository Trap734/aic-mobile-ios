/*
Abstract:
This class represents a floor of the museum, including the visual map overlay,
amenities, gallery names, and general text information
*/

import MapKit

class AICMapFloorModel {
	var allAnnotations: [MKAnnotation] {
		get {
			var annotations: [MKAnnotation] = []

			annotations += amenityAnnotations as [MKAnnotation]
			annotations += departmentAnnotations as [MKAnnotation]
			annotations += spaceAnnotations as [MKAnnotation]
			annotations += objectAnnotations as [MKAnnotation]

			return annotations
		}
	}

	var departmentSpaceAnnotations: [MKAnnotation] {
		get {
			return (departmentAnnotations as [MKAnnotation]) + (spaceAnnotations as [MKAnnotation])
		}
	}

	let overlay: FloorplanOverlay

	let amenityAnnotations: [MapAmenityAnnotation]
	let departmentAnnotations: [MapDepartmentAnnotation]
	let spaceAnnotations: [MapTextAnnotation]
	let galleryAnnotations: [MapTextAnnotation]

	let objectAnnotations: [MapObjectAnnotation] // All objects taht exist on this floor
	let farObjectAnnotations: [MapObjectAnnotation]

	var tourStopAnnotations: [MapObjectAnnotation] = []

	private (set) var restroomAnnotations: [MapAmenityAnnotation] = []
	private (set) var memberLoungeAnnotations: [MapAmenityAnnotation] = []
	private (set) var giftShopAnnotations: [MapAmenityAnnotation] = []
	private (set) var diningAnnotations: [MapAmenityAnnotation] = []

	let floorNumber: Int

	init(floorNumber: Int,
		 overlay: FloorplanOverlay,
		 objects: [MapObjectAnnotation],
		 farObjects: [MapObjectAnnotation],
		 amenities: [MapAmenityAnnotation],
		 departments: [MapDepartmentAnnotation],
		 galleries: [MapTextAnnotation],
		 spaces: [MapTextAnnotation]) {
		self.floorNumber = floorNumber
		self.overlay = overlay
		self.amenityAnnotations = amenities
		self.objectAnnotations = objects
		self.farObjectAnnotations = farObjects
		self.departmentAnnotations = departments
		self.galleryAnnotations = galleries
		self.spaceAnnotations = spaces

		for amenity in amenities {
			if amenity.type == .Dining {
				diningAnnotations.append(amenity)
			} else if amenity.type == .MembersLounge {
				memberLoungeAnnotations.append(amenity)
			} else if amenity.type == .Giftshop {
				giftShopAnnotations.append(amenity)
			} else if amenity.type == .MensRoom || amenity.type == .WomensRoom || amenity.type == .FamilyRestroom {
				restroomAnnotations.append(amenity)
			}
		}
	}

	func setTourStopAnnotations(forTourStopModels tourStopmodels: [AICTourStopModel]) {
		for stopModel in tourStopmodels {
			setTourStopAnnotation(forStopModel: stopModel)
		}
	}

	// Make sure we actually have a tour object on this floor
	// then mark it as one we're showing
	func setTourStopAnnotation(forStopModel stopModel: AICTourStopModel) {
		if let annotation = getAnnotationForObject(object: stopModel.object) {
			annotation.tourStopOrder = stopModel.order + 1 // set index in annotation model to show on annotation view
			tourStopAnnotations.append(annotation)
		}
	}

	func clearActiveAnnotations() {
		tourStopAnnotations = []
	}

	private func getAnnotationForObject(object: AICObjectModel) -> MapObjectAnnotation? {
		return objectAnnotations.filter({ $0.nid == object.nid }).first
	}
}
