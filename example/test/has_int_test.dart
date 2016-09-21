// Copyright (c) 2016, Google Inc. Please see the AUTHORS file for details.

// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:built_collection/built_collection.dart';
import 'package:example/has_int.dart';
import 'package:example/serializers.dart';
import 'package:test/test.dart';
import 'package:example/value.dart';

void main() {
  group('HasInt', () {
    final data = new BuiltList<HasInt>([
      new ValueWithInt((b) => b
        ..anInt = 2
        ..note = 'two'),
      EnumWithInt.one,
      new Value((ValueBuilder b) => b
        ..anInt = 3
        ..aString = 'four'),
    ]);
    final serialized = [
      'list',
      ['ValueWithInt', 'anInt', 2, 'note', 'two'],
      ['EnumWithInt', 'one'],
      ['Value', 'anInt', 3, 'aString', 'four', 'listOfInt', []
      ],
    ];

    test('can be serialized', () {
      expect(serializers.serialize(data), serialized);
    });

    test('can be deserialized', () {
      expect(serializers.deserialize(serialized), data);
    });
  });
}
