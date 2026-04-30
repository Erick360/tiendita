import 'package:riverpod/riverpod.dart';
import 'package:tiendita/database/tienditaDatabase.dart';


//database connection
final databaseProvider = Provider<TienditaDatabase>((ref) {
  final database = TienditaDatabase();
  ref.onDispose(() => database.close());
  return database;
});