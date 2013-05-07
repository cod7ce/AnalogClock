//
//  DCShadow.m
//  desktopclocklit
//
//  Created by cod7ce on 12/12/11.
//  Copyright (c) 2011 纸房子. All rights reserved.
//

#import "DCShadow.h"
#import <math.h>

@implementation DCShadow

//@synthesize offset;

-(id)init
{
    self = [super init];
    if (self) {
        modulus = 0.4;
    }
    return self;
}

-(NSSize)changeOffsetWithAngle:(float)angle AndDepth:(int)depth
{
    float wRadians = (angle+45) * M_PI / 180;
    float hRadians = (angle-45) * M_PI / 180;
    float width   = depth * modulus;
    float height  = depth * modulus;
    float fWidth  = width  * sinf(wRadians);
    float fHeight = height * sinf(hRadians);
    
    NSSize tempSize = NSMakeSize(fWidth, fHeight);
    return tempSize;
}

@end
