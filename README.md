Grand Central Board
===================

## Widgets

### Order on screen

![image](./README/widgets.png)

### Size

Widget canvas for 1080p:

- 640px x 540px

This size is constant and won't change on tvOS. Future releases are planned for iOS devices and they can have slightly different (and more dense) canvases. 


### Adding a new Widget

Three main components are important for adding a Widget:

- **Model** - implements one of the updating strategies (further described below)
- **View** - a view that display the information
- **Widget subclass** - controller class setting up the scheduler and connecting previous two.

### View State

Widget View should show these states:

- **Waiting** - starting state, presenting some activity indicator
- **Rendering** - presenting information
- **Failed** - data failed to load, should be avoided if possible


### Updating strategies of the Source

The source should implement one  of the two protocols:

- Synchronous - the source will return value synchronously in a non-blocking way.

```
protocol Synchronous : Source {
    var value: ValueType? { get }
}
```

- Asynchronous - the source will call the provided block after the value is retrieved. 

```
protocol Asynchronous : Source {
    func read(block: (ValueType?) -> Void)
}
```

Any fail should be handled silently and printed to console in debug build but not presented to the user in any way.

All strategies implement the **Source** protocol:


```
enum SourceType: Int {
    case Cumulative
    case Momentary
}

enum Result<T> {
    case Failure
    case Success(T)
}

protocol Source {

    typealias ResultType

    var sourceType: SourceType { get }
    var optimalFrequency: NSTimeInterval { get }
}
```