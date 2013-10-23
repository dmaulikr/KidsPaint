//
//  CustomColor.m
//  KidsPaint
//
//  Created by Frid, Jonas on 2012-01-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomColor.h"
#import <math.h>

@implementation CustomColor
    
@synthesize rgb = _rgb;
@synthesize hsl = _hsl;

+(id)colorWithRGB:(RGB*)rgb
{
    CustomColor *newColor = [CustomColor new];
    
    newColor.rgb = rgb;
    
    return newColor;
}

-(CustomColor*)copyColor
{
    CustomColor *newColor = [CustomColor new];
    
    newColor.rgb = [RGB rgbWithRed:_rgb.red andGreen:_rgb.green andBlue:_rgb.blue];
    
    return newColor;
}

-(UIColor*)getUIColor
{
    if (_rgb != nil)
    {
        return [UIColor colorWithRed:_rgb.red 
                               green:_rgb.green 
                                blue:_rgb.blue alpha:1.0];
    }
    else
    {
        return nil;
    }
}

-(CMYK*)convertToCMYKfromRGB:(RGB*)rgb
{
    CMYK *newCMYK = [CMYK new];
    
    newCMYK.key = MIN(1 - rgb.red,MIN(1-rgb.green,1-rgb.blue));
    
    if (newCMYK.key < 1)
    {
        newCMYK.cyan = (1-rgb.red-newCMYK.key)/(1-newCMYK.key);
        newCMYK.magenta = (1-rgb.green-newCMYK.key)/(1-newCMYK.key);
        newCMYK.yellow = (1-rgb.blue-newCMYK.key)/(1-newCMYK.key);
    }
    else
    {
        newCMYK.cyan = 1;
        newCMYK.magenta = 1;
        newCMYK.yellow = 1;
    }
    
    return newCMYK;
}

-(RGB*)convertToRGBfromCMYK:(CMYK*)cmyk
{
    RGB *newRGB = [RGB new];
    
    newRGB.red = 1 - cmyk.cyan - cmyk.key + (cmyk.cyan * cmyk.key);
    newRGB.green = 1 - cmyk.magenta - cmyk.key + (cmyk.magenta * cmyk.key);
    newRGB.blue = 1 - cmyk.yellow - cmyk.key + (cmyk.yellow * cmyk.key);
    
    return newRGB;
}

-(RGB*)convertToRGBfromHSL:(HSL*)hsl
{
    RGB *newRGB = [RGB new];
    
    if ( hsl.saturation == 0 )                       //HSL from 0 to 1
    {
        newRGB.red = hsl.lightness;                      //RGB results from 0 to 255
        newRGB.green = hsl.lightness;
        newRGB.blue = hsl.lightness;
    }
    else
    {
        CGFloat var_2;
        
        if ( hsl.lightness < 0.5f )
        {
            var_2 = hsl.lightness * ( 1 + hsl.saturation );
        }
        else
        {
            var_2 = ( hsl.lightness + hsl.saturation ) - ( hsl.saturation * hsl.lightness );
        }
     
        CGFloat var_1 = 2.0f * hsl.lightness - var_2;
     
        newRGB.red = [self hueToRGBWithV1:var_1 andV2:var_2 andVH:hsl.hue + (1.0f / 3.0f)];
        newRGB.green = [self hueToRGBWithV1:var_1 andV2:var_2 andVH:hsl.hue];
        newRGB.blue = [self hueToRGBWithV1:var_1 andV2:var_2 andVH:hsl.hue - (1.0f / 3.0f)];
    }
    
    return newRGB;
}

-(CGFloat)hueToRGBWithV1:(CGFloat)v1 andV2:(CGFloat)v2 andVH:(CGFloat)vH
{
    if ( vH < 0 ) {vH += 1.0f;}
    if ( vH > 1 ) {vH -= 1.0f;}
    if ( ( 6.0f * vH ) < 1 ) {return ( v1 + ( v2 - v1 ) * 6.0f * vH );}
    if ( ( 2.0f * vH ) < 1 ) {return ( v2 );}
    if ( ( 3.0f * vH ) < 2 ) {return ( v1 + ( v2 - v1 ) * ( ( 2.0f / 3.0f ) - vH ) * 6.0f );}
    return v1;
}

