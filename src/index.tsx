import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'mmm-push-notification-store' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

const MMMPushNotificationStore = NativeModules.MMMPushNotificationStore
  ? NativeModules.MMMPushNotificationStore
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export function loadNotifications(groupIdentifier: string): Promise<Array<Object>> {
  return MMMPushNotificationStore.loadNotifications(groupIdentifier);
}
