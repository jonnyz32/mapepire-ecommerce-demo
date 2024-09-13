import express from 'express';
import odbc  from 'odbc';
import cors from 'cors';
import 'dotenv/config';

// Connection string to DB2, using a DSN or a direct connection
const connectionString = [
    `DRIVER=IBM i Access ODBC Driver`,
    `SYSTEM=${process.env.HOST}`,
    `UID=${process.env.USER}`,
    `Password=${process.env.PASSWORD}`,
    `Naming=1`,
  ].join(`;`);

const app = express();
app.use(cors())
const PORT = 5000;

// Endpoint to fetch data from multiple tables
app.get('/api/tables', async (req, res) => {
  try {
    // Establish ODBC connection
    const connection = await odbc.connect(connectionString);
    
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

    const results = {dbClient: "odbc", tables:{}};


    // Loop over queries to fetch data from each table
    for (const table in queries) {
      const queryResult = await connection.query(queries[table]);
      results.tables[table] = queryResult;
    }

    // Close the connection after fetching the data
    await connection.close();

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
