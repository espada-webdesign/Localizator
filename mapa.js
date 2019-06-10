

var data = [
    [3, 37, 0, 'DM', 'Nám. A. Hlinku 7B', '', 'Žilina', '010 01', 49.22458000, 18.74161000, '', '917918635', '', '', '', 0, 'dm', '0000-00-00 00:00:00', '2017-10-02 15:19:03'],
    [6, 16, 0, 'WELEDA BEAUTY & STORE', 'Lidická 337/30', '', 'Praha 5', '15000', 50.07239200, 14.40595600, 'a:7:{i:0;s:12:\"9:00 - 18:00\";i:1;s:12:\"9:00 - 18:00\";i:2;s:12:\"9:00 - 18:00\";i:3;s:12:\"9:00 - 18:00\";i:4;s:12:\"9:00 - 18:00\";i:5;s:8:\"Zavřeno\";i:6;s:8:\"Zavřeno\";}', '775 577 060', '257 315 889', 'prodejna@weleda.cz', 'Firma je registrována pod spisovou značkou C 3981 ze dne 10.09. 1991 u rejstříkového soudu v Praze.', 1, 'weleda', '2012-03-16 17:22:30', '2016-12-20 12:16:55'],
    [7, 16, 0, 'Makroveget', 'Česká 50', null, 'Beroun', '', 49.96342090, 14.07186600, null, '311623687', null, null, null, 1, 'weleda', '0000-00-00 00:00:00', '0000-00-00 00:00:00'],
    [9, 16, 0, 'Brána k dětem', 'Orlí 17', '', 'Brno', '602 00', 49.19386270, 16.61173310, '', '601374776', '', '', '', 1, 'weleda', '0000-00-00 00:00:00', '2014-09-11 10:18:58']
]
var locations = [{ x: 50.06, y: 14.5186, title: "KN" }, { x: 50.102552, y: 14.392868, title: "Dejvice" }]
var markers = []
var map = L.map('mapid').setView([49.7, 15.5], 7);

// https://account.mapbox.com/access-tokens/ request access token
L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFydHljYXNoZXciLCJhIjoiY2p3bzBwa2NiMmQyczQ5bzIwenFrbWNmYiJ9.8vHaT7NMz3mszqg9uqu9hw', {
    maxZoom: 18,
    attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, ' +
        '<a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
        'Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
    id: 'mapbox.streets'
}).addTo(map);

locations.forEach(element => {
    markers.push(L.marker([element.x, element.y]).addTo(map)
        .bindPopup(element.title));
});

data.forEach(element => {
    var side = document.getElementsByClassName("side")[0];
    var div = document.createElement("div");
    div.classList.add("rowitem");
    div.appendChild(document.createTextNode(element[3]));
    side.appendChild(div);
    markers.push(L.marker([element[8], element[9]]).addTo(map)
        .bindPopup("<b class=title>"+element[3]+"</b><br>" + element[4] + "<br>" + element[6] + "<br>" + element[7] ));
});

var popup = L.popup();

