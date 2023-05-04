import React, { useState, useEffect } from 'react';
import { Client } from 'pg';
//import parse from 'pg-connection-string';


const ColumnsNames = () => {
    const [Columns, setColumns] = useState(null);
    useEffect(()=>{
        const client = new Client({
            host: '10.139.14.109',
            port: '5433',
            database: 'metabaseappdb',
            user: 'gabriel',
            password: ''
            
          });
        client.connect();
        client.query(`SELECT column_name FROM information_schema.columns WHERE table_name='${'Hosts'}'`)
      .then(res => {
        setColumns(res.rows.map(row => row.column_name));
      })
      .catch(e => console.error(e.stack))
      .finally(() => client.end());
        
});

return(Columns && Columns) 
}




export default ColumnsNames;