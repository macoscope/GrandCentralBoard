![SlackKit](https://cloud.githubusercontent.com/assets/8311605/10260893/5ec60f96-694e-11e5-91fd-da6845942201.png)
##iOS/OS X Slack Client Library
###Description
This is a Slack client library for iOS and OS X written in Swift. It's intended to expose all of the functionality of Slack's [Real Time Messaging API](https://api.slack.com/rtm) as well as the [web APIs](https://api.slack.com/web) that are accessible by [bot users](https://api.slack.com/bot-users).

###Installation
####Swift Package Manager
Add SlackKit to your Package.swift

```swift
import PackageDescription

let package = Package(
    dependencies: [
        .Package(url: "https://github.com/pvzig/SlackKit.git", majorVersion: 1)
    ]
)
```

Run `swift-build` on your application’s main directory.

####CocoaPods
Add the pod to your podfile:
```
pod 'SlackKit'
```
and run
```
pod install
```

To use the library in your project import it:
```
import SlackKit
```

###Usage
To use SlackKit you'll need a bearer token which identifies a single user. You can generate a [full access token or create one using OAuth 2](https://api.slack.com/web).

Once you have a token, initialize a client instance using it:
```swift
let client = Client(apiToken: "YOUR_SLACK_API_TOKEN")
```

If you want to receive messages from the Slack RTM API, connect to it.
```swift
client.connect()
```

You can also set options for a ping/pong interval, timeout interval, and automatic reconnection:
```swift
client.connect(pingInterval: 2, timeout: 10, reconnect: false)
```

Once connected, the client will begin to consume any messages sent by the Slack RTM API.

####Web API Methods
SlackKit currently supports the a subset of the Slack Web APIs that are available to bot users:

- api.test
- auth.test
- channels.history
- channels.info
- channels.list
- channels.mark
- channels.setPurpose
- channels.setTopic
- chat.delete
- chat.postMessage
- chat.update
- emoji.list
- files.comments.add
- files.comments.edit
- files.comments.delete
- files.delete
- files.info
- files.upload
- groups.close
- groups.history
- groups.info
- groups.list
- groups.mark
- groups.open
- groups.setPurpose
- groups.setTopic
- im.close
- im.history
- im.list
- im.mark
- im.open
- mpim.close
- mpim.history
- mpim.list
- mpim.mark
- mpim.open
- pins.add
- pins.list
- pins.remove
- reactions.add
- reactions.get
- reactions.list
- reactions.remove
- rtm.start
- stars.add
- stars.remove
- team.info
- users.getPresence
- users.info
- users.list
- users.setActive
- users.setPresence

They can be accessed through a Client object’s `webAPI` property:
```swift
client.webAPI.authenticationTest({
(authenticated) -> Void in
		print(authenticated)
	}){(error) -> Void in
	    print(error)
}
```

####Delegate methods

To receive delegate callbacks for certain events, register an object as the delegate for those events:
```swift
client.slackEventsDelegate = self
```

There are a number of delegates that you can set to receive callbacks for certain events.

#####SlackEventsDelegate
```swift
func clientConnectionFailed(error: SlackError)
func clientConnected()
func clientDisconnected()
func preferenceChanged(preference: String, value: AnyObject)
func userChanged(user: User)
func presenceChanged(user: User?, presence: String?)
func manualPresenceChanged(user: User?, presence: String?)
func botEvent(bot: Bot)
```

#####MessageEventsDelegate
```swift
func messageSent(message: Message)
func messageReceived(message: Message)
func messageChanged(message: Message)
func messageDeleted(message: Message?)
```

#####ChannelEventsDelegate
```swift
func userTyping(channel: Channel?, user: User?)
func channelMarked(channel: Channel, timestamp: String?)
func channelCreated(channel: Channel)
func channelDeleted(channel: Channel)
func channelRenamed(channel: Channel)
func channelArchived(channel: Channel)
func channelHistoryChanged(channel: Channel)
func channelJoined(channel: Channel)
func channelLeft(channel: Channel)
```

#####DoNotDisturbEventsDelegate
```swift
doNotDisturbUpdated(dndStatus: DoNotDisturbStatus)
doNotDisturbUserUpdated(dndStatus: DoNotDisturbStatus, user: User?)
```

#####GroupEventsDelegate
```swift
func groupOpened(group: Channel)
```

#####FileEventsDelegate
```swift
func fileProcessed(file: File)
func fileMadePrivate(file: File)
func fileDeleted(file: File)
func fileCommentAdded(file: File, comment: Comment)
func fileCommentEdited(file: File, comment: Comment)
func fileCommentDeleted(file: File, comment: Comment)
```

#####PinEventsDelegate
```swift
func itemPinned(item: Item?, channel: Channel?)
func itemUnpinned(item: Item?, channel: Channel?)
```

#####StarEventsDelegate
```swift
func itemStarred(item: Item, star: Bool)
```

#####ReactionEventsDelegate
```swift
func reactionAdded(reaction: String?, item: Item?, itemUser: String?)
func reactionRemoved(reaction: String?, item: Item?, itemUser: String?)
```

#####TeamEventsDelegate
```swift
func teamJoined(user: User)
func teamPlanChanged(plan: String)
func teamPreferencesChanged(preference: String, value: AnyObject)
func teamNameChanged(name: String)
func teamDomainChanged(domain: String)
func teamEmailDomainChanged(domain: String)
func teamEmojiChanged()
```

#####SubteamEventsDelegate
```swift
func subteamEvent(userGroup: UserGroup)
func subteamSelfAdded(subteamID: String)
func subteamSelfRemoved(subteamID: String)
```

###Examples
####Leaderboard
Included in the OSX-Sample is an example application of a bot you might make using SlackKit. It’s a basic leaderboard scoring bot, in the spirit of [PlusPlus](https://plusplus.chat).

To configure it, enter your bot’s API token in `AppDelegate.swift` for the Leaderboard bot:

```swift
let learderboard = Leaderboard(token: "SLACK_AUTH_TOKEN")
```

It adds a point for every `@thing++`, subtracts a point for every `@thing--`, and shows a leaderboard when asked `@botname leaderboard`.

###Get In Touch
[@pvzig](https://twitter.com/pvzig)

<peter@launchsoft.co>
