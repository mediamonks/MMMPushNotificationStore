import * as React from 'react';

import { StyleSheet, View, Text } from 'react-native';
import { loadNotifications } from 'mmm-push-notification-store';

export default function App() {
  const [result, setResult] = React.useState<string | undefined>();

  React.useEffect(() => {
    loadNotifications('group.com.example.mmmpushnotificationstore')
        .then((result) => {
            console.log('Notifications: ', result)
            setResult(JSON.stringify(result))
        })
        .catch((error) => {
            console.log('Notifications error: ', error)
            setResult(JSON.stringify(error))
        })
  }, []);

  return (
    <View style={styles.container}>
      <Text>Result: {result}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
