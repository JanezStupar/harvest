// Copyright (c) 2013-2015, the Harvest project authors. Please see the AUTHORS 
// file for details. All rights reserved. Use of this source code is governed 
// by a Apache license that can be found in the LICENSE file.

part of harvest;

/** 
 * Log of the work executed by a step
 */
class WorkLog<T extends Step> {
  final UnmodifiableMapView<String, Object> _headers;  
  T step;
  
  WorkLog(this.step, Map<String, Object> headers): _headers = new UnmodifiableMapView(headers);
  
  /**
   * True if worklog contains values for [key]
   */
  bool containsKey(String key) => _headers.containsKey(key);
  
  /**
   * Look up entry in work log
   */
  Object operator [](String key) {
    if(!containsKey(key)) {
      throw new ArgumentError("no log entry for $key in step ${step.runtimeType}");
    }
    return _headers[key];
  }
}