// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:built_collection/built_collection.dart';
import 'package:built_json/built_json.dart';

class BuiltMapSerializer implements StructuredSerializer<BuiltMap> {
  final bool structured = true;
  final Iterable<Type> types = new BuiltList<Type>([BuiltMap]);
  final String wireName = 'map';

  @override
  Iterable serialize(Serializers serializers, BuiltMap builtMap,
      {FullType specifiedType: FullType.unspecified}) {
    final isUnderspecified =
        specifiedType.isUnspecified || specifiedType.parameters.isEmpty;

    final keyType = specifiedType.parameters.isEmpty
        ? FullType.unspecified
        : specifiedType.parameters[0];
    final valueType = specifiedType.parameters.isEmpty
        ? FullType.unspecified
        : specifiedType.parameters[1];

    if (!isUnderspecified && !serializers.hasBuilder(specifiedType)) {
      throw new StateError('No builder for $specifiedType, cannot serialize.');
    }

    final result = <Object>[];
    for (final key in builtMap.keys) {
      result.add(serializers.serialize(key, specifiedType: keyType));
      final value = builtMap[key];
      result.add(serializers.serialize(value, specifiedType: valueType));
    }
    return result;
  }

  @override
  BuiltMap deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType: FullType.unspecified}) {
    final isUnderspecified =
        specifiedType.isUnspecified || specifiedType.parameters.isEmpty;

    final keyType = specifiedType.parameters.isEmpty
        ? FullType.unspecified
        : specifiedType.parameters[0];
    final valueType = specifiedType.parameters.isEmpty
        ? FullType.unspecified
        : specifiedType.parameters[1];

    MapBuilder result = isUnderspecified
        ? new MapBuilder<Object, Object>()
        : serializers.newBuilder(specifiedType) as MapBuilder;
    if (result == null) {
      throw new StateError(
          'No builder for $specifiedType, cannot deserialize.');
    }

    if (serialized.length % 2 == 1) {
      throw new ArgumentError('odd length');
    }

    for (int i = 0; i != serialized.length; i += 2) {
      final key = serializers.deserialize(serialized.elementAt(i),
          specifiedType: keyType);
      final value = serializers.deserialize(serialized.elementAt(i + 1),
          specifiedType: valueType);
      result[key] = value;
    }

    return result.build();
  }
}
