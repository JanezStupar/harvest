// Copyright (c) 2013 Solvr, Inc. All rights reserved.
//
// This open source software is governed by the license terms 
// specified in the LICENSE file

part of dart_store;

/**
 * Memory backed model repository
 */
class MemoryModelRepository<T extends IdModel> implements ModelRepository<T> {
  static Map<String, MemoryModelRepository> _cache;
  
  /**
   * Type is the class name of T and is used to ensure that only one repository exists for each T
   *
   * TODO remove this argument once you can use reflection to get the same info
   */
  factory MemoryModelRepository(String type) {
    if(_cache == null) {
      _cache = new Map<String, MemoryModelRepository>();
    }
    if(!_cache.containsKey(type)) {
      _cache[type] = new MemoryModelRepository._internal(type);
    }
    return _cache[type];
  }
  
  MemoryModelRepository._internal(String type)
    : _logger = LoggerFactory.getLogger("dartstre.${type}ModelRepository"),
      _store = new Map<Uuid, T>(),
      _type = type;
  
  List<T> get all => new List.from(_store.values);    
  
  T getById(Uuid id) => _store[id];

  T getOrNew(T builder()) {
    List list = all;
    if(list.isEmpty) {
      var instance = builder();
      save(instance);
      return instance;
    } else if(list.length == 1) {
      return list[0];
    } else {
      throw new StateError("more than one existing instance of ${_type} exists");
    }
  }
      
  remove(T instance) => _store.remove(instance.id);
  
  removeById(Uuid id) => _store.remove(id);
  
  save(T instance) => _store[instance.id] = instance;
  
  final Map<Uuid,T> _store;
  final Logger _logger;
  final String _type;
}


