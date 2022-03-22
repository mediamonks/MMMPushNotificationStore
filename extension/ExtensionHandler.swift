import Foundation
import UserNotifications

public final class ExtensionHandler {
	
    public static func didReceive(
        _ request: UNNotificationRequest,
        contentHandler: @escaping (UNNotificationContent) -> Void,
        groupIdentifier: String
    ) {
        
        guard let url = FileManager.default.containerURL(
			forSecurityApplicationGroupIdentifier: groupIdentifier
		) else {
			contentHandler(request.content)
			return
		}
		
		let path = url.appendingPathComponent("notifications").appendingPathExtension("json")
        
        var notifications = [[String: Any]]()
        
        do {
			let data = try Data(contentsOf: path)
			
			if case let notes as [[String: Any]] = try JSONSerialization.jsonObject(
				with: data,
				options: []
			) {
				notifications = notes
			}
		} catch { }
		
		var data: [String: Any] = [
			"title": request.content.title,
			"subtitle": request.content.subtitle,
			"body": request.content.body,
			"categoryIdentifier": request.content.categoryIdentifier,
			"launchImageName": request.content.launchImageName,
			"threadIdentifier": request.content.threadIdentifier,
			"attachments": request.content.attachments.map {
				["url": $0.url, "identifier": $0.identifier, "type": $0.type]
			},
			"userInfo": request.content.userInfo,
            "receivedAt": Date().timeIntervalSince1970
		]
		
		if #available(iOSApplicationExtension 12.0, *) {
			data["summaryArgumentCount"] = request.content.summaryArgumentCount
			data["summaryArgument"] = request.content.summaryArgument
		}
		
		if let badge = request.content.badge {
			data["badge"] = badge
		}
		
		if #available(iOSApplicationExtension 15.0, *) {
			data["interruptionLevel"] = request.content.interruptionLevel.rawValue
			data["relevanceScore"] = request.content.relevanceScore
		}
		
		if #available(iOSApplicationExtension 13.0, *) {
			data["targetContentIdentifier"] = request.content.targetContentIdentifier
		}
		
		notifications.append(data)
        
        do {
			
			let data = try JSONSerialization.data(withJSONObject: notifications, options: [])
			
			try data.write(to: path)
		} catch {}
        
        contentHandler(request.content)
    }
}
