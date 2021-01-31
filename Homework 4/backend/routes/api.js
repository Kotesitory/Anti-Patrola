const express = require('express');
const router = express.Router();
const PatrolLocation = require('../models/PatrolLocation');
const PatrolContainerDto = require('../dto/PatrolContainerDto');
const PatrolDto = require('../dto/PatrolDto');
const verifyAndGetUser = require('../services/auth');
const calculateDistance = require('../services/geoService');

const PATROL_REPORT_TIMEOUT = 10 * 60 * 1000; // DEV NOTE: 10 minutes
const LIMIT_PATROL_AGE = 90 * 60 * 1000; // DEV NOTE: 1.5 hours
const MAX_DISTANCE_FOR_REPORT = 400; // meters
const CONFIDENCE_OFFSET = 0.15;

router.post('/patrols', extractToken, async (req, res) => {
    let user = await verifyAndGetUser(req.token);
    if(user){
        console.log(JSON.stringify(req.body));
        if(req.body['lon'] != undefined && req.body['lat'] != undefined){
            if(Date.now() - user.lastSubmitedAt < PATROL_REPORT_TIMEOUT){
                res.status(429).json({message: "Updating patrols too fast", status: 429});
                return;
            }

            let now = Date.now();
            await user.updateOne({ lastSubmitedAt: now });
            let newPatrol = {
                lon: req.body['lon'],
                lat: req.body['lat'],
                userId: user.googleId
            };

            PatrolLocation.create(newPatrol);
            res.status(200);
        } else {
            res.status(407).json({message: "Invelid request", status: 407});
        }
    } else {
        res.status(401).json({message: "Unauthorized access", status: 401});
    }
});

router.get('/patrols', extractToken, async (req, res) => {
    let user = await verifyAndGetUser(req.token);
    if(user){
        var dateTimeLimit = new Date(Date.now() - LIMIT_PATROL_AGE);

        var patrols = await PatrolLocation.find({createdAt: {$gte: dateTimeLimit}}).sort({createdAt: -1});
        if(requestIsWithRadius(req)){
            patrols = patrols.map(function(p) { 
                let a = {lat: req.query.lat, lon: req.query.lon};
                let b = {lat: p.lat, lon: p.lon}
                return new PatrolDto(p, calculateDistance(a, b));
            }).filter(p => p.distance <= req.query.radius);
        } else {
            patrols = patrols.map(p => new PatrolDto(p, null))
        }

        var dto = new PatrolContainerDto(patrols);
        res.json(dto);
    } else {
        res.status(401).json({message: "Unauthorized access", status: 401});
    }
});

router.post('/patrols/confirm', extractToken, verifyPatrolConfirmationRequest, async (req, res) => {
    let user = req.user;
    let patrol = req.patrol;
    if(patrol.userConfirmations.some(x => x.userId === user.googleId)){
        res.status(403).json({message: "User already confirmed this patrol", status: 403});
    } else{
        let new_conf = adjustPatrolReportConfidence(patrol.confidence, req.body['confirmation']);
        let new_list = patrol.userConfirmations;
        new_list.push({userId: user.googleId, confirmation: req.body['confirmation']});
        await patrol.update({ userConfirmations: new_list, confidence: new_conf });
        patrol.confidence = new_conf;
        res.json(new PatrolDto(patrol, null));
    }
});

function requestIsWithRadius(req){
    return req.query.lat != undefined && req.query.lon != undefined && req.query.radius != undefined;
}

/// Extracts auth-token from request
function extractToken(req, res, next) {
    const bearerHeader = req.headers['authorization'];
    if(typeof bearerHeader !== 'undefined') {
        const bearer = bearerHeader.split(' ');
        const bearerToken = bearer[1];
        req.token = bearerToken;
        next();
    } else {
        res.status(401).json({message: "Unauthorized access", status: 401});
    }
}

/// Verifies patrol confirmation request
async function verifyPatrolConfirmationRequest (req, res, next) {
    if(req.body['user_lon'] != undefined && req.body['user_lat'] != undefined && req.body['patrol_id'] != undefined && req.body['confirmation'] != undefined){
        let user = await verifyAndGetUser(req.token);
        if(user) {
            var patrol = await PatrolLocation.findOne({_id: req.body['patrol_id']});
            if(patrol){
                if(patrol.userId !== user.googleId){
                    let dateTimeLimit = new Date(Date.now() - LIMIT_PATROL_AGE);
                    let patrolDate = new Date(patrol.createdAt);

                    // DEV NOTE: patrol date is too old
                    if(patrolDate < dateTimeLimit){
                        res.status(403).json({message: "Patrol is too old", status: 403});
                    }else {
                        let a = {lat: user_lat, lon: user_lon};
                        let b = {lat: patrol.lat, lon: patrol.lon}
                        if(checkDistance(a, b)){
                            req.user = user;
                            req.patrol = patrol;
                            next();
                        } else{
                            res.status(403).json({message: "User not in range of patrol", status: 403});
                        }
                    }
                }else{
                    res.status(403).json({message: "Cannot confirm own patrol", status: 403});
                }
            }else{
                res.status(403).json({message: "Invalid patrol id", status: 403});
            }
        } else {
            res.status(401).json({message: "Unauthorized access", status: 401});
        }
    } else {
        res.status(407).json({message: "Invelid request", status: 407});
    }
}

/// Calculates distance between user and patrol
function checkDistance(point_a, point_b){
    return calculateDistance(point_a, point_b) <= MAX_DISTANCE_FOR_REPORT;
}

function adjustPatrolReportConfidence(current_value, confirmation){
    let res = 0;
    if (confirmation){
        res = sigmoid(clamp(current_value + CONFIDENCE_OFFSET));
    }else {
        res = sigmoid(clamp(current_value - CONFIDENCE_OFFSET));
    }

    // DEV NOTE: Rounded to 2 decimal places
    return Math.round(res * 100) / 100;
}

function sigmoid(x){
	let exp = Math.exp(-5.0 * (x - 0.5)) + 1;
	return 1.0 / exp
}

/// Clamps [x] between 0.0 and 1.0
function clamp(x){
    return Math.min(Math.max(x, 0.0), 1.0)
}

module.exports = router;