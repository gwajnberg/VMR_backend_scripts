import sqlparse
import json

def sql_to_json(sql_file, json_file):
    with open(sql_file, 'r') as f:
        sql_content = f.read()

    # Parse SQL
    parsed_sql = sqlparse.parse(sql_content)
    print (parsed_sql)
    

# Usage
sql_to_json("schema/grdi-amr2_schema_latest_version01302024.sql", 'schema.json')