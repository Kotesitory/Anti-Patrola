const dotenv = require('dotenv');
const express = require('express');
const morgan = require('morgan');
const connectDB = require('./config/db');
const app = express();
const cors = require('cors');
dotenv.config({path: './config/config.env'});

connectDB();

const PORT = process.env.PORT || 3000;

if(process.env.NODE_ENV === 'debug'){
    app.use(morgan('dev'));
}

app.set('view-engine', 'ejs');
app.use(express.json());

// TODO: Update this to real origin
var corsOptions = {
    origin: 'http://localhost:3000',
    optionsSuccessStatus: 200
};
app.use(cors(corsOptions));

// Routes
app.use('/', require('./routes/index'));
app.use('/api', require('./routes/api'));
app.use(function(req, res) {
    res.json({message:'404: Page not Found', status:404});
});
app.use(function(req, res) {
    res.json({message:'500: Internal Server Error', status:500});
});

app.listen(PORT, console.log(`Server running in ${process.env.NODE_ENV} mode on port ${PORT}`));