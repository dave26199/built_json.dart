// Copyright (c) 2016, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:async';

import 'package:build/build.dart';
import 'package:built_json_generator/built_json_generator.dart';
import 'package:built_value_generator/built_value_generator.dart';
import 'package:enum_class_generator/enum_class_generator.dart';
import 'package:source_gen/source_gen.dart';

/// Start a watcher that automatically builds the generated files in the
/// built_json chat example on changes.
Future main(List<String> args) async {
  await watch(
      new PhaseGroup.singleAction(
          new GeneratorBuilder([
            new BuiltJsonGenerator(),
            new BuiltValueGenerator(),
            new EnumClassGenerator()
          ]),
          new InputSet('chat_example', const ['lib/**/*.dart'])),
      deleteFilesByDefault: true);
}