-(HSL*)convertToHSLfromRGB:(RGB*)rgb
{
    HSL *newHSL = [HSL new];
    
    CGFloat var_R = rgb.red;                     //RGB from 0 to 255
    CGFloat var_G = rgb.green;
    CGFloat var_B = rgb.blue;
    
    CGFloat var_Min = MIN( var_R, MIN(var_G, var_B) );    //Min. value of RGB
    CGFloat var_Max = MAX( var_R, MAX(var_G, var_B) );    //Max. value of RGB
    CGFloat del_Max = var_Max - var_Min;             //Delta RGB value
    
    newHSL.lightness = ( var_Max + var_Min ) / 2.0f;
    
    if ( del_Max == 0 )                     //This is a gray, no chroma...
    {
        newHSL.hue = 0;                                //HSL results from 0 to 1
        newHSL.saturation = 0;
    }
    else                                    //Chromatic data...
    {
        if ( newHSL.lightness < 0.5f )
        {
            newHSL.saturation = del_Max / ( var_Max + var_Min );
        }
        else
        {
            newHSL.saturation = del_Max / ( 2.0f - var_Max - var_Min );
        }
                
        CGFloat del_R = ( ( ( var_Max - var_R ) / 6.0f ) + ( del_Max / 2.0f ) ) / del_Max;
        CGFloat del_G = ( ( ( var_Max - var_G ) / 6.0f ) + ( del_Max / 2.0f ) ) / del_Max;
        CGFloat del_B = ( ( ( var_Max - var_B ) / 6.0f ) + ( del_Max / 2.0f ) ) / del_Max;
        
        if ( var_R == var_Max )
        {
            newHSL.hue = del_B - del_G;
        }
        else if ( var_G == var_Max )
        {
            newHSL.hue = ( 1.0f / 3.0f ) + del_R - del_B;
        }
        else if ( var_B == var_Max ) 
        {
            newHSL.hue = ( 2.0f / 3.0f ) + del_G - del_R;
        }
                            
        if ( newHSL.hue < 0.0f )
        {
            newHSL.hue += 1.0f;
        }
        
        if ( newHSL.hue > 1.0f )
        {
            newHSL.hue -= 1;
        }
    }
    
    return newHSL;
}

-(RGB*)convertToRGBfromLAB:(LAB*)lab
{
    // Calculate XYZ
    CGFloat var_Y = ( lab.l + 16.0f ) / 116.0f;
    CGFloat var_X = lab.a / 500.0f + var_Y;
    CGFloat var_Z = var_Y - lab.b / 200.0f;
     
    if ( powf(var_Y, 3.0f) > 0.008856f )
    {
        var_Y = powf(var_Y, 3.0f);
    }
    else
    {
        var_Y = ( var_Y - 16.0f / 116.0f ) / 7.787f;
    }
     
    if ( powf(var_X, 3.0f) > 0.008856f )
    {
        var_X = powf(var_X, 3.0f);
    }
    else
    {
        var_X = ( var_X - 16.0f / 116.0f ) / 7.787f;
    }
     
    if ( powf(var_Z, 3.0f) > 0.008856f )
    {
        var_Z = powf(var_Z, 3.0f);
    }
    else
    {
        var_Z = ( var_Z - 16.0f / 116.0f ) / 7.787f;
    }
     
    CGFloat X = 95.047f * var_X;     //ref_X =  95.047     Observer= 2°, Illuminant= D65
    CGFloat Y = 100.0f * var_Y;     //ref_Y = 100.000
    CGFloat Z = 108.883f * var_Z;     //ref_Z = 108.883
    
    var_X = X / 100.0f;        //X from 0 to  95.047      (Observer = 2°, Illuminant = D65)
    var_Y = Y / 100.0f;        //Y from 0 to 100.000
    var_Z = Z / 100.0f;        //Z from 0 to 108.883
    
    CGFloat var_R = var_X *  3.2406f + var_Y * -1.5372f + var_Z * -0.4986f;
    CGFloat var_G = var_X * -0.9689f + var_Y *  1.8758f + var_Z *  0.0415f;
    CGFloat var_B = var_X *  0.0557f + var_Y * -0.2040f + var_Z *  1.0570f;
     
    if ( var_R > 0.0031308f ) 
    {
        var_R = 1.055f * ( powf(var_R, (1.0f / 2.4f)) ) - 0.055f;
    }
    else
    {
        var_R = 12.92f * var_R;
    }
      
    if ( var_G > 0.0031308f ) 
    {
        var_G = 1.055f * ( powf(var_G, (1.0f / 2.4f)) ) - 0.055f;
    }
    else
    {
        var_G = 12.92f * var_G;
    }
      
    if ( var_B > 0.0031308f ) 
    {
        var_B = 1.055f * ( powf(var_B, (1.0f / 2.4f)) ) - 0.055f;
    }
    else
    {
        var_B = 12.92f * var_B;
    }
     
    RGB *newRGB = [RGB new];
          
    newRGB.red = var_R;
    newRGB.green = var_G;
    newRGB.blue = var_B;
    
    return newRGB;
}

