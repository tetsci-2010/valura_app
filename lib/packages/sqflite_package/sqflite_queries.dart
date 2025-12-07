const String dbName = 'valura_db.db';
const String itemsTable = 'items';
const String createItemsTable =
    '''
  CREATE TABLE $itemsTable (
  id INT PRIMARY KEY,
  item_id INT NOT NULL,
  name VARCHAR(255) NOT NULL,
  purchase_rate DOUBLE NOT NULL,
  land_cost DOUBLE NOT NULL,
  unit_cost DOUBLE NOT NULL,
  new_rate DOUBLE NOT NULL,
  description TEXT
  )
''';
