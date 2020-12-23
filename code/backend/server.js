const dotenv = require('dotenv');
const express = require('express');
const morgan = require('morgan');
const connectDB = require('./config/db');
const app = express();
const cors = require('cors');
const https = require('https');
const fs = require('fs');
dotenv.config({path: './config/config.env'});

connectDB();

const PORT = process.env.PORT || 5000;

if(process.env.NODE_ENV === 'debug'){
    app.use(morgan('dev'));
}

app.set('view-engine', 'ejs');
app.use(express.json());

//var whitelist = [];
var whitelist = ['http://localhost', 'https://antipatrola.ml', 'https://www.antipatrola.ml', 
	'https://client:443', 'https://localhost:4443'];

// TODO: Update this to real origin
var corsOptions = {
    origin: function(origin, callback) {
            if(!origin || whitelist.indexOf(origin) !== -1){
                callback(null, true);
            }
            else{
                console.log(origin);
                callback(new Error('CORS Not allowed'));
            }
        },
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

const httpsServer = https.createServer({
    key: fs.readFileSync('./private.key'),
    cert: fs.readFileSync('./certificate.crt'),
}, app);

httpsServer.listen(PORT, () => {
    console.log(`Server running in ${process.env.NODE_ENV} mode on port ${PORT}`);
});

//app.listen(PORT, console.log(`Server running in ${process.env.NODE_ENV} mode on port ${PORT}`));