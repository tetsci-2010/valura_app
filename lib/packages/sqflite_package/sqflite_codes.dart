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

  static const createBackupFailed = "CREATING_BACKUP_FAILED";

  // SUCCESS CODES
  static const successCode = "SUCCESS_CODE";
  static const successCodeWithDelete = "SUCCESS_CODE_WITH_DELETE";

  static const fileNotFoundToDelete = "FILE_NOT_FOUND_TO_DELETE";
  static const noDBFileFound = "NO_DB_FILE_FOUND";

  static const noFileSelected = "NO_FILE_SELECTED";
  static const fileNoFound = "FILE_NOT_FOUND";
  static const itemNotFound = "ITEM_NOT_FOUND";
}

String getErrorMessage(String errorCode, {String? additionalInfo}) {
  switch (errorCode) {
    // 🔹 Database General
    case SqfliteCodes.databaseException:
      return additionalInfo ?? "خطایی در پایگاه داده رخ داده است. لطفاً مجدداً تلاش کنید.";

    case SqfliteCodes.sqliteDatabaseException:
      return "خطا در پایگاه داده محلی. داده‌ها ممکن است آسیب دیده باشند.";

    case SqfliteCodes.unknowDatabaseError:
      return "خطای نامشخصی در پایگاه داده رخ داده است.";

    // 🔹 Table / Syntax / Constraints
    case SqfliteCodes.sqlSyntaxError:
      return "خطا در دستور SQL. لطفاً داده‌های ورودی را بررسی کنید.";

    case SqfliteCodes.tableNotFound:
      return "جدول مورد نظر یافت نشد. ممکن است نیاز به بروزرسانی برنامه داشته باشید.";

    case SqfliteCodes.uniqueConstraintFailed:
      return "امکان ذخیره داده تکراری وجود ندارد. لطفاً ورودی‌ها را بررسی کنید.";

    case SqfliteCodes.foreignKeyConstraintFailed:
      return "امکان حذف این آیتم وجود ندارد زیرا با داده‌های دیگر مرتبط است.";

    // 🔹 DB state / file / type
    case SqfliteCodes.dbOpenFailed:
      return "خطا در باز کردن پایگاه داده. فایل‌ها ممکن است آسیب دیده باشند.";

    case SqfliteCodes.dbClosed:
      return "پایگاه داده بسته است. لطفاً برنامه را مجدداً باز کنید.";

    case SqfliteCodes.fileSystemException:
      return "خطا در سیستم فایل. فضای ذخیره‌سازی را بررسی کنید.";

    case SqfliteCodes.dataTypeMismatch:
      return "نوع داده مطابقت ندارد. لطفاً ورودی‌ها را بررسی کنید.";

    case SqfliteCodes.queryTimeout:
      return "زمان اجرای درخواست به پایان رسید. لطفاً مجدداً تلاش کنید.";

    case SqfliteCodes.createBackupFailed:
      return "خطا در ایجاد نسخه پشتیبان. فضای ذخیره‌سازی را بررسی کنید.";

    // SUCCESS CODES
    case SqfliteCodes.successCode:
      return "عملیات با موفقیت انجام شد!";

    case SqfliteCodes.successCodeWithDelete:
      return "حذف با موفقیت انجام شد!";

    // FILE OPERATIONS
    case SqfliteCodes.fileNotFoundToDelete:
      return "فایل مورد نظر برای حذف یافت نشد.";

    case SqfliteCodes.noDBFileFound:
      return "فایل پایگاه داده یافت نشد.";

    case SqfliteCodes.noFileSelected:
      return "هیچ فایلی انتخاب نشده است.";

    case SqfliteCodes.fileNoFound:
      return "فایل یافت نشد.";
    case SqfliteCodes.itemNotFound:
      return "آیتم یافت نشد.";
    default:
      return additionalInfo ?? "خطای غیرمنتظره‌ای رخ داده است. لطفاً مجدداً تلاش کنید.";
  }
}
