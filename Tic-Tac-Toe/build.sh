#!/usr/bin/env zsh
mkdir build
mkdir build/Tic-Tac-Toe
zip -9 -r ../build/Tic-Tac-Toe/Tic-Tac-Toe.love .

# For macos
cp ../build/Tic-Tac-Toe/Tic-Tac-Toe.love ../build/Tic-Tac-Toe/Tic-Tac-Toe.app/Contents/Resources/Tic-Tac-Toe.love
# For windows
mkdir ../build/Tic-Tac-Toe/win

cp -r ../build/love-win/* ../build/Tic-Tac-Toe/win
rm -f ../build/Tic-Tac-Toe/win/love.exe
rm -f ../build/Tic-Tac-Toe/win/lovec.exe

cat ../build/love-win/love.exe ../build/Tic-Tac-Toe/Tic-Tac-Toe.love > ../build/Tic-Tac-Toe/win/Tic-Tac-Toe.exe