import express from 'express';
import cors from 'cors';
import mapepire from '@ibm/mapepire-js';
import 'dotenv/config'

const app = express();
app.use(cors())
const PORT = 5000;

const creds = {
    host: process.env.HOST,
    port: process.env.PORT,
    user: process.env.USER,
    password: process.env.PASSWORD,
  };

const ca = await mapepire.getCertificate(creds);
creds.ca = ca.raw;


// Endpoint to fetch data from multiple tables
app.get('/api/tables', async (req, res) => {
  try {
    // Establish mapepire connection
    const job = new mapepire.SQLJob();

    await job.connect(creds);    
    // Define queries for multiple tables
    const queries = {
      users: 'SELECT * FROM ECOMMERCE.USERS FETCH FIRST 10 ROWS ONLY',
      products: 'SELECT * FROM ECOMMERCE.PRODUCTS FETCH FIRST 10 ROWS ONLY',
      categories: 'SELECT * FROM ECOMMERCE.CATEGORIES FETCH FIRST 10 ROWS ONLY',
      orders: 'SELECT * FROM ECOMMERCE.ORDERS FETCH FIRST 10 ROWS ONLY',
      orderItems: 'SELECT * FROM ECOMMERCE.Order_Items FETCH FIRST 10 ROWS ONLY',
      payments: 'SELECT * FROM ECOMMERCE.Payments FETCH FIRST 10 ROWS ONLY',
      shipping: 'SELECT * FROM ECOMMERCE.Shipping FETCH FIRST 10 ROWS ONLY',
      reviews: 'SELECT * FROM ECOMMERCE.Reviews FETCH FIRST 10 ROWS ONLY',
      shoppingCarts: 'SELECT * FROM ECOMMERCE.Shopping_Carts FETCH FIRST 10 ROWS ONLY',
      cartItems: 'SELECT * FROM ECOMMERCE.Cart_Items FETCH FIRST 10 ROWS ONLY',
      // Add more table queries as needed
    };

    const results = {dbClient: "mapepire", tables:{}};

    // Loop over queries to fetch data from each table
    for (const table in queries) {
      const queryResult = await job.execute(queries[table]);
      results.tables[table] = queryResult.data;
    }

    // Close the connection after fetching the data
    await job.close();

    // Send the fetched data as the response
    res.json(results);

  } catch (err) {
    console.error('Error fetching data from DB2:', err);
    res.status(500).send('Error fetching data');
  }
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
