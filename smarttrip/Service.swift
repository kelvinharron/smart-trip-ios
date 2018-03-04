
/// Simple Constant class used to store global variables
import Foundation

struct response {
	static let SUCCESS_CODE = "200"
	static let ERROR_CODE = "400"
}

/// To allow quick updating of service address and port
struct service {
	static let address = "http://localhost"
	static let host = ":7892"
}

/// API endpoints used for querying the Node service
struct API {
	static var checkServiceURL = service.address + service.host + "/status/"
	static var loginURL = service.address + service.host + "/api/user/login"
	static var signupURL = service.address + service.host + "/api/user/signup"
	
	static var getAllTripsURL = service.address + service.host + "/api/trip/"
	static var getSingleTripURL = service.address + service.host + "/api/trip/"
	static var addNewTripURL = service.address + service.host + "/api/trip/"
	static var deleteTripURL = service.address + service.host + "/api/trip/"
	
	static var getAllVenuesURL = service.address + service.host + "/api/venue/"
	static var getSingleVenueURL = service.address + service.host + "/api/venue/"
	static var searchVenuesURL = service.address + service.host + "/api/venue/search"
	static var addNewVenueURL = service.address + service.host + "/api/venue/"
	static var deleteVenueURL = service.address + service.host + "/api/venue/"
}

