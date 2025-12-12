///* Database Name
const String dbName = 'valura.db';
///* Database Backup Name
const String dbBackupName = 'valura_backup.db';

///* Tables
const String itemsTable = 'items';
const String productsTable = 'products';
const String productDetailsTable = 'product_details';

///* Queries
//* Items
const String createItemsTable =
    '''
  CREATE TABLE $itemsTable (
  id INTEGER PRIMARY KEY,
  item_id INT NOT NULL,
  name VARCHAR(255) NOT NULL,
  purchase_rate DOUBLE NOT NULL,
  land_cost DOUBLE NOT NULL,
  unit_cost DOUBLE NOT NULL,
  new_rate DOUBLE NOT NULL,
  description TEXT
  )
''';

const String createProductsTable =
    '''
  CREATE TABLE $productsTable (
  id INTEGER PRIMARY KEY NOT NULL,
  name VARCHAR(255) NOT NULL,
  total num NOT NULL
  )
''';

const String createProductDetailsTable =
    '''
  CREATE TABLE $productDetailsTable (
  id INTEGER PRIMARY KEY NOT NULL,
  product_id INT NOT NULL,
  item_id INT NOT NULL,
  name VARCHAR(255) NOT NULL,
  purchase_rate num NOT NULL,
  land_cost num NOT NULL,
  unit_cost num NOT NULL,
  new_rate num NOT NULL,
  description TEXT
  )
''';
