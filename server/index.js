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
    //Create Game Callback
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
            socket.join(name);
            io.to(name).emit('updateRoom', room);
        }
        catch (err) {
            console.log(err);
        }
    });

    //Join Game Callback
    socket.on('join-game', async ({ nickname, name }) => {
        try {
            let room = await Room.findOne({ name });
            if (!room) {
                socket.emit('notCorrectGame', 'Please enter a valid room name');
                return;
            }

            if (room.isJoin) {
                let player = {
                    socketID: socket.id,
                    nickname
                }
                room.players.push(player);
                socket.join(name);

                if (room.players.length === room.occupancy) {
                    room.isJoin = false;
                }
                room.turn = room.players[room.turnIndex];
                room = await room.save();
                io.to(name).emit('updateRoom', room);
            } else {
                socket.emit('notCorrectGame', 'The game is in progress, please try later');
            }
        }
        catch (err) {
            console.log(err);
        }
    });

    //White board socket
    socket.on('paint', ({ details, roomName }) => {
        io.to(roomName).emit('points', { 'details': details });
    });
});

server.listen(port, "0.0.0.0", () => {
    console.log(`Server is running on port ${port}`);
});