-(LAB*)convertToLABfromRGB:(RGB*)rgb
{
    CGFloat var_R = rgb.red;
    CGFloat var_G = rgb.green;
    CGFloat var_B = rgb.blue;
    
    if (var_R > 0.04045f) 
    {
        var_R = powf(( (var_R + 0.055f) / 1.055f), 2.4f);
    } 
    else 
    {
        var_R = var_R / 12.92f;
    }
    
    if (var_G > 0.04045f) 
    {
        var_G = powf(( (var_G + 0.055f) / 1.055f), 2.4f);
    } 
    else 
    {
        var_G = var_G / 12.92f;
    }
    
    if (var_B > 0.04045f) 
    {
        var_B = powf(( (var_B + 0.055f) / 1.055f), 2.4f);
    } 
    else 
    {
        var_B = var_B / 12.92f;
    }
    
    var_R = var_R * 100.0f;
    var_G = var_G * 100.0f;
    var_B = var_B * 100.0f;
    
    // Calculate XYZ
    CGFloat x = var_R * 0.4124f + var_G * 0.3576f + var_B * 0.1805f;
    CGFloat y = var_R * 0.2126f + var_G * 0.7152f + var_B * 0.0722f;
    CGFloat z = var_R * 0.0193f + var_G * 0.1192f + var_B * 0.9505f;
    
    // Calculate L*A*B* with Observer = 2°, Illuminant = D65
    CGFloat var_X = x / 95.047f;
    CGFloat var_Y = y / 100.0f;
    CGFloat var_Z = z / 108.883f;
    CGFloat pow = 1.0f / 3.0f;
    
    if ( var_X > 0.008856f )
    {
        var_X = powf(var_X, pow);
    }
    else
    {
        var_X = ( 7.787f * var_X ) + ( 16.0f / 116.0f );
    }
    
    if ( var_Y > 0.008856f )
    {
        var_Y = powf(var_Y, pow);
    }
    else
    {
        var_Y = ( 7.787f * var_Y ) + ( 16.0f / 116.0f );
    }
    
    if ( var_Z > 0.008856f )
    {
        var_Z = powf(var_Z, pow);
    }
    else
    {
        var_Z = ( 7.787f * var_Z ) + ( 16.0f / 116.0f );
    }
    
    LAB *newLAB = [LAB new];
    
    newLAB.l = ( 116.0f * var_Y ) - 16.0f;
    newLAB.a = 500.0f * ( var_X - var_Y );
    newLAB.b = 200.0f * ( var_Y - var_Z );
   
    return newLAB;
}

-(RGB*)mixWithColor:(RGB*)mixColor
{
    // Convert the colors to HSL
    HSL *myColorHSL = [self convertToHSLfromRGB:self.rgb];
    HSL *mixColorHSL = [self convertToHSLfromRGB:mixColor];
    
    // Mix the colors
    HSL *mixedHSL = [HSL new];
    
    mixedHSL.hue = MIN((myColorHSL.hue + mixColorHSL.hue) / 2.0f, 1.0f);
    mixedHSL.saturation = MIN((myColorHSL.saturation + mixColorHSL.saturation) / 2.0f, 1.0f);
    mixedHSL.lightness = MIN((myColorHSL.lightness + mixColorHSL.lightness) / 2.0f, 1.0f);
    
    // Convert back to RGB
    RGB *mixedRGB = [self convertToRGBfromHSL:mixedHSL];
    
    // Return
    return mixedRGB;
}

@end
