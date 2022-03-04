# MMMPushNotificationStore

Store incoming push notifications locally in a shared App group on iOS.

## Installation

```sh
npm install mmm-push-notification-store
```

## Usage

This package requires you to already have push notifications setup. Please note
that it **won't work without** sending `{"mutable-content": 1}` headers, this is
critical for the NotificationExtension to kick in.

There are 2 parts of this framework:

### Storing notifications

For this we need 2 things in Xcode first:
 - Setting up an App Group, so the extension and the app can share data
 - Adding a NotificationExtension target to the xcworkspace

#### Setting up an App Group

To set up an app group you need to open the iOS `.xcworkspace` file of your
project, click on the project and navigate to the App target. Under the
"Signing & Capabilities" tab you can hit `+ Capability`, select App Group here.
After adding the capability you're now able add a container inside the App Group,
you can enter an identifier here, this can be the bundle ID of your app for
instance; we'll use `group.com.example.mmmpushnotificationstore` in this example. For more
information read the [Apple docs](https://developer.apple.com/documentation/xcode/configuring-app-groups?changes=_8_7).

#### Configuring the NotificationExtension

Now it's time to add the notification extension, go to `File -> New -> Target`
and select 'Notification Service Extension', enter a logical name
(we'll use `MyNotificationExtension` in this example). Make sure the langage is
set to 'Swift'. If you're prompted to activate the
scheme, do so by hitting the big blue button. You'll now see a new target, repeat
the steps to add the app group; uing the same identifier you passed earlier
(`group.com.example.mmmpushnotificationstore`).

Ready to install the pod! In your iOS folder there is a `Podfile`, open it, it
should already contain a target, we'll add another.

```
# Existinig target:
target 'MmmPushNotificationStoreExample' do
  .... etc etc
end

# We add a new target for the newly created notfication extension
target 'MyNotificationExtension' do
  pod 'MMMPushNotificationExtension', :git => 'https://github.com/mediamonks/MMMPushNotificationStore.git'
end
```

Now run either `pod install` inside the `ios` folder (the one containing the `Podfile`)
or do your usual `yarn` to install.

Now inside your `NotificationService.swift` file, update all the content so it looks like:

```swift
import UserNotifications
import MMMPushNotificationExtension

class NotificationService: UNNotificationServiceExtension {

    override func didReceive(
      _ request: UNNotificationRequest,
      withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
    ) {
        ExtensionHandler.didReceive(
          request,
          contentHandler: contentHandler,
          groupIdentifier: "group.com.example.mmmpushnotificationstore"
        )
    }
}
```

The framework takes care of the rest.

### Retrieving all sent notifications

This part is way simpler, just import & call `loadNotifications` using the
identifier we used before.

```js
import { loadNotifications } from "mmm-push-notification-store";

// ...

const result = await loadNotifications("group.com.example.mmmpushnotificationstore");
```

The result will be an array of `Notification` objects, these are currently passed
as POJsO - Plain Old JavaScript Objects ;).

```js

// Notification
{
    title: String
	subtitle: String
	body: String
    badge: Number|null
	categoryIdentifier: String
	launchImageName: String
	threadIdentifier: String
	attachments: [
        {
            identifier: String
            url: String
            type: String
        }
	],
	userInfo: [String: Any]
	receivedAt: Date,

    // Only on iOS 12+
    summaryArgument: String,
    summaryArgumentCount: Number,

    // Only on iOS 13+
    targetContentIdentifier: String,

    // Only on iOS 15+
    interruptionLevel: Number,
    relevanceScore: Number
}

```

For more info on some of the values, you can have a look at [Apple's documentation](https://developer.apple.com/documentation/usernotifications/unnotificationcontent).

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
