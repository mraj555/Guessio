# Guessio

## Overview

Guessio is an interactive multiplayer drawing and guessing game built with Flutter. Players can create or join game rooms to play with friends or other users. One player receives a word to draw, while others try to guess the word based on the drawing in real-time.

## Features

*   **Real-time Multiplayer:** Engage in live gameplay sessions with multiple players simultaneously.
*   **Create Game Rooms:** Easily set up a new game room and invite others to join.
*   **Join Existing Rooms:** Browse and join available game rooms to start playing quickly.
*   **Interactive Drawing Canvas:** A shared canvas for the designated player to draw the secret word.
*   **Live Guessing:** Players can submit their guesses as the drawing unfolds.
*   **Cross-platform:** Built with Flutter, allowing for a consistent experience across different platforms.

## Tech Stack

*   **Frontend:** Flutter
*   **Backend:** Node.js (likely using Express.js and WebSockets for real-time communication)

## How to Play (General Idea)

1.  **Start the Game:** Launch the Guessio application.
2.  **Create or Join a Room:**
    *   **Create:** Set up a new room, which might generate a unique ID to share.
    *   **Join:** Enter an existing room ID to join a game in progress or waiting for players.
3.  **Gameplay:**
    *   One player is chosen to draw a word (which is provided to them secretly).
    *   The drawing player uses the canvas to illustrate the word.
    *   Other players in the room try to guess the word by typing their guesses.
    *   Points are typically awarded for correct guesses and for the drawer when their drawing is guessed.
4.  **Winning:** The game might continue for a set number of rounds or until a certain score is reached.

---
