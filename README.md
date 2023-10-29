# pixelsearch
tool used to seatch for a pixel of a certain color on an X11 display and return its coordinates,
moves mouse to found coordinate

# build
g++ search.cxx -o search -lX11 -Wall

# run
(modify pixel rgb)
./run.sh
