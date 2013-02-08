// Copyright (c) 2013 Solvr, Inc. All rights reserved.
//
// This open source software is governed by the license terms 
// specified in the LICENSE file

part of dart_store;

/**
 * Repository that stores and retrieves domain objects (aggregates) by their events
 */
abstract class DomainRepository<T extends AggregateRoot>  {
  DomainRepository(String type, this._builder, this._store)
    : _logger = LoggerFactory.getLogger("dartstore.${type}DomainRepository");
  
  /**
   * Save aggregate, return [true] when the aggregate had unsaved data otherwise [false].
   */ 
  Future<bool> save(AggregateRoot aggregate, [int expectedVersion = -1]) {
    var completer = new Completer<bool>();
    if(aggregate.hasUncommittedChanges) {
      _logger.debug("saving aggregate ${aggregate.id} with ${aggregate.uncommittedChanges.length} new events");
      _store.saveEvents(aggregate.id, aggregate.uncommittedChanges, expectedVersion).then((r) {
        aggregate.markChangesAsCommitted();
        completer.complete(true);
      });
    } else {
      completer.complete(false);
    }
    return completer.future;
  }

  /**
   * Load aggregate by its id
   */ 
  Future<T> load(Uuid id) {
    var completer = new Completer<T>();
    _store.getEventsForAggregate(id).then((List<DomainEvent> events) {
      var obj = _builder(id);
      _logger.debug("loading aggregate ${id} from ${events.length} total events");
      obj.loadFromHistory(events);
      completer.complete(obj);
    });
    return completer.future;
  }
  
  final Logger _logger;
  final AggregateBuilder _builder;
  final EventStore _store;
}
