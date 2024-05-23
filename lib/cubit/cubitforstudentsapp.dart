import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sqflite/sqflite.dart';
import 'package:untitled19/cubit/statesforstudentapp.dart';

import '../db/sqldatabase.dart';
import '../model/student.dart';

class CubitForStudentApp extends Cubit<StatesForStutentsApp> {
  CubitForStudentApp() : super(InitialStateForStutentsApp());

  Future<List<Student>> fetchingStudentsData() async {
    List<Student> allstudents = [];
    final database = await SqliteDatabase.sqlitedatabase();
    try {
      emit(StateReadyForFetchingStudentsData());
      final List<Map<String, dynamic>> maps = await database.query("students");

      for (int i = 0; i < maps.length; i++) {
        allstudents.add(Student(
            id: maps[i]['id'] as int,
            name: maps[i]['name'] as String,
            course: maps[i]['course'] as String));
      }
      emit(StateFetchingStudentsDataSuccessfully(students: allstudents));
    } catch (errorExp) {
      emit(StateFetchingStudentsDataUnsuccessfully(
          errorExp: errorExp.toString()));
    }
    return allstudents;
  }

  Future<void> insertStudent(Student student) async {
    final database = await SqliteDatabase.sqlitedatabase();
    try {
      emit(StateReadyForAddStudentsData());
      await database.insert("students", student.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      emit(StateAddingtudentsDataSuccessfully());
    } catch (errorExp) {
      emit(StateAddStudentDataUnsuccessfully(errorExp: errorExp.toString()));
    }
  }

  Future<void> addNewStudent() async {
    final database = await SqliteDatabase.sqlitedatabase();
    try {
      emit(StateReadyForAddStudentsData());
      Student student =Student(name:nameController.text,
      course: courseController.text);
      await database.insert("students", student.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      nameController.clear();
      courseController.clear();
      emit(StateAddingtudentsDataSuccessfully());
    } catch (errorExp) {
      emit(StateAddStudentDataUnsuccessfully(errorExp: errorExp.toString()));
    }
  }



Future<void> deleteStudent({required int id}) async{

  final database = await SqliteDatabase.sqlitedatabase();
  try{
    emit(StateReadyForDeleteStudentsData());
    await database.delete("students",where: 'id=?',whereArgs: [id]);
     emit(StateDeletingtudentsDataSuccessfully());
    }catch(errorExp){
    emit(StateDeleteStudentDataUnsuccessfully(errorExp: errorExp.toString()));
  }
}

  someStudentDate() {
    for (int i = 0; i < 1000; i++) {
      insertStudent(Student(name: "student$i", course: "SE3"));
    }
  }

  final nameController = TextEditingController();
  final courseController = TextEditingController();




changeControllers({required String name, required String course}){
    nameController.text=name;
    courseController.text =course;
}

Future<void> updateStudent({required int id}) async{
  final database=await SqliteDatabase.sqlitedatabase();
  try{
    emit(StateReadyForEditStudentsData());
    Student student =Student(id:id,
        name: nameController.text, course: courseController.text);
    database.update("students", student.toMap(),
        where: 'id = ?',whereArgs: [id]);
    nameController.clear();
    courseController.clear();
    emit(StateEditStudentsDataSuccessfully());
  }catch(errorExp){
    emit(StateEditStudentDataUnsuccessfully(errorExp: errorExp.toString()));
  }
}
}
