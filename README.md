# pixelsearch
tool used to seatch for a pixel of a certain color on an X11 display and return its coordinates,
moves mouse to found coordinate

# build
g++ limitedsearch.cxx -o limitedsearch -lX11 -Wall

# run
./limitedsearch <SRed> <SGreen> <SBlue> <ColorDelta> <CDelta> <SX> <SY> <EX> <EY>

./limitedsearch 255 255 255 0 10 3643 323 1 1

