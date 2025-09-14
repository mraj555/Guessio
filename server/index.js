const express = require("express");
var http = require('http');
const app = express();
const port = process.env.PORT || 3000;
var server = http.createServer(app);
const mongoose = require('mongoose');
const Room = require('./models/Room');
const getWord = require('./api/getWord');
var io = require('socket.io')(server);

// Middleware
app.use(express.json());

// Coonect to our database
const DB = 'mongodb+srv://jenilambaliya555_db_user:dbO50Cyho30MTldD@guessio.07zfkht.mongodb.net/?retryWrites=true&w=majority&appName=GuessIO';

mongoose.connect(DB).then(() => {
    console.log("DB connection successful!")
}).catch((e) => {
    console.log(e);
});

io.on('connection', (socket) => {
    console.log('connected');
    socket.on('create-game', async ({ nickname, name, occupancy, maxRounds }) => {
        try {
            const existingRoom = await Room.findOne({ name });
            if (existingRoom) {
                socket.emit('notCorrectGame', 'Room with that name already exists');
                return;
            }
            let room = new Room();
            const word = getWord();
            room.word = word;
            room.name = name;
            room.occupancy = occupancy;
            room.maxRounds = maxRounds;

            let player = {
                socketID: socket.id,
                nickname,
                isPartyLeader: true,
            }
            room.players.push(player);

            room = await room.save();
            socket.join(room);
            io.to(name).emit('updateRoom', room);
        }
        catch (err) {
            console.log(err);
        }
    });
});

server.listen(port, "0.0.0.0", () => {
    console.log(`Server is running on port ${port}`);
});