import Foundation
import RealmSwift

/// Realm is the offline database implementation that is local to the device.
/// Gets email from signup and stores it offline. If connection not available user can still login offline read only mode
///
class User: Object {
    
    dynamic var email = ""
    dynamic var loginDate = NSDate()
}


class Trip: Object {
    dynamic var tripname = ""
    dynamic var tripCity = ""
    dynamic var startDate = ""
    dynamic var endDate = ""
    let venues = List<Venue>()
}

class Venue: Object {
    dynamic var venueName = ""
    let types = List<VenueList>()
    dynamic var venueAddress = ""
    dynamic var venueLatitude = ""
    dynamic var venueLongitude = ""
}

class VenueList: Object {
    dynamic var venueType = ""
}