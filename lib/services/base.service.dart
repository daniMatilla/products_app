abstract class BaseService<T> {
  Future<List<T>> getAll();
  Future<T> getById(String id);
  Future<T?> update(T arg);
  Future<T?> create(T arg);
  Future<bool> delete(String id);
}
