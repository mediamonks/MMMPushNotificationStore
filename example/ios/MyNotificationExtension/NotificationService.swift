//
// MmmPushNotificationStoreExample.
// Copyright (C) 2022 MediaMonks. All rights reserved.
//

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
