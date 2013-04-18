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

//customize appearence

- (float)degrees2Radians:(float) degrees;

- (void)initLayerWithFrame:(NSRect)frame;

- (void)updateClock;

- (void)drawMyGithubName;

- (void)recaculateOriginSizeByFrame:(NSRect)frame;

- (void)resetOriginSize;

@end
