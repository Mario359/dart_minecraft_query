# query_dart_minecraft

Dart library to retrieve informations from Minecraft servers.

## Pinging a server

Ping a Minecraft server to get its basic information, such as the latency, the number of players online, MOTD...
Example can be found in the [example folder](
    <https://github.com/Mario359/dart_minecraft_query/blob/main/example/example.dart>)

```dart
final ResponsePacket? server = ping('mc.hypixel.net', port: 25565);
```

## Pinging a server with query

WIP

## License

The MIT License, see [LICENSE](https://github.com/spnda/dart_minecraft/raw/main/LICENSE).
