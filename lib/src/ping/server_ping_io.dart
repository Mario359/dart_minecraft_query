import 'dart:io' as dart_io;
import 'dart:typed_data';

import '../packet/packet_reader.dart';
import '../packet/packet_writer.dart';
import '../packet/packets/handshake_packet.dart';
import '../packet/packets/ping_packet.dart';
import '../packet/packets/pong_packet.dart';
import '../packet/packets/request_packet.dart';
import '../packet/packets/response_packet.dart';
import '../packet/packets/server_packet.dart';

//TODO: Switch to socket_io_client for web support
/// Write a single package
void _writePacket(dart_io.Socket socket, ServerPacket packet) async {
  final packetEncoded = PacketWriter.create().writePacket(packet);
  socket.add(packetEncoded);
}

int _now() => DateTime.now().millisecondsSinceEpoch;

Future<ResponsePacket?> pingUri(String serverUri) async {
  final split = serverUri.split(':');
  if (split.length == 2) {
    return ping(split[0], port: int.parse(split[1]));
  } else {
    return ping(split[0]);
  }
}

/// Ping a single server. [port] will default to 25565 as that is the
/// default Minecraft server port. This method is for post 1.6 servers.
Future<ResponsePacket?> ping(String serverUri,
    {int port = 25565, Duration timeout = const Duration(seconds: 30)}) async {
  // Register the packets we will require
  ServerPacket.registerClientboundPacket(ResponsePacket());
  ServerPacket.registerClientboundPacket(PongPacket());

  dart_io.Socket? socket2;
  Stream<Uint8List>? stream;

  try {
    socket2 = await dart_io.Socket.connect(serverUri, port, timeout: timeout);
    ;
    stream = socket2.asBroadcastStream();
  } catch (error) {
    print('Unable to connect to server: $error');
  }

  if (socket2 == null || stream == null) {
    await socket2?.close();
    return null;
  }

  _writePacket(socket2, HandshakePacket(serverAddress: serverUri));
  _writePacket(socket2, RequestPacket());

  final responsePacket =
      await PacketReader.readPacketFromStream(stream) as ResponsePacket;

  final pingPacket = PingPacket(_now());
  _writePacket(socket2, pingPacket);
  final pongPacket =
      await PacketReader.readPacketFromStream(stream) as PongPacket;

  await socket2.close();
  var ping = pongPacket.value! - pingPacket.value;

  /// If the ping is 0, we'll instead use the time it took
  /// for the server to respond and the packet returning back home.
  if (ping <= 0) {
    ping = _now() - pingPacket.value;
  }
  return responsePacket..ping = ping;
}
