//
//  AnalogClockView.m
//  AnalogClock
//
//  Created by cipiglio on 3/21/13.
//  Copyright (c) 2013 cod7ce. All rights reserved.
//

#import "AnalogClockView.h"
//#import "AnalogClockBackground.h"

@implementation AnalogClockView

float CONTAINER_WIDTH = 877.0;
float CONTAINER_HEIGHT = 877.0;

float HOUR_WIDTH = 22.0;
float HOUR_HEIGHT = 330.0;
float HOUR_DRIFT = 17.0;
float HOUR_WEI = 90.0;

float MIN_WIDTH = 21.0;
float MIN_HEIGHT = 403.0;
float MIN_DRIFT = 16.0;
float MIN_WEI  = 90.0;

float SEC_WIDTH  = 33.0;
float SEC_HEIGHT  = 355.0;
float SEC_DRIFT  = 22.0;
float SEC_WEI  = 81.0;

int ss = 0;
- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        shadowTool = [[DCShadow alloc] init];
        [self setAnimationTimeInterval:1.0];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithFrame:NSZeroRect isPreview:NO];
}

- (void)startAnimation
{
    [super startAnimation];
    [self initLayerWithFrame: self.frame];
    
}
- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
    
}

- (void)animateOneFrame
{
    [self updateClock];
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}


- (void)initLayerWithFrame:(NSRect)frame
{
    [self recaculateOriginSizeByFrame:frame];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bg     = @"/Users/cipiglio/Pictures/Wallpaper/Zebras.jpg";//[bundle pathForResource:@"Zebras" ofType:@"jpg"];
    NSString *clock  = [bundle pathForResource:@"panel" ofType:@"png"];
    NSString *hour   = [bundle pathForResource:@"hour" ofType:@"png"];
    NSString *min    = [bundle pathForResource:@"min" ofType:@"png"];
    NSString *sec    = [bundle pathForResource:@"second" ofType:@"png"];
    
    //*
    CGColorRef myShadowColor=CGColorCreateGenericRGB(0.0f,0.0f,0.0f,1.0f);
    
    containerLayer = [CALayer layer];
    containerLayer.backgroundColor = CGColorCreateGenericRGB(0.7f, 0.1f, 0.5f, 1.0f);
    containerLayer.bounds = frame;
    
    // ----------------------------------------------------------------------------------
    backgroundLayer = [CALayer layer];
    backgroundLayer.contentsGravity = kCAGravityResizeAspect;
    NSImageRep *imgObj = [NSImageRep imageRepWithContentsOfFile:bg];    
    //backgroundLayer.frame = NSMakeRect(frame.origin.x, frame.origin.y, [imgObj pixelsWide], [imgObj pixelsHigh]);
    NSScreen *screen = [NSScreen mainScreen];
    float xx = screen.frame.size.width  - [imgObj pixelsWide];
    float yy = screen.frame.size.height - [imgObj pixelsHigh];
    
    float randomx = SSRandomFloatBetween(xx/3, 0.0);
    float randomy = SSRandomFloatBetween(yy/3, 0.0);
    
    NSRect randomFrame = NSMakeRect(-200,
                                    -200,
                                    1920,
                                    1600);
    backgroundLayer.frame = randomFrame;//NSMakeRect(0.0, 0.0, [imgObj pixelsWide], [imgObj pixelsHigh]);
    
    //backgroundLayer.frame = randomFrame;
    
    NSImage *bgi = [[NSImage alloc] initWithSize:randomFrame.size];
    [bgi addRepresentation:imgObj];
    backgroundLayer.contents = bgi;
    // ----------------------------------------------------------------------------------
    
    clockLayer = [CALayer layer];
    NSRect containerFrame = NSMakeRect((frame.size.width-CONTAINER_WIDTH)/2, (frame.size.height-CONTAINER_HEIGHT)/2, CONTAINER_WIDTH, CONTAINER_HEIGHT);
    clockLayer.frame = containerFrame;
    //clockLayer.position = NSMakePoint(CONTAINER_WIDTH/2+15.0, CONTAINER_HEIGHT/2);
    clockLayer.anchorPoint = NSMakePoint(0.501, 0.5);
    
    hourHand = [CALayer layer];
    hourHand.position = CGPointMake((CONTAINER_WIDTH-HOUR_WIDTH)/2+HOUR_DRIFT, CONTAINER_HEIGHT/2);
    hourHand.anchorPoint = NSMakePoint(0.5, 0.25);
    hourHand.bounds = NSMakeRect(0,0, HOUR_WIDTH, HOUR_HEIGHT);
    hourHand.shadowColor = myShadowColor;
    hourHand.shadowOffset = NSMakeSize(-3.0, 3.0);
    hourHand.shadowRadius = 1.5;
    hourHand.shadowOpacity = 0.4;
    
    minHand = [CALayer layer];
    minHand.position = CGPointMake((CONTAINER_WIDTH - MIN_WIDTH)/2+MIN_DRIFT, CONTAINER_HEIGHT/2);
    minHand.anchorPoint = NSMakePoint(0.5, 0.22);
    minHand.bounds = NSMakeRect(0, 0, MIN_WIDTH, MIN_HEIGHT);
    minHand.shadowColor = myShadowColor;
    minHand.shadowOffset = NSMakeSize(-4.0, 4.0);
    minHand.shadowRadius = 1.5;
    minHand.shadowOpacity = 0.4;
    
    secHand = [CALayer layer];
    secHand.position = CGPointMake((CONTAINER_WIDTH-SEC_WIDTH)/2+SEC_DRIFT, CONTAINER_HEIGHT/2);
    secHand.anchorPoint = NSMakePoint(0.5, 0.23);
    secHand.bounds = NSMakeRect(0, 0, SEC_WIDTH, SEC_HEIGHT);
    secHand.shadowColor = myShadowColor;
    secHand.shadowOffset = NSMakeSize(-5.0, 5.0);
    secHand.shadowRadius = 1.5;
    secHand.shadowOpacity = 0.4;
    
    CGColorRelease(myShadowColor);
    
    //default appearance
    clockLayer.contents = [[NSImage alloc] initWithContentsOfFile:clock];
    hourHand.contents = [[NSImage alloc] initWithContentsOfFile:hour];
    minHand.contents = [[NSImage alloc] initWithContentsOfFile:min];
    secHand.contents = [[NSImage alloc] initWithContentsOfFile:sec];
    
    //add all created sublayers
    [clockLayer addSublayer:hourHand];
    [clockLayer addSublayer:minHand];
    [clockLayer addSublayer:secHand];
    
    [containerLayer addSublayer:backgroundLayer];
    [containerLayer addSublayer:clockLayer];
    [self setLayer:containerLayer];
    [self setWantsLayer:YES];
    //*/
    [self resetOriginSize];
}

