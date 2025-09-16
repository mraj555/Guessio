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

    // Message Callback
    socket.on('msg', async (data) => {
        try {
            if (data.msg == data.word) {
                let room = await Room.findOne({ name: data.roomName });
                let userPlayer = room[0].players.filter((player) => player.nickname === data.username);
                if (data.timeTaken !== 0) {
                    userPlayer[0].points += Math.round((200 / data.timeTaken) * 10);
                }
                room = await room[0].save();
                io.to(data.roomName).emit('msg', {
                    'username': data.username,
                    'msg': 'Guessed it!',
                    'user_counter': data.user_counter + 1,
                });
                socket.emit('closeInput', "");
            } else {
                io.to(data.roomName).emit('msg', {
                    'username': data.username,
                    'msg': data.msg,
                    'user_counter': data.user_counter
                });
            }
        }
        catch (err) {
            console.log(err);
        }
    });

    //Change Turn Index Socket
    socket.on('change-turn', async (name) => {
        try {
            let room = await Room.findOne({ name });
            let idx = room.turnIndex;
            if (idx + 1 == room.players.length) {
                room.currentRound += 1;
            }

            if (room.currentRound <= room.maxRounds) {
                const word = getWord();
                room.word = word;
                room.turnIndex = (idx + 1) % room.players.length;
                room.turn = room.players[room.turnIndex];
                room = await room.save();
                io.to(name).emit('change-turn', room);
            } else {
                io.to(name).emit('show-leaderboard', room.players);
            }
        }
        catch (err) {
            console.log(err);
        }
    });

    //Score Update Socket
    socket.on('update-score', async (name) => {
        try {
            let room = await Room.findOne({ name });
            io.to(name).emit('update-score', room);
        }
        catch (err) {
            console.log(err);
        }
    });

    //White board socket
    socket.on('paint', ({ details, roomName }) => {
        io.to(roomName).emit('points', { 'details': details });
    });

    //Color Socket
    socket.on('color-change', ({ color, roomName }) => {
        io.to(roomName).emit('color-change', color);
    });

    //Stroke Socket
    socket.on('stroke-width', ({ value, roomName }) => {
        io.to(roomName).emit('stroke-width', value);
    });

    //Clear Canvas Socket
    socket.on('clear-canvas', ({ roomName }) => {
        io.to(roomName).emit('clear-canvas', '');
    });

    socket.on('disconnect', async () => {
        try {
            let room = await Room.findOne({ "players.socketID": socket.id });
            for (let i = 0; i < room.players.length; i++) {
                if (room.players[i].socketID === socket.id) {
                    room.players.splice(i, 1);
                    break;
                }
            }
            room = await room.save();
            if (room.players.length === 1) {
                socket.broadcast.to(room.name).emit('show-leaderboard', room.players);
            } else {
                socket.broadcast.to(room.name).emit('user-disconnected', room);
            }
        }
        catch (err) {
            console.log(err);
        }
    });

});

server.listen(port, "0.0.0.0", () => {
    console.log(`Server is running on port ${port}`);
});