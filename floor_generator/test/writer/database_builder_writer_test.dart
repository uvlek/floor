import 'package:code_builder/code_builder.dart';
import 'package:floor_generator/writer/database_builder_writer.dart';
import 'package:test/test.dart';

import '../test_utils.dart';

void main() {
  useDartfmt();

  test('generate database builder', () async {
    const databaseName = 'FooBar';

    final actual = DatabaseBuilderWriter(databaseName).write();

    expect(actual, equalsDart(r'''
      class $FooBarBuilder {
        $FooBarBuilder(this.name);
      
        final String name;
      
        final List<Migration> _migrations = [];

        Callback _callback;
      
        /// Adds migrations to the builder.
        $FooBarBuilder addMigrations(List<Migration> migrations) {
          _migrations.addAll(migrations);
          return this;
        }

        /// Adds a database [Callback] to the builder.
        $FooBarBuilder addCallback(Callback callback) {
          _callback = callback;
          return this;
        }

        /// Creates the database and initializes it.
        Future<FooBar> build() async {
          final path = name != null
            ? await sqfliteDatabaseFactory.getDatabasePath(name)
            : ':memory:'; 
          final database = $FooBar();
          database.database = await database.open(
            path,
            _migrations,
            _callback,
          );
          return database;
        }
      }      
    '''));
  });
}
