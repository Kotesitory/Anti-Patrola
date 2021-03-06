const dotenv = require('dotenv');
const express = require('express');
const passport = require('passport');
const morgan = require('morgan');
const session = require('express-session');
const connectDB = require('./config/db');
const app = express();
const cors = require('cors')

dotenv.config({path: './config/config.env'});

connectDB();

const PORT = process.env.PORT || 5000;

if(process.env.NODE_ENV === 'debug'){
    app.use(morgan('dev'));
}

// TODO: Remove because not used
require('./passport-setup');

app.set('view-engine', 'ejs');
app.use(express.json());

// TODO: Update this to real origin
var corsOptions = {
    origin: 'http://localhost:3000',
    optionsSuccessStatus: 200
};
app.use(cors(corsOptions));

// Session
app.use(session({
    secret: 'secret',
    resave: false,
    saveUninitialized: false,
}));

app.use(passport.initialize())
app.use(passport.session())

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