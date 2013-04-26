//
//  AnalogClockView.h
//  AnalogClock
//
//  Created by cipiglio on 3/21/13.
//  Copyright (c) 2013 cod7ce. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>
#import <QuartzCore/QuartzCore.h>
#import "DCShadow.h"
#import "AnalogClockBackground.h"

@interface AnalogClockView : ScreenSaverView
{
    CALayer *containerLayer;
    AnalogClockBackground *backgroundLayer;
    CALayer *clockLayer;
    CALayer *hourHand;
	CALayer *minHand;
	CALayer *secHand;
    NSTimer *timer;
    
    DCShadow *shadowTool;
    
    IBOutlet NSWindow    *configureSheet;
    IBOutlet NSMatrix    *selfPathRadios;
    IBOutlet NSTextField *urlField;
    IBOutlet NSButton    *recursionChecker;
    IBOutlet NSButton    *editorPanelChecker;
}

//customize appearence

- (float)degrees2Radians:(float) degrees;

- (void)initLayerWithFrame:(NSRect)frame;

- (void)updateClock;

- (void)drawMyGithubName;

- (void)recaculateOriginSizeByFrame:(NSRect)frame;

- (void)resetOriginSize;

@end
