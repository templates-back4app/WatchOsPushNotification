# WatchOsPushNotification
A sample application to receive Push Notifications on WatchOS devices (Apple Watch) using the ParseSwift SDK

# Don't forget to get:
- Your App's Bundle ID (case sensitive, from XCode)
- Your Team ID (from https://developer.apple.com on the top right section, under your username, a 10 characters String)
- Your Key ID (From your certificate download page or from the name of the downloaded file such as: AuthKey_ABCDEFGHIJ.p8 , where ABCDEFGHIJ is the Key ID)
- Upload your certificate as Development

# Here's how to test it:
- Send a message from the Dashboard -> More -> Push
- Send a message from code:

```
Parse.Push.send(
    {
      where: {},
      data: {
        alert: "GCM",
        badge: 123,
        title: 'Test title'
      }
    },
    { useMasterKey: true },
  );
```
