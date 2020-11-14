// Copyright (c) 2013, the Harvest project authors. Please see the AUTHORS
// file for details. All rights reserved. Use of this source code is governed
// by a Apache license that can be found in the LICENSE file.

/** Harvest event store and CQRS API */
library harvest;

import 'dart:async';
import 'dart:collection';

// JSON mapper
import 'package:dart_json_mapper/dart_json_mapper.dart' show Json, jsonProperty, jsonSerializable;
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

// CQRS API
part 'src/cqrs/aggregate_root.dart';

part 'src/cqrs/commands.dart';

part 'src/cqrs/domain_repository.dart';

part 'src/cqrs/model_repository.dart';

part 'src/event_store.dart';

// even stores
part 'src/event_stores/memory_event_store.dart';

// Core message/event API
part 'src/events.dart';

part 'src/guid.dart';

part 'src/message.dart';

part 'src/message_bus.dart';

// repositories
part 'src/model_repositories/memory_model_repository.dart';

// process support
part 'src/process/process.dart';

part 'src/process/process_manager.dart';

part 'src/process/process_prototype.dart';

part 'src/process/step.dart';

part 'src/process/work_item.dart';

part 'src/process/work_log.dart';

// Global Helper functions
String typeNameOf(Object obj) => obj.runtimeType.toString();
