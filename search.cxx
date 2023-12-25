/*
	PixelSearch v1.0

	A tool made for linux

	A tool that searches the screen for a pixel of a certain color and returns it's coordiantes
	Uses X11 and stdlib/iostream
*/
// g++ <name>.cxx -o <name> -lX11 -lfreeimage
//
// added width and height parameters to X11 GetImage
// ./<name> <SRed> <SGreen> <SBlue> <ColorDelta> <CDelta> <SX> <SY> <EW> <EH>
// ./searchwidth 31 14 10 1 10 3792 478 575 343 575 343
//

#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <iostream>
#include <stdlib.h>
/*
//Debug
#include <FreeImage.h>
#include <fstream>
void saveImageToFile(XImage *image, const char *filename) {
    // Assuming XYPixmap has 24 bits per pixel (8 bits for each RGB channel)
    //int bytes_per_line = image->width * 3; // 3 bytes per pixel for RGB

    FIBITMAP *bitmap = FreeImage_Allocate(image->width, image->height, 24); // 24 bits per pixel for RGB
    if (!bitmap) {
        fprintf(stderr, "Error: Couldn't allocate FreeImage bitmap\n");
        return;
    }

    // Iterate through each pixel and set the corresponding RGB value
    for (int y = 0; y < image->height; ++y) {
        // Reverse the order of rows to address upside-down issue
        int reversedY = image->height - 1 - y;

        for (int x = 0; x < image->width; ++x) {
            unsigned long pixelValue = XGetPixel(image, x, reversedY);

            // Extract RGB channels (assuming 24 bits per pixel)
            BYTE red = (pixelValue >> 16) & 0xFF;
            BYTE green = (pixelValue >> 8) & 0xFF;
            BYTE blue = pixelValue & 0xFF;

            RGBQUAD color = {blue, green, red}; // FreeImage uses BGR order
            FreeImage_SetPixelColor(bitmap, x, y, &color);
        }
    }

    // Check if the file already exists
    std::ifstream file(filename);
    if (file.good()) {
        // Remove the existing file
        if (remove(filename) != 0) {
            fprintf(stderr, "Error: Couldn't remove existing file %s\n", filename);
            FreeImage_Unload(bitmap);
            return;
        }
    }

    // Save the image to the file
    if (!FreeImage_Save(FIF_PNG, bitmap, filename, 0)) {
        fprintf(stderr, "Error: Couldn't save image to file %s\n", filename);
    } else {
        printf("Image saved successfully to %s\n", filename);
    }

    FreeImage_Unload(bitmap);
}
*/

//int GetColor( int SRed,int SGreen,int SBlue,int ColorDelta, int CDelta = 1, int SX = 0, int SY = 0, int EX = 0, int EY = 0)//, int EW = 1, int EH = 1 )
int GetColor( int SRed,int SGreen,int SBlue,int ColorDelta, int CDelta, int SX, int SY, int EW, int EH )
{
	static bool Match;
	static int x, y;
	int Red, Green, Blue;
	XImage *image;
	XColor Color;
	Display *Display = XOpenDisplay( ( char * ) NULL );
    int posX, posY;

	while( !Match )
		{
            //Try and save cpu and Xorg process by scanning a larger area before polling Xorg
            image = XGetImage ( Display, RootWindow ( Display, DefaultScreen ( Display ) ), SX, SY, EW, EH, AllPlanes,XYPixmap );
            /*
            //Debug
            saveImageToFile(image, "screenshot.png");
            */

            //Nested loop through everything
            for (int i = y; i < y + EH; ++i)
            {
                for (int j = x; j < x + EW; ++j)
                {
                    Color.pixel = XGetPixel( image, j, i);

                    XQueryColor ( Display, DefaultColormap( Display, DefaultScreen ( Display ) ), &Color );

                    //Compares colors
                    Red = Color.red/256;
                    Green = Color.green/256;
                    Blue = Color.blue/256;

                    //Debug
                    //posX = SX + j;
                    //posY = SY + i;
                    //std::cout<<"RGB: " <<Red <<"," <<Green <<"," <<Blue <<" @ " <<posX <<"," <<posY <<"\n";
                    //std::cout<<posX <<"," <<posY <<"\n";

                    if( SRed - ColorDelta <= Red && Red <= SRed + ColorDelta && SGreen - ColorDelta <= Green && Green <= SGreen + ColorDelta && SBlue - ColorDelta <= Blue && Blue <= SBlue + ColorDelta )
                    {
                        posX = SX + j;
                        posY = SY + i;
                        Match = true;
                    }
                }
            }
		}

    if (Match)
    {
        std::cout<<posX <<","<<posY <<"\n";
    }

    //Free memory and resources for image
    XFree ( image );
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
	int EW = atoi(argv[8]);
	int EH = atoi(argv[9]);
	GetColor( SRed, SGreen, SBlue, ColorDelta, CDelta, SX, SY , EW, EH );
	return 0;
}
