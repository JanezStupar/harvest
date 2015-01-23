// Copyright (c) 2013-2015, the Harvest project authors. Please see the AUTHORS 
// file for details. All rights reserved. Use of this source code is governed 
// by a Apache license that can be found in the LICENSE file.

library harvest_test;

import 'package:unittest/unittest.dart';
// import application in the same way to avoid library clashes 
import '../lib/harvest_file.dart';
import '../example/web/app/lib.dart';

part 'src/helpers.dart';

main() {
  // test memory based event store
  var memoryEventStore = new MemoryEventStore();
  new CqrsTester(new MessageBus(), memoryEventStore);
     
  // test file based event store
  var fileEventStore = new FileEventStore("/tmp/harvest");
  new CqrsTester(new MessageBus(), fileEventStore);
}

class CqrsTester {
  CqrsTester(this._messageBus, this._eventStore) {
    _init();
    _testExecutingEvents();
    // TODO _testReloadingEvents();
  }
  
  _init() {
    // create repository for domain models and set up command handler 
    var itemRepo = new DomainRepository<Item>((Guid id) => new Item(id), _eventStore, _messageBus);
    var commandHandler = new InventoryCommandHandler(_messageBus, itemRepo);
    
    // create respositories for view models and set up event handler
    var itemEntryRepo = new MemoryModelRepository<ItemEntry>();
    var itemDetailsRepo = new MemoryModelRepository<ItemDetails>();
    var eventHandler = new InventoryEventHandler(_messageBus, itemEntryRepo, itemDetailsRepo);
    
    // wire up frontend
    _view = new InventoryViewMock();
    var viewModelFacade = new ViewModelFacade(itemEntryRepo, itemDetailsRepo);
    _presenter = new InventoryPresenter(_messageBus, _view, viewModelFacade);
  }
  
  // test that executing events causes app to behave as expected  
  _testExecutingEvents() {
    // record all events
    var events = new List<DomainEvent>();
    _messageBus.everyMessage.listen((Message message) {
      if(message is DomainEvent) {
        events.add(message);
      }
    }); 
    
    group("executing events -", () {
      String item1Name = "Book 1";
      var item1Id, item1Version;
      
      test("creating item and display it", () {
        _presenter.createItem(item1Name).then(expectAsync((res) {
          expect(_view.displayedItems.length, equals(1));
          assertEvents(expectedEvents..add("ItemCreated"), events); 
          
          item1Id = _view.displayedItems[0].id;
          expect(item1Id, isNotNull);
        }));
      });
      
      test("show details for item 1", () {
        _presenter.showItemDetails(item1Id);
        expect(item1Id, equals(_view.displayedDetails.id));
        expect(item1Name, equals(_view.displayedDetails.name));
        
        item1Version = _view.displayedDetails.version;
        expect(item1Version, equals(0), reason:"initial version should be zero");
      });
      
      test("increase invetory of item 1", () {
        _presenter.increaseInventory(item1Id, 2, item1Version).then(expectAsync((res) {
          expect(_view.displayedDetails.currentCount, equals(2));
          assertEvents(expectedEvents..add("InventoryIncreased"), events);   
          
          expect(_view.displayedDetails.version, isNot(equals(item1Version)), reason: "version should be bumped");
          item1Version = _view.displayedDetails.version;
        }));
      });
      
      test("rename item 1", () {
        item1Name = "$item1Name v2";
        _presenter.renameItem(item1Id, item1Name, item1Version).then(expectAsync((res) {
          expect(item1Name, equals(_view.displayedDetails.name));
          assertEvents(expectedEvents..add("ItemRenamed"), events);
          
          expect(_view.displayedDetails.version, isNot(equals(item1Version)), reason: "version should be bumped");
          item1Version = _view.displayedDetails.version;
        }));
      });
      
      test("decrease invetory of item 1", () {
        _presenter.decreaseInventory(item1Id, 1, item1Version).then(expectAsync((res) {
          expect(_view.displayedDetails.currentCount, equals(1));
          assertEvents(expectedEvents..add("InventoryDecreased"), events);   
          
          expect(_view.displayedDetails.version, isNot(equals(item1Version)), reason: "version should be bumped");
          item1Version = _view.displayedDetails.version;
        }));
      });
      
      // 2: create item 2
      
      // 2: check items 2 in
      
      // 2: deactivate item 1
    });
  }
  
  // test that reloading all recorded events gives same results as recieving them one by one
  _testReloadingEvents() {
    group("reloading events -", () {
      // save current view state
      var origState = new ViewModelState(_presenter, _view);
      
      // reload the application (causes replay of the recorded events)
      _init();
      
      // compare state after replay
      var replayedState = new ViewModelState(_presenter, _view);
      assertEqualState(origState, replayedState);
    });
  }
  
  InventoryPresenter _presenter;
  InventoryViewMock _view;
  final EventStore _eventStore;
  final MessageBus _messageBus;
  final expectedEvents = new List<String>();
}
