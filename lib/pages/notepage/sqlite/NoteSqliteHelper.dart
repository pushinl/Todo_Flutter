import 'package:todo_flutter/bean/note_bean_entity.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String tableNote = 'note';
final String columnId = 'note_id';
final String columnTitle = 'title';
final String columnContent = "content";
final String columnAddTime = "add_time";
final String columnUpdateTime = "update_time";
final String columnNoteCode = "note_code";

///因为增删改查都是异步的原因，所以在执行操作前先确认db是否未空，否则会报错
class NoteSqliteHelper {
  Database noteDb;
  Batch batch;

  Future open() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'note.db');
    noteDb = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          "create table IF NOT EXISTS $tableNote($columnId INTEGER PRIMARY KEY AUTOINCREMENT ,$columnTitle varchar(20)" +
              ",$columnContent TEXT,$columnAddTime DATETIME,$columnUpdateTime DATETIME,$columnNoteCode TEXT)");
    });
  }

  Future<NoteBeanEntity> insert(NoteBeanEntity noteBeanEntity) async {
    Map map = noteBeanEntity.toJson();
    noteBeanEntity.noteId = await noteDb.insert(tableNote, map);
    return noteBeanEntity;
  }

  Future<NoteBeanEntity> getNote(int id) async {
    List<Map> maps = await noteDb.query(tableNote,
        columns: [
          columnId,
          columnTitle,
          columnContent,
          columnAddTime,
          columnUpdateTime,
          columnNoteCode
        ],
        where: "$columnId=?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return NoteBeanEntity().fromJson(maps.first);
    }
    return null;
  }

  /**
   * @param type 1 按编辑日期 2 按创建日期 3 按标题
   */
  Future<List<NoteBeanEntity>> getAllNote(int type) async {
    List<NoteBeanEntity> list = [];
    List<Map> maps;
    switch (type) {
      case 2:
        maps = await noteDb.query(tableNote, orderBy: "$columnUpdateTime DESC");
        break;
      case 1:
        maps = await noteDb.query(tableNote, orderBy: "$columnAddTime DESC");
        break;
      case 3:
        maps = await noteDb.query(tableNote, orderBy: "$columnTitle ASC");
        break;
    }
    maps.map((e) {
      list.add(NoteBeanEntity().fromJson(e));
    }).toList();
    return list;
  }

  Future<List<NoteBeanEntity>> searchNote(String keyWord, int type) async {
    List<NoteBeanEntity> list = [];
    var where =
        "$columnTitle like '%$keyWord%' or $columnContent like '%$keyWord%'";
    List<Map> maps;
    switch (type) {
      case 2:
        maps = await noteDb.query(tableNote,
            where: where, orderBy: "$columnUpdateTime desc");
        break;
      case 1:
        maps = await noteDb.query(tableNote,
            where: where, orderBy: "$columnAddTime desc");
        break;
      case 3:
        maps = await noteDb.query(tableNote,
            where: where, orderBy: "$columnTitle asc");
        break;
    }
    maps.map((e) {
      list.add(NoteBeanEntity().fromJson(e));
    }).toList();
    return list;
  }

  Future<int> delete(int id) async {
    return await noteDb.delete(tableNote, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteAll() async {
    return await noteDb.delete(tableNote);
  }

  Future<int> update(NoteBeanEntity note) async {
    return await noteDb.update(tableNote, note.toJson(),
        where: '$columnId = ?', whereArgs: [note.noteId]);
  }

  Future batchOperate() async {
    batch = noteDb.batch();
    batch.delete(tableNote, where: "$columnTitle=?", whereArgs: ["0"]);
    batch.update(tableNote, {"$columnTitle": 'flutter'},
        where: '$columnTitle = ?', whereArgs: ["3"]);
    List list = await batch.commit();
  }

  Future close() async => noteDb.close();
}
