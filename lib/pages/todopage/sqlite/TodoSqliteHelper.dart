import 'package:todo_flutter/bean/todo_bean_entity.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String tableTodo = 'todo';
final String columnId = 'todo_id';
final String columnContent = 'content';
final String columnDateTime = 'item_datetime';
final String columnStatus = 'item_status';
final String columnTypeDdlOrRepeat = 'item_type_ddl_or_repeat';
final String columnTypePersonOrTeam = "item_type_person_or_team";
final String columnLabels = 'item_labels';
final String columnImportance = 'item_importance';

class TodoSqliteHelper {
  Database todoDb;
  Batch batch;

  Future open() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'todo.db');
    todoDb = await openDatabase(
        path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(
              'CREATE TABLE IF NOT EXISTS $tableTodo('
                  '$columnId INTEGER PRIMARY KEY AUTOINCREMENT,'
                  '$columnContent TEXT,'
                  '$columnDateTime TEXT,'
                  '$columnStatus INTEGER,'
                  '$columnTypeDdlOrRepeat INTEGER,'
                  '$columnTypePersonOrTeam INTEGER,'
                  '$columnImportance INTEGER,'
                  '$columnLabels TEXT)'
          );
        });
  }

  Future<TodoBeanEntity> insert(TodoBeanEntity todoBeanEntity) async {
    Map map = todoBeanEntity.toJson();
    todoBeanEntity.todoId = await todoDb.insert(tableTodo, map);
    return todoBeanEntity;
  }

  Future<TodoBeanEntity> getTodo(int id) async {
    List<Map> maps = await todoDb.query(tableTodo,
        columns: [
          columnId,
          columnContent,
          columnDateTime,
          columnTypeDdlOrRepeat,
          columnTypePersonOrTeam,
          columnStatus,
          columnLabels,
          columnImportance
        ],
        where: '$columnId=?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return TodoBeanEntity().fromJson(maps.first);
    }
    return null;
  }

  /// @param type 1 按重要程度 2 按ddl
Future<List<TodoBeanEntity>> getAllTodo(int type) async {
    List<TodoBeanEntity> list = [];
    List<Map> maps;
    switch (type) {
      case 1:
        maps = await todoDb.query(tableTodo, orderBy: '${columnImportance} DESC');
        break;
      case 2:
        maps = await todoDb.query(tableTodo, orderBy: '${columnDateTime} DESC');
        break;
      case 3:
        maps = await todoDb.query(tableTodo, orderBy: '$columnContent ASC');
        break;
    }
    maps.map((e) {
      list.add(TodoBeanEntity().fromJson(e));
    }).toList();
    return list;
  }

  Future<List<TodoBeanEntity>> searchTodo(String keyWord, int type) async {
    List<TodoBeanEntity> list = [];
    var where =
        "$columnContent like '%$keyWord%'";
    List<Map> maps;
    switch (type) {
      case 2:
        maps = await todoDb.query(tableTodo,
            where: where, orderBy: '$columnDateTime desc');
        break;
      case 1:
        maps = await todoDb.query(tableTodo,
            where: where, orderBy: '$columnImportance desc');
        break;
      case 3:
        maps = await todoDb.query(tableTodo,
            where: where, orderBy: '$columnContent ASC');
        break;
    }
    maps.map((e) {
      list.add(TodoBeanEntity().fromJson(e));
    }).toList();
    return list;
  }

  Future<int> delete(int id) async {
    return await todoDb.delete(tableTodo, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(TodoBeanEntity todo) async {
    return await todoDb.update(tableTodo, todo.toJson(),
        where: '$columnId = ?', whereArgs: [todo.todoId]);
  }

  Future batchOperate() async {
    batch = todoDb.batch();
    batch.delete(tableTodo, where: '$columnContent=?', whereArgs: ['0']);
    batch.update(tableTodo, {'$columnContent': 'flutter'},
        where: '$columnContent = ?', whereArgs: ['3']);
    List list = await batch.commit();
  }

  Future close() async => todoDb.close();
}
