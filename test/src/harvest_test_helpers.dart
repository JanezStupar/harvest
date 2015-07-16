// Copyright (c) 2013-2015, the Harvest project authors. Please see the AUTHORS 
// file for details. All rights reserved. Use of this source code is governed 
// by a Apache license that can be found in the LICENSE file.

library harvest_test_helpers;

import 'package:harvest/harvest.dart';
import 'package:harvest/harvest_sample.dart';
import 'package:test/test.dart';

part 'eventstore_tester.dart';
part 'cqrs_tester.dart';

/**
 * Helper class that retrieves the entire current view state. Useful for comparing 
 * view state as events are fired/replayed. 
 */
class ViewModelState {
  final List<ItemEntry> itemEntryList;
  final List<ItemDetails> itemDetailsList;
  
  factory ViewModelState(InventoryPresenter presenter, InventoryViewMock view) {
    // get inventory list state
    presenter.showItems();
    var itemList = view.displayedItems;
    
    // save details for each item in the list
    var itemDetailsList = new List<ItemDetails>();
    itemList.forEach((var item) {
      presenter.showItemDetails(item.id);
      itemDetailsList.add(view.displayedDetails);
    });
    return new ViewModelState._internal(itemList, itemDetailsList);
  }
  
  ViewModelState._internal(this.itemEntryList, this.itemDetailsList);
}

/** Mock implementation of [InventoryView] that does not depend on dart:html */
class InventoryViewMock implements InventoryView {
  // testing data
  List<ItemEntry> displayedItems;
  ItemDetails displayedDetails;
  List<String> recordedMessages = [];
  
  set presenter(InventoryPresenter p) {
  }
  
  showItems(List<ItemEntry> items) {
    displayedItems = items;
  }
  
  showDetails(ItemDetails details) {
    displayedDetails = details;
  }
  
  recordMessage(String messageType, String messageName, DateTime time) {
    recordedMessages.add(messageName);
  }
}

/** Assert that event are in correct order */
assertEvents(List<String> actualEvents, List<DomainEvent> expectedEvents) {
  assertEventNames(actualEvents, expectedEvents.map(typeNameOf).toList());
}

assertEventNames(List<String> actualEvents, List<String> expectedEvents) {
  expect(actualEvents, orderedEquals(expectedEvents));
}
