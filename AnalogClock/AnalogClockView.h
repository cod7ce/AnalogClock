//
//  AnalogClockView.h
//  AnalogClock
//
//  Created by cipiglio on 3/21/13.
//  Copyright (c) 2013 cod7ce. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>
#import "DCShadow.h"

@interface AnalogClockView : ScreenSaverView
{
    CALayer *containerLayer;
    CALayer *backgroundLayer;
    CALayer *hourHand;
	CALayer *minHand;
	CALayer *secHand;
	NSTimer *timer;
    
    DCShadow *shadowTool;
}

//basic methods
- (void)start;
- (void)stop;

//customize appearence
- (void)setHourHandImage:(NSImage *)image;
- (void)setMinHandImage:(NSImage *)image;
- (void)setSecHandImage:(NSImage *)image;
- (void)setClockBackgroundImage:(NSImage *)image;

- (float)degrees2Radians:(float) degrees;

- (void)initLayerWithFrame:(NSRect)frame;
- (void)enterToFullScreen;

@end
