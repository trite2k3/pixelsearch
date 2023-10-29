/*
	PixelSearch v1.0

	A tool made for linux

	A tool that searches the screen for a pixel of a certain color and returns it's coordiantes
	Uses X11 and stdlib/iostream
*/
// g++ <name>.cxx -o <name> -lX11
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <iostream>
#include <stdlib.h>
int GetColor( int SRed,int SGreen,int SBlue,int ColorDelta, int CDelta = 1, int SX = 0, int SY = 0, int EX = 0, int EY = 0 )
{
	static bool Match;
	static int x, y;
	int Red, Green, Blue, XMax, YMax;
	XImage *image;
	XColor Color;
	Display *Display = XOpenDisplay( ( char * ) NULL );
	if( EX == 0 )
	{
		XMax = WidthOfScreen(DefaultScreenOfDisplay( Display ) );
	}
	else
	{
		XMax = EX;
	}
	if( EY == 0 )
	{
		YMax = HeightOfScreen(DefaultScreenOfDisplay( Display ) );
	}
	else
	{
		YMax = EY;
	}
	while( !Match )
		{
			//Moves checked posiotion across the screen
			x = x + CDelta;
			if (x >= (XMax - CDelta))
			{
				x = SX;
				y = y + CDelta;
				if( y >= (YMax - CDelta) )
				{
					y = SY;
				}
			}
			//gets locations color
			image = XGetImage ( Display, RootWindow ( Display, DefaultScreen ( Display ) ), x, y, 1, 1, AllPlanes,XYPixmap );
			Color.pixel = XGetPixel( image, 0, 0);
			XFree ( image );
			XQueryColor ( Display, DefaultColormap( Display, DefaultScreen ( Display ) ), &Color );
			//Compares colors
			Red = Color.red/256;
			Green = Color.green/256;
			Blue = Color.blue/256;
			if( SRed - ColorDelta <= Red && Red <= SRed + ColorDelta && SGreen - ColorDelta <= Green && Green <= SGreen + ColorDelta && SBlue - ColorDelta <= Blue && Blue <= SBlue + ColorDelta )
			{
				Match = true;
			}
		}
	//when a match is found returns X and Y coordiantes
	if (Match)
	{
		std::cout<<x <<","<<y <<"\n";
	}
	return 0;
}
int main( int argc, char **argv )
{
	int SRed = atoi(argv[1]);
	int SGreen = atoi(argv[2]);
	int SBlue = atoi(argv[3]);
	int ColorDelta = atoi(argv[4]);
	int CDelta = atoi(argv[5]);
	int SX = atoi(argv[6]);
	int SY = atoi(argv[7]);
	int EX = atoi(argv[8]);
	int EY = atoi(argv[9]);
	GetColor( SRed, SGreen, SBlue, ColorDelta, CDelta, SX, SY , EX, EY );
	return 0;
}
