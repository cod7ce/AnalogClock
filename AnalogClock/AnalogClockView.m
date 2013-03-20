//
//  AnalogClockView.m
//  AnalogClock
//
//  Created by cipiglio on 3/21/13.
//  Copyright (c) 2013 cod7ce. All rights reserved.
//

#import "AnalogClockView.h"
#import "AnalogClockBackground.h"

@implementation AnalogClockView

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:1/30.0];
        [self initLayerWithFrame:frame];
        [self start];
    }
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
}

- (void)animateOneFrame
{
    return;
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

- (void)start
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateClock:) userInfo:nil repeats:YES];
}

- (void)stop
{
	[timer invalidate];
	timer = nil;
}

#define CONTAINER_WIDTH 877.0
#define CONTAINER_HEIGHT 877.0
#define HOUR_WIDTH 22.0
#define HOUR_HEIGHT 330.0
#define HOUR_WEI 90.0

#define MIN_WIDTH 21.0
#define MIN_HEIGHT 403.0
#define MIN_WEI 90.0

#define SEC_WIDTH 33.0
#define SEC_HEIGHT 355.0
#define SEC_WEI 81.0

- (void)initLayerWithFrame:(NSRect)frame
{
    shadowTool = [[DCShadow alloc] init];
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowBlurRadius:2.0];
    [shadow setShadowColor:[NSColor blackColor]];
    [shadow setShadowOffset:NSMakeSize(4.0, 10.0)];
    CGColorRef myShadowColor=CGColorCreateGenericRGB(0.0f,0.0f,0.0f,1.0f);
    containerLayer = [CALayer layer];
    /*
     NSImage *backgroundImage = [NSImage imageNamed:@"timebg2.jpg"];
     [backgroundImage setTemplate:YES];
     [backgroundImage setSize:NSMakeSize(240.0, 240.0)];
     [backgroundImage drawInRect:self.bounds
     fromRect:NSMakeRect(0.0, 0.0, 240.0, 240.0)
     operation:NSCompositeSourceAtop
     fraction:1.0];
     */
    //NSLog(@"")
    //containerLayer.contents = backgroundImage;
    containerLayer.contentsGravity = kCAGravityResizeAspect;
    
    backgroundLayer = [CALayer layer];
    NSRect containerFrame = NSMakeRect((frame.size.width-CONTAINER_WIDTH)/2, (frame.size.height-CONTAINER_HEIGHT)/2, CONTAINER_WIDTH, CONTAINER_HEIGHT);
    backgroundLayer.frame = containerFrame;
    //backgroundLayer.position = NSMakePoint(CONTAINER_WIDTH/2+15.0, CONTAINER_HEIGHT/2);
    backgroundLayer.anchorPoint = NSMakePoint(0.501, 0.5);
    
    hourHand = [CALayer layer];
    hourHand.position = CGPointMake((CONTAINER_WIDTH-HOUR_WIDTH)/2+17, CONTAINER_HEIGHT/2);
    hourHand.anchorPoint = NSMakePoint(0.5, 0.25);
    hourHand.bounds = NSMakeRect(0,0, HOUR_WIDTH, HOUR_HEIGHT);
    hourHand.shadowColor = myShadowColor;
    hourHand.shadowOffset = NSMakeSize(-3.0, 3.0);
    hourHand.shadowRadius = 1.5;
    hourHand.shadowOpacity = 0.4;
    
    minHand = [CALayer layer];
    minHand.position = CGPointMake(CONTAINER_WIDTH/2 - MIN_WIDTH/2+16, CONTAINER_HEIGHT/2);
    minHand.anchorPoint = NSMakePoint(0.5, 0.22);
    minHand.bounds = NSMakeRect(0, 0, MIN_WIDTH, MIN_HEIGHT);
    minHand.shadowColor = myShadowColor;
    minHand.shadowOffset = NSMakeSize(-4.0, 4.0);
    minHand.shadowRadius = 1.5;
    minHand.shadowOpacity = 0.4;
    
    secHand = [CALayer layer];
    secHand.position = CGPointMake((CONTAINER_WIDTH-SEC_WIDTH)/2+22.0, CONTAINER_HEIGHT/2);
    secHand.anchorPoint = NSMakePoint(0.5, SEC_WEI/SEC_HEIGHT);
    secHand.bounds = NSMakeRect(0, 0, SEC_WIDTH, SEC_HEIGHT);
    secHand.shadowColor = myShadowColor;
    secHand.shadowOffset = NSMakeSize(-5.0, 5.0);
    secHand.shadowRadius = 1.5;
    secHand.shadowOpacity = 0.4;
    
    CGColorRelease(myShadowColor);
    
    //default appearance
    [self setClockBackgroundImage:[NSImage imageNamed:@"panel.png"]];
    [self setHourHandImage:[NSImage imageNamed:@"hour.png"]];
    [self setMinHandImage:[NSImage imageNamed:@"min.png"]];
    [self setSecHandImage:[NSImage imageNamed:@"second.png"]];
    
    //add all created sublayers
    [backgroundLayer addSublayer:hourHand];
    [backgroundLayer addSublayer:minHand];
    [backgroundLayer addSublayer:secHand];
    [containerLayer addSublayer:backgroundLayer];
    [self setLayer:containerLayer];
    [self setWantsLayer:YES];
}

- (void)setHourHandImage:(NSImage *)image
{
    hourHand.contents = image;
}

- (void)setMinHandImage:(NSImage *)image
{
	minHand.contents = image;
}

- (void)setSecHandImage:(NSImage *)image
{
    secHand.contents = image;
}

- (void)setClockBackgroundImage:(NSImage *)image
{
    backgroundLayer.contents = image;
}

- (float)degrees2Radians:(float) degrees;
{
    return degrees * M_PI / 180;
}

//timer callback
- (void) updateClock:(NSTimer *)theTimer
{
	NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[NSDate date]];
	NSInteger seconds = [dateComponents second];
	NSInteger minutes = [dateComponents minute];
	NSInteger hours = [dateComponents hour];
	//NSLog(@"raw: hours:%d min:%d secs:%d", hours, minutes, seconds);
	if (hours > 12) hours -=12; //PM
    
	//set angles for each of the hands
	CGFloat secAngle = [self degrees2Radians:(seconds/60.0*360+180)];
	CGFloat minAngle = [self degrees2Radians:(minutes/60.0*360+180)];
	CGFloat hourAngle = [self degrees2Radians:(hours/12.0*360+180)]+ [self degrees2Radians:(minutes/60.0*360)]/12.0;
    
    //set shadowOffset for
    secHand.shadowOffset = [shadowTool changeOffsetWithAngle:seconds/60.0*360 AndDepth:20];
    minHand.shadowOffset = [shadowTool changeOffsetWithAngle:minutes/60.0*360 AndDepth:18];
    hourHand.shadowOffset= [shadowTool changeOffsetWithAngle:(hours/12.0*360+(minutes/60.0*360)/12) AndDepth:16];
    
	//reflect the rotations + 180 degres since CALayers coordinate system is inverted
	secHand.transform   = CATransform3DMakeRotation (M_PI-secAngle, 0, 0, 1);
	minHand.transform   = CATransform3DMakeRotation (M_PI-minAngle, 0, 0, 1);
	hourHand.transform  = CATransform3DMakeRotation (M_PI-hourAngle, 0, 0, 1);
}


@end
