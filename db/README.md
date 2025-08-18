This directory stores SQL code
=======
To add code here, please follow the [SQL Coding Standards](./tinman_SQL_schema_standard/README.md)
Please use the .sqlfluff file in your preferred development environment, and manually apply the other rules for now.

### Local Database Setup
1. Create a local postgres server
2. Create a database called ndh
3. Execute the sql in `db/sql/schemas/ndh.sql` to create the ndh schema and associated tables
4. Create a `.env` file in the `src/` directory, following the template provided in `src/.env_template`, ensuring that the connection details reflect your database connection
5. Navigate to the `src/` directory. Run `python manage.py loaddata ndh.json` to load a sample of data into the database
