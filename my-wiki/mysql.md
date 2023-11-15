# MYSQL
- InnoDB is [default engine](https://dev.mysql.com/doc/refman/8.0/en/storage-engine-setting.html)

MySQL includes character set support that enables you to store data using a variety of character sets and perform comparisons according to a variety of collations.
The default MySQL server character set and collation are utf8mb4 and utf8mb4\_0900\_ai\_ci, but you can specify character sets at the server, database, table, column, and string literal levels.
https://dev.mysql.com/doc/refman/8.0/en/charset.html
Set table as variable with prepared statement

```
SET @ID_1 = (SELECT ID FROM `slider` LIMIT 0,1);
SET @Cat = (SELECT Category FROM `slider` LIMIT 0,1);
SET @s = CONCAT('select * from ', @Cat, ' where ID = ', @ID_1);

PREPARE stmt1 FROM @s;
EXECUTE stmt1;
DEALLOCATE PREPARE stmt1;
```

## Manage database connections
I have one MySQL instance with one database for each user.
I want to build an API that should connect to the right database depending on the user calling it.

For this setup what is the best way to manage database connections?

In the documentation of the mysql node package I found the following two options:

1) Create one pool for the whole instance, then use [changeUser][2] to connect to the database,
for example like this:
```
const pool = createPool({
    connectionLimit: 10,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    port: 3306, // default
    host: process.env.SQL_INSTANCE_HOST,
  })

const connection = await pool.getConnection();
connection.changeUser({ database: userDatabase }, (err) => {
    throw new Error(`Could not connect to database: ${err}`);
  });
// use connection, release it after usage
```

2) Use [PoolCluster][3] to create one pool for each database, then use the call the pool corresponding to the user:
```
const poolCluster = mysql.createPoolCluster();
poolCluster.add('USER1', config1);
poolCluster.add('USER2', config2);
poolCluster.add('USER3', config3);

const pool = poolCluster.of('USER1');
pool.query(function (error, results, fields) {
  // perform query
});
```

In an [answer to an earlier question][1] someone expressed the preference for using PoolCluster over changeUser but without exactly explaining why.

What might be the pros and cons of using one option over another?
Are there other options to consider?

  [1]: https://stackoverflow.com/a/56146932/10895550
  [2]: https://www.npmjs.com/package/mysql#switching-users-and-altering-connection-state
  [3]: https://www.npmjs.com/package/mysql#poolcluster
