import { useState, useEffect } from 'react';
import { Blocks } from 'react-loader-spinner';


function App() {
  const [data, setData] = useState({});
  const [loadingTime, setLoadingTime] = useState<number>();

  useEffect(() => {
      const fetchData = async () => {
        const startTime = performance.now(); // Start timer
  
        try {
          const response = await fetch('http://localhost:5000/api/tables'); // Backend API
          const result = await response.json();
          setData(result);
        } catch (error) {
          console.error('Error fetching data:', error);
        }
  
        const endTime = performance.now(); // End timer
        setLoadingTime(endTime - startTime); // Calculate loading time
      };
  
      fetchData();
  }, []);

  return (
    <div>
      <h1>DB2 Table Data</h1>
      {!loadingTime && 
      <Blocks
      height="80"
      width="80"
      color="#4fa94d"
      ariaLabel="blocks-loading"
      wrapperStyle={{}}
      wrapperClass="blocks-wrapper"
      visible={true}
      />}
      {loadingTime && (
        <p>Data fetched using {data.dbClient} and rendered in {loadingTime.toFixed(2)} milliseconds</p>
      )}
      {data?.tables && Object.keys(data.tables).map(table => (
        <div key={table}>
          <h2>{table}</h2>
          <table border={1}>
            <thead>
              <tr>
                {data.tables[table] && Object.keys(data.tables[table][0] || {}).map(column => (
                  <th key={column}>{column}</th>
                ))}
              </tr>
            </thead>
            <tbody>
              {data.tables[table].map((row, idx) => (
                <tr key={idx}>
                  {Object.values(row).map((val, i) => (
                    <td key={i}>{val}</td>
                  ))}
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      ))}
    </div>
  );
}

export default App;
