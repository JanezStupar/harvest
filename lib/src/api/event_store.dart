// Copyright (c) 2013, the project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed 
// by a Apache license that can be found in the LICENSE file.

part of harvest_api;

abstract class EventStore {
  /** Open an [EventStream] for [id], fails if the stored events does not match [expectedVersion]*/
  Future<EventStream> openStream(Guid id, [int expectedVersion = -1]);
}

/** Track a series of events and commit them to durable storage */
abstract class EventStream {
  Guid get id;

  /// List of events persisted in the event store 
  Iterable<DomainEvent> get committedEvents;

  /// List of events that are not persisted in the event store 
  Iterable<DomainEvent> get uncommittedEvents;
  
  /// true if uncommited events exists
  bool get hasUncommittedChanges;

  /// Commits uncommitted events
  commitChanges();

  /// Clears the uncommitted changes.
  clearChanges();
  
  addAll(Iterable<DomainEvent> events);
  
  add(DomainEvent event);
  
  /// the version of the last event stored in the stream
  int streamVersion;
}

/** Optimistic concurrency conflict between multiple writers. */
class ConcurrencyError implements Exception {
  ConcurrencyError(this.message);

  String toString() => message;
  
  final String message;
}