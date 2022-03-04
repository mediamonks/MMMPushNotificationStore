@objc(MMMPushNotificationStore)
public final class MMMushNotificationStore: NSObject {
	
	public enum StoreError: Error {
		case invalidGroupIdentifier
		case invalidContent
	}
	
    @objc(loadNotifications:withResolver:withRejecter:)
    public func loadNotifications(
		groupIdentifier: String,
		resolve: RCTPromiseResolveBlock,
		reject: RCTPromiseRejectBlock
	) -> Void {
        
        guard let url = FileManager.default.containerURL(
			forSecurityApplicationGroupIdentifier: groupIdentifier
		) else {
			reject("1", "Invalid group identifier", StoreError.invalidGroupIdentifier)
			return
		}
		
		let path = url.appendingPathComponent("notifications").appendingPathExtension("json")
        
        do {
			let data = try Data(contentsOf: path)
			
			do {
				
				if case let notes as [[String: Any]] = try JSONSerialization.jsonObject(
					with: data,
					options: []
				) {
					resolve(notes)
				} else {
					reject("2", "Invalid content", StoreError.invalidContent)
				}
			} catch {
				reject("2", "Invalid content", StoreError.invalidContent)
			}
		} catch {
			resolve([])
		}
    }
}
