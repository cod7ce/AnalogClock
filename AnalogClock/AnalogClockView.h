//
//  AnalogClockView.h
//  AnalogClock
//
//  Created by cod7ce on 3/21/13.
//  Copyright (c) 2013 纸房子. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>
#import <QuartzCore/QuartzCore.h>
#import "DCShadow.h"
#import "AnalogClockBackground.h"

@interface AnalogClockView : ScreenSaverView
{
    CALayer *containerLayer;
    AnalogClockBackground *backgroundLayer;
    CALayer *editorLayer;
    CALayer *clockLayer;
    CALayer *hourHand;
	CALayer *minHand;
	CALayer *secHand;
    NSTimer *timer;
    
    DCShadow *shadowTool;
    
    // Settings Panel
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

- (void)showEditorLayer;

- (void)recaculateOriginSizeByFrame:(NSRect)frame;

- (void)resetOriginSize;

@end
