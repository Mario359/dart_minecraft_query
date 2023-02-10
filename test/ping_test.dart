import 'package:dart_minecraft/dart_minecraft.dart';
import 'package:test/test.dart';

void main() {
  const uri = 'mc.hypixel.net';
  const brokenUri = '2b2t.org';

  test('Test if ping does not pick up server.', () async {
    final serverInfo = await ping(brokenUri);
    // Assuming that the server does not respond to pings
    expect(serverInfo, isNull);
  });

  test('Test if ping picks up server.', () async {
    final serverInfo = await ping(uri);
    expect(serverInfo, isNotNull);
    if (serverInfo!.response == null) return;

    print('Modt: ${serverInfo.response!.description.description}');
    expect(serverInfo.response!.description.description, isNotNull);
    // A bit hacky, cannot expect for the MODT to never change
    expect(serverInfo.response!.description.description, contains('Hypixel'));

    print('Players online on $uri:');
    print(
        '${serverInfo.response!.players.online} / ${serverInfo.response!.players.max}');
    print('Latency: ${serverInfo.ping}');
  });
}
