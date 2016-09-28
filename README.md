# Smart Trip iOS Client

Itinerary builder companion application to the [service component](https://github.com/kelvinharron/smart-trip-service), created for my Masters Individual Project.

Current build is Swift 2.2. Views designed for iPhone 6, 6S and 7 screen sizes.

Demoed with service component running on localhost, current location settings are hardcoded to Belfast.

### Dependencies

- [Alamofire](https://github.com/Alamofire/Alamofire)
- [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
- [Realm](https://github.com/realm/realm-cocoa)

### To-do 

1. Migrate to Swift 3.
2. Refactor needed throughout service as lots of bloated ViewController files are present.
3. Rebuild views to reszie to screen size of iPhone.
3. Further introduce Realm read and write, checking if connection is offline and allowing a read only mode of existing trips and venues.
