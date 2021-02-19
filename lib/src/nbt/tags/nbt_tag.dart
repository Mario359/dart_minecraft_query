import 'package:dart_minecraft/src/nbt/nbt_file_writer.dart';

import '../nbt_file_reader.dart';
import '../nbt_tags.dart';
import 'nbt_byte.dart';
import 'nbt_byte_array.dart';
import 'nbt_compound.dart';
import 'nbt_double.dart';
import 'nbt_end.dart';
import 'nbt_float.dart';
import 'nbt_int.dart';
import 'nbt_int_array.dart';
import 'nbt_list.dart';
import 'nbt_long.dart';
import 'nbt_long_array.dart';
import 'nbt_short.dart';
import 'nbt_string.dart';

/// Represents the base of any NBT Tag.
abstract class NbtTag {
  /// This tags type.
  NbtTagType _nbtTagType;

  /// The parent of this tag. Can only be null for the root
  /// NbtCompound.
  NbtTag parent;

  /// The name of this tag. Inside of Lists or Arrays, this
  /// is 'None'.
  String name;

  /// The value of this tag. Can vary depending on tag type,
  /// obtainable from [nbtTagType].
  dynamic get value;

  /// The type of this tag.
  NbtTagType get nbtTagType => _nbtTagType;

  /// If this tag directly has a value.
  bool get hasValue {
    switch (nbtTagType) {
      case NbtTagType.TAG_END:
      case NbtTagType.TAG_COMPOUND:
      case NbtTagType.TAG_LIST:
        return false;
      default: 
        return true;
    }
  }

  /// If the tag is a List and has a length
  bool get hasLength {
    switch (nbtTagType) {
      case NbtTagType.TAG_LIST:
      case NbtTagType.TAG_BYTE_ARRAY:
      case NbtTagType.TAG_INT_ARRAY:
      case NbtTagType.TAG_LONG_ARRAY:
        return true;
      default:
        return false;
    }
  }

  /// Basic empty constructor
  NbtTag();

  /// Create a basic [NbtTag] with given [parent] and [nbtTagType]. This shouldn't be used
  /// and please refer to implementations for all other nbt tags.
  NbtTag.value(this.parent, this._nbtTagType);

  /// Reads a [NbtTag] from [fileReader].
  /// If the parent is a [NbtList] or [NbtArray], [withName] should be set to false to avoid reading
  /// the name of this Tag.
  NbtTag readTag(NbtFileReader fileReader, {bool withName = true});

  /// Reads the next byte from the file and returns the parsed [NbtTag] corresponding to the
  /// read tag type.
  static NbtTag readNewTag(NbtFileReader fileReader, NbtTag parent, {bool withName = true}) {
    final tagType = fileReader.readByte();
    return readTagForType(fileReader, tagType, parent, withName: withName);
  }

  /// Reads the Tag with type [tagType].
  /// If inside a [NbtList] or [NbtArray], [withName] should be set to false to avoid reading
  /// the name of this Tag.
  static NbtTag readTagForType(NbtFileReader fileReader, int tagType, NbtTag parent, {bool withName = true}) {
    switch (tagType) {
      case 0x00: return NbtEnd(parent);
      case 0x01: return NbtByte(parent).readTag(fileReader, withName: withName);
      case 0x02: return NbtShort(parent).readTag(fileReader, withName: withName);
      case 0x03: return NbtInt(parent).readTag(fileReader, withName: withName);
      case 0x04: return NbtLong(parent).readTag(fileReader, withName: withName);
      case 0x05: return NbtFloat(parent).readTag(fileReader, withName: withName);
      case 0x06: return NbtDouble(parent).readTag(fileReader, withName: withName);
      case 0x07: return NbtByteArray(parent).readTag(fileReader, withName: withName);
      case 0x08: return NbtString(parent).readTag(fileReader, withName: withName);
      case 0x09: return NbtList(parent).readTag(fileReader, withName: withName);
      case 0x0A: return NbtCompound(parent).readTag(fileReader, withName: withName);
      case 0x0B: return NbtIntArray(parent).readTag(fileReader, withName: withName);
      case 0x0C: return NbtLongArray(parent).readTag(fileReader, withName: withName);
      default: return null;
    }
  }

  /// Writes a [NbtTag] from [fileReader].
  /// If the parent is a [NbtList] or [NbtArray], [withName] should be set to false to avoid writing
  /// any names of this Tag.
  void writeTag(NbtFileWriter fileWriter, {bool withName = true, bool withType = true});

  @override
  String toString() {
    return '${nbtTagType.asString()}($name): $value';
  }
}