- (float)degrees2Radians:(float) degrees;
{
    return degrees * M_PI / 180;
}

- (void) updateClock
{
    ss++;
	NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)
                                                                       fromDate:[NSDate date]];
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
    if(ss == 1)
    {
        CABasicAnimation *f = [BasicAnimationFatory movepoint:CGPointMake(-100.0f, -100.0f)];
        CABasicAnimation *m = [BasicAnimationFatory scale:[NSNumber numberWithFloat:1.3f] orgin:[NSNumber numberWithFloat:1.0f] duration:15.0f Rep:FLT_MAX];
        [backgroundLayer addAnimation:f forKey:@"move"];
        [backgroundLayer addAnimation:m forKey:@"scale"];
    }
}

- (void)recaculateOriginSizeByFrame:(NSRect)frame
{
    if (frame.size.width < CONTAINER_WIDTH || frame.size.height < CONTAINER_HEIGHT) {
        float widthRatio  = frame.size.width/CONTAINER_WIDTH;
        float heightRatio = frame.size.height/CONTAINER_HEIGHT;
        float ratio = widthRatio > heightRatio ? heightRatio : widthRatio;
        
        CONTAINER_WIDTH *= ratio;
        CONTAINER_HEIGHT *= ratio;

        HOUR_WIDTH *= ratio;
        HOUR_HEIGHT *= ratio;
        HOUR_DRIFT  *= ratio;
        
        MIN_WIDTH *= ratio;
        MIN_HEIGHT *= ratio;
        MIN_DRIFT *= ratio;
        
        SEC_WIDTH  *= ratio;
        SEC_HEIGHT  *= ratio;
        SEC_DRIFT *= ratio;

    }
}

- (void)resetOriginSize
{
    CONTAINER_WIDTH = 877.0;
    CONTAINER_HEIGHT = 877.0;
    
    HOUR_WIDTH = 22.0;
    HOUR_HEIGHT = 330.0;
    HOUR_DRIFT = 17.0;
    HOUR_WEI = 90.0;
    
    MIN_WIDTH = 21.0;
    MIN_HEIGHT = 403.0;
    MIN_DRIFT = 16.0;
    MIN_WEI  = 90.0;
    
    SEC_WIDTH  = 33.0;
    SEC_HEIGHT  = 355.0;
    SEC_DRIFT  = 22.0;
    SEC_WEI  = 81.0;

}

- (void) drawMyGithubName
{
    int width = [self frame].size.width;
    // int height = [self frame].size.height;
    
    NSPoint pt = NSMakePoint(width - 200, 10);
    float strSize = 18.f;
    
    //NSColor *back = [NSColor blackColor];
    //NSRect rect = NSMakeRect(width-210, 10, 200, 40);
    
    NSColor *color = [NSColor redColor];
    
    //NSDate *currentDate = [NSDate date];
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy:MM:dd HH:mm:ss:SSS"];
    //NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Paper, cod7ce@gmail.com"];
    [str addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Times" size:strSize] range:NSMakeRange(0, 23)];
    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, 23)];
    
    //[[NSColor redColor] set];
    //[NSBezierPath fillRect:rect];
    
    
    [str drawAtPoint:pt];
}

@end
