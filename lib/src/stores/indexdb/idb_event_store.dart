// Copyright (c) 2013, the project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed 
// by a Apache license that can be found in the LICENSE file.

part of harvest_indexeddb;

/**
 * IndexDB backed event store
 */
class IDBEventStore implements EventStore {
  // Chrome only for now, see bug http://code.google.com/p/chromium/issues/detail?id=108223
  // [String version = "1", String storeName = "event-store"]
  IDBEventStore(this._connection): _logger = LoggerFactory.getLoggerFor(IDBEventStore) {
    
  }
  
  void saveEvents(Uuid aggregateId, List<DomainEvent> events, int expectedVersion) {
    throw "TODO";
  }
  
  List<DomainEvent> getEventsForAggregate(Uuid aggregateId) {
    throw "TODO";
  }
  
  final IDBConnection _connection;
  final Logger _logger;
}



