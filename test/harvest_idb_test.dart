// Copyright (c) 2013, the Harvest project authors. Please see the AUTHORS
// file for details. All rights reserved. Use of this source code is governed
// by a Apache license that can be found in the LICENSE file.

import 'package:harvest/harvest_idb.dart';
@TestOn("browser")
import 'package:test/test.dart';

import 'src/harvest_test_helpers.dart';
import 'harvest_idb_test.mapper.g.dart' show initializeJsonMapper;

/** Test IndexedDB backed stores and repositories in Harvest */
main() async {
  initializeJsonMapper();
  group('IdbEventStore test', () {
    var eventStore = new IdbEventStore("idb_test");
    new EventStoreTester(eventStore);
  });

  group('IdbEventStore CQRS test', () {
    var eventStore = new IdbEventStore("idb_test2");
    new CqrsTester(new MessageBus(), eventStore);
  });
}
