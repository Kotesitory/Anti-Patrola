const _EARTRH_R = 6371e3; // In meteres

/// Calculates distance between two points on a map
function calculateDistance(point_a, point_b){
    const lat1_rad = point_a.lat * Math.PI/180;
    const lat2_rad = point_b.lat * Math.PI/180;
    const delta_lat = lat1_rad - lat2_rad;
    const delta_lon = (point_a.lon - point_b.lon) * Math.PI/180;

    const a = Math.sin(delta_lat/2) * Math.sin(delta_lat/2) + 
        Math.cos(lat1_rad) * Math.cos(lat2_rad) *
        Math.sin(delta_lon/2) * Math.sin(delta_lon/2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    return _EARTRH_R * c;
}

module.exports = calculateDistance;