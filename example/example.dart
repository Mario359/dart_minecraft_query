import 'package:dart_minecraft/dart_minecraft.dart';
import 'package:dart_minecraft/src/packet/packets/response_packet.dart';

Future<void> main() async {
  /// Pinging hypixel.net to get the status of the server.
  /// This will return a [ResponsePacket] object which contains
  /// all the information about the server.
  ResponsePacket? pingHypixel;
  try {
    pingHypixel = await ping('mc.hypixel.net', port: 25565);
  } on PingException catch (error) {
    /// If the ping failed, we'll print the error message.
    /// Hypixel may be down for maintenances or rebooting.
    print('Failed to ping hypixel.net: ${error.message}');
  }

  /// If the ping was successful, we'll print the the server informations.
  if (pingHypixel != null || pingHypixel!.response != null) {
    /// MOTD is the message that is displayed when register the server
    /// in your multiplayer menu.
    /// It includes the two lines of text
    /// It includes color codes, which are represented by the §x symbol.
    /// You may need to replace the color codes symbol with Regex
    print('Hypixel MOTD:\n${pingHypixel.response!.description.description}');

    /// Player sample is a small list of players that are currently online.
    /// It is the component that displays when you hover over the
    /// ping status in the multiplayer menu.
    /// Hypixel doesn't show the player sample, it will be empty.
    /// Some servers manipulate the player sample to display other data,
    /// so it is not a good way to show some players that are online.
    print(
        'Hypixel Player Sample: ${pingHypixel.response!.players.sample} (empty because Hypixel doesn\'t show the player sample)');

    /// Server version is the version of the server that is displayed next
    /// to the ping status in the multiplayer menu.
    /// It can also be manipulated by a Minecraft plugin.
    /// Hypixel is running on 1.8 to newest version.
    ///
    /// Protocol version is a number that represents the version.
    /// You can find the list of protocol versions here:
    /// https://wiki.vg/Protocol_version_numbers
    print(
        'Hypixel Version: ${pingHypixel.response!.version.name}, Protocol: ${pingHypixel.response!.version.protocol}');

    /// The server count is the amount of players that are currently online
    /// and slots available.
    print(
        'Hypixel Server Count: ${pingHypixel.response!.players.online}/${pingHypixel.response!.players.max}');
  }
}
