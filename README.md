# EventLists
A page shows a list of events, and able to be used in an offline state. 

## Feature

✅ User is able to favorite/unfavorite events by tapping a button on the cell which indicates the current state.

✅ Pagination is implemented to display the full list.

✅ Action for favorite/unfavorite is persisted locally on the device.

✅ Able to use the app in an offline state. 
(Persisted events will be presented to the user if there is no connection, with up-to-date events being presented if a connection is available.)

## Installation

```bash
$ git clone https://github.com/youhsuan/EventLists.git
$ cd EventLists
$ pod install
$ open EventLists.xcworkspace
```

## Environment

* macOS Catalina 10.15.6
* Xcode 12.0.1
* CocoaPods 1.9.3

## Language

* Swift 5.3

## Architecture

### M-V-VM

### Concept

```
                                        +----------------+
                                +------ | StorageManager |
                                |       +----------------+
                                |
        +----------------+      |      +------------+
        | AppCoordinator |<----------- | APIManager |
        +-------+--------+      |      +------------+
                |               |
                v               |     +----------------+
+--------------------------+    +-----| NetworkManager |
|       EventService       |          +----------------+
+--------------------------+
                |
    +----------+------------+
    |                       |
    v                       v
+--------------+    +-----------------+
|  ViewModel   |    |    ViewModel    |
+------+-------+    | (In the future) |
       |            +-----------------+
       v
+----------------+
| ViewController |
+-------+--------+
        |
        v
   +--------+
   |  View  |
   +--------+
```

## Structure

### Coordinator:
1. `AppCoordinator` owns the services to make sure that we are operating the same service through out the entire app, and this can be accomplished by using dependency injection.

### Services:
1.  `APIManager` is responsible for fetching the data through endpoint.
2.  `StorageManager` is responsible for handling CoreData framework.
3.  `NetworkManager` is responsible for monitoring the network status.
4.  `EventService` is responsible for managing the above listed managers, and will be injected into view model object.

### ViewModel:
1.  `EventsViewModel` is reponsible for the logic. For example:
        * Judging the network connection status and call method accordingly.
        * Update query parameter `page` value when user scrolls to the bottom.
        * Call `updateFavoriteStatus` method when user tapped favorite button.

### Models:
1. `EventList` and `Event` are conform to `Decodable`, which are able to decode from server response.
2. `EventDetail` is the model that contains `Event` and `isFavorite` information, which is the data source type to display in table view.
3. `APIError` and `StorageError` are models unrelated to UI.

### Views:
1. `EventListViewController` and `EventTableViewCell` are responsible for UI related code, and user interaction as well. They won't be communicated with other services except the viewModel.


## Design pattern

### Composition
Use `protocol` to separate different resposibilties, and abstract the object as well.

### Dependency injection
Different responsibility object was injected to `EventService`, which means `EventService` doesn't own the `APIManager` object , `StorageManager` object or `NetworkManager` object.

### Observer
Use `NotificationCenter` to post notification of network status changed.

## CocoaPods

For 3rd party frameworks management.

#### Image

* Kingfisher

## Reference

* [Kingfisher](https://github.com/onevcat/Kingfisher)
