// Copyright (c) 2013 Solvr, Inc. All rights reserved.
//
// This open source software is governed by the license terms 
// specified in the LICENSE file

part of dart_store;

/**
 * The root of an object tree (aggregate). 
 */
abstract class AggregateRoot {
  AggregateRoot()
    : _changes = new List<DomainEvent>(),
      _entities = new List<EventSourcedEntity>(),
      _logger = LoggerFactory.getLogger("dartstore.AggregateRoot");
 
  int get version => _version;
  
  Uuid id;
  
  /**
   * Populate this aggregte root from historic events
   */
  loadFromHistory(List<DomainEvent> history) {
    history.forEach((DomainEvent e) {
      _logger.debug("loading historic event ${e.type} for aggregate ${id}");
      _applyChange(e, false);
    });
  }
  
  _applyChange(DomainEvent event, bool isNew) {
    this.apply(event);
    _entities.forEach((EventSourcedEntity entity) => entity.apply(event)); 
    if(isNew) {
      _logger.debug("applying change ${event.type} for ${id}");
      _changes.add(event);
    }
  }
  
  /**
   * Implemented in each concrete aggregate, responsible for extracting data from events and applying it itself
   */
  apply(DomainEvent event);

  /**
   * Apply a new event to this aggregate
   */
  applyChange(DomainEvent event) => _applyChange(event, true);
  
  /**
   * List of events applied to this aggregate that are not persisted in the event store
   */
  List<DomainEvent> get uncommittedChanges => _changes;
 
  bool get hasUncommittedChanges => _changes.length > 0;

    /**
   * Mark all events as persisted, usually called by event stores when events are saved
   */
  markChangesAsCommitted() => _changes.clear();
  
  /**
   * Add a non-root entity to participate in the event sourcing of this aggregate.
   * This entity will recieve all the events the root recieves and will store its
   * event in the root.
   */
  addEventSourcedEntity(EventSourcedEntity entity) {
    _entities.add(entity);
    entity.applyChange = this.applyChange;
  }
  
  operator ==(AggregateRoot other) => other.id == id; 
  
  String toString() => "aggregate $id";
  
  final List<EventSourcedEntity> _entities;
  final List<DomainEvent> _changes;
  final Logger _logger;
  int _version;
}
