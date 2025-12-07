class SqfliteCodes {
  // 🔹 Database General
  static const databaseException = "DATABASE_EXCEPTION";
  static const sqliteDatabaseException = "SQLITE_DATABASE_EXCEPTION";
  static const unknowDatabaseError = "UNKNOWN_DATABASE_ERROR";

  // 🔹 Table / Syntax / Constraints
  static const sqlSyntaxError = "SQL_SYNTAX_ERROR";
  static const tableNotFound = "TABLE_NOT_FOUND";
  static const uniqueConstraintFailed = "UNIQUE_CONSTRAINT_FAILED";
  static const foreignKeyConstraintFailed = "FOREIGN_KEY_CONSTRAINT_FAILED";

  // 🔹 DB state / file / type
  static const dbOpenFailed = "DB_OPEN_FAILED";
  static const dbClosed = "DB_CLOSED";
  static const fileSystemException = "FILE_SYSTEM_EXCEPTION";
  static const dataTypeMismatch = "DATA_TYPE_MISMATCH";
  static const queryTimeout = "QUERY_TIMEOUT";

  // SUCCESS CODES
  static const successCode = "SUCCESS_CODE";
}
