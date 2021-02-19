import 'package:dart_minecraft/src/nbt/nbt_file_writer.dart';

import '../nbt_file_reader.dart';
import '../nbt_tags.dart';
import 'nbt_tag.dart';

/// Represents a 8 byte long integer in a NBT file.
class NbtLong extends NbtTag {
  int _value;

  @override
  int get value => _value;

  /// Creates a [NbtLong] with given [parent].
  NbtLong(NbtTag parent) : super.value(parent, NbtTagType.TAG_LONG);

  @override
  NbtLong readTag(NbtFileReader fileReader, {bool withName = true}) {
    final name = withName ? fileReader.readString() : 'None';
    final value = fileReader.readLong();
    return this..name = name.._value = value;
  }

  @override
  void writeTag(NbtFileWriter fileWriter, {bool withName = true, bool withType = true}) {
    if (withType) fileWriter.writeByte(nbtTagType.index);
    if (withName) {
      fileWriter.writeString(name);
    }
    fileWriter.writeLong(_value);
  }
}
