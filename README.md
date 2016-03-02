Grand Central Board for Apple TV
================================

You can hang a TV in open space or team room to show everyone what's up. 

The board is a lightweight piece of code. TV screen is expected to be in landscape orientation and is split to six nearly square widgets loaded from remote configuration file. This is just a UIView so you can use the space in any way you want. Updating the widget is standardized though and you should not ignore this convention.

👷 Project maintained by: [@nsmeme](http://twitter.com/nsmeme) (Oktawian Chojnacki)

✋ Don't even ask - it's obviously written entirely in ♥️ [Swift 2](https://swift.org).

## Dependencies

We use [CocoaPods](https://cocoapods.org) and current dependencies are:

- [Alamofire](https://github.com/Alamofire/Alamofire)
- [Decodable](https://github.com/Anviking/Decodable)

## Widgets

### Adding a new Widget

There is a separate article [NEW-WIDGET-TUTORIAL.md](http://TUTORIAL URL) about adding a new widget.

### Components

Four main components are making a Widget:

- **View** - a view implementing `ViewModelRendering` protocol that display the information.
- **Source** - implements one of the updating strategies (further described below).
- **Widget** - controller class implementing `Widget` protocol, exposed to the scheduler and connecting previous two with each other.
- **WidgetBuilder** - implements `WidgetBuilding` protocol, instantiate Widget with settings from configuration file.

### Widgets order on screen

![image](./README/widgets.png)

### Size

Widget canvas for 1080p:

- 640px x 540px

This size is constant and won't change on tvOS. Future releases are planned for iOS devices and they can have slightly different (and more dense) canvases.

### Configuration

A remote `JSON` file with this format is used to configure Grand Central Board:

```json
{ "widgets":[ 
    {"name":"somewatch", "settings":  {"timeZone":"Europe/Warsaw"} },
    {"name":"somewatch", "settings":  {"timeZone":"Europe/Warsaw"} },
    {"name":"somewatch", "settings":  {"timeZone":"Europe/Warsaw"} },
    {"name":"somewatch", "settings":  {"timeZone":"Europe/Warsaw"} },
    {"name":"somewatch", "settings":  {"timeZone":"Europe/Warsaw"} },
    {"name":"somewatch", "settings":  {"timeZone":"Europe/Warsaw"} }
]}

```

NOTE: Each widget will have it's own settings properties.

## View States

Widget view should show these states:

- **Waiting** - starting state, presenting some activity indicator.
- **Rendering** - presenting information (after render method is called).
- **Failed** - data failed to load, should be avoided if possible.

## Source

The source should implement one of the two protocols:

- **Synchronous** - the source will return value synchronously in a non-blocking way.

```swift
protocol Synchronous : Source {
    func read() -> ResultType
}
```

- **Asynchronous** - the source will call the provided block after the value is retrieved. 

```swift
protocol Asynchronous : Source {
    func read(closure: (ResultType) -> Void)
}
```

Fail can be handled silently, but they may be some Widgets where fail state should be presented - it's up to you.

All strategies inherit the **Source** protocol:

```swift

enum SourceType {
    case Cumulative
    case Momentary
}

enum Result<T> {
    case Failure(ErrorType)
    case Success(T)
}

protocol Source {

    typealias ResultType

    var sourceType: SourceType { get }
    var optimalFrequency: NSTimeInterval { get }
}
```

# Summary

This project just started and there is a lot to do. If you want to contribute please add an issue and discuss your plans with us. We will try to help and this will ensure that two people won't work on the same thing.