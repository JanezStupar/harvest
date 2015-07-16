// Copyright (c) 2013-2015, the Harvest project authors. Please see the AUTHORS 
// file for details. All rights reserved. Use of this source code is governed 
// by a Apache license that can be found in the LICENSE file.

part of harvest;

/**
 * Wrap external Uuid library into own class, until Dart provides its own official implementation
 */
class Guid {
  factory Guid() {
    var val = _valueFactory.v1();
    return new Guid._internal(val);
  }
  
  Guid._internal(this.value); 
  
  int get hashCode => value.hashCode;
  
  String toString() => value;
  
  final String value;
  static final _valueFactory = new Uuid();
}
