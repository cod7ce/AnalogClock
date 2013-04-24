//
//  AnalogClockBackground.m
//  desktopclocklit
//
//  Created by cod7ce on 12/13/11.
//  Copyright (c) 2011 纸房子. All rights reserved.
//

#import "AnalogClockBackground.h"

@implementation AnalogClockBackground

float ratio = 0.3f;
int order = 0;

@synthesize imgArray;

- (id)initWithPath:(NSString *)path
{
    self = [super init];
    if (self)
    {
        self.imgArray = [NSMutableArray array];
        fileManager = [NSFileManager defaultManager];
        [self getImagesByPath:path WeatherRecursion:NO];
    }
    return self;
}

- (void)getImagesByPath:(NSString *)dir WeatherRecursion:(Boolean) recursion
{
    NSArray *dirArray = [fileManager contentsOfDirectoryAtPath:dir error:nil];
    BOOL isDir = NO;
    for (NSString *file in dirArray)
    {
        NSString *path = [dir stringByAppendingPathComponent:file];
        [fileManager fileExistsAtPath:path isDirectory:(&isDir)];
        if (isDir)
        {
            if (recursion)
            {
                [self getImagesByPath:path WeatherRecursion:recursion];
            }
        }
        else
        {
            if ([self isImageExtend:path])
            {
                
                NSImageRep *imgObj = [NSImageRep imageRepWithContentsOfFile:path];
                NSImage * image = [[NSImage alloc] initWithSize:[self makeSuitableSizeWithOriginSize:NSMakeSize([imgObj pixelsWide], [imgObj pixelsHigh])]];
                [image addRepresentation:imgObj];
                [imgArray addObject:image];
            }
        }
        isDir = NO;
    }
}

- (void)start
{
    [self kenBurns:nil];
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(kenBurns:) userInfo:nil repeats:YES];
}

- (void)kenBurns:(NSTimer *)timer
{
    if (order >= self.imgArray.count){
        order = 0;
    }
    [self removeAllAnimations];
    NSImage *img = [self.imgArray objectAtIndex:order];
    float x = ([NSScreen mainScreen].frame.size.width - img.size.width) / 2;
    float y = ([NSScreen mainScreen].frame.size.height - img.size.height) / 2;
    self.frame = NSMakeRect(x, y, img.size.width, img.size.height);
    
    int ratiox   = arc4random() % (int)2*x;
    int ratioy   = arc4random() % (int)2*y;
    CABasicAnimation *f = [BasicAnimationFatory movepoint:CGPointMake(ratiox, ratioy)];
    
    int seed     = arc4random() % 5;
    int inorout  = arc4random() % 2;
    float scale  = inorout == 0 ? 1.0f : (1.0f+seed*0.1f);
    float origin = inorout == 1 ? 1.0f : (1.0f+seed*0.1f);
    
    CABasicAnimation *m = [BasicAnimationFatory scale:[NSNumber numberWithFloat:scale]
                                                orgin:[NSNumber numberWithFloat:origin]
                                             duration:10.0f
                                                  Rep:1];
    //CABasicAnimation *o = [BasicAnimationFatory opacityTimes_Animation:1 duration:10.0];
    [self addAnimation:f forKey:@"move"];
    [self addAnimation:m forKey:@"scale"];
    //[self addAnimation:o forKey:@"opacity"];
    self.contents =  img;
    order++;
}

- (void)dealloc
{
    [self.imgArray release];
    [fileManager release];
    [timer invalidate];
    [timer release];
    [super dealloc];
}

// 判断是否是图片（通过后缀判断）
-(BOOL)isImageExtend:(NSString *)path
{
    BOOL flag = NO;
    NSArray*  extends		= [[path lastPathComponent] componentsSeparatedByString:@"."];
    NSString* extend        = [extends objectAtIndex:[extends count] - 1];
    if([extend isEqualToString:@"jpg"] || [extend isEqualToString:@"png"] )
    {
        flag = YES;
    }
    return flag;
}

- (NSSize)makeSuitableSizeWithOriginSize:(NSSize) originsize
{
    NSSize screensize = [NSScreen mainScreen].frame.size;
    float diffw = originsize.width - screensize.width;
    float diffh = originsize.height - screensize.height;
    
    if ( diffw <= ratio*screensize.width || diffh <= ratio*screensize.height)
    {
        return originsize;
    }
    else
    {
        float tmpw, tmph;
        if (diffw <= diffh)
        {
            tmpw = screensize.width*(1+ratio);
            tmph = (originsize.height*tmpw)/originsize.width;
        }
        else
        {
            tmph = screensize.height*(1+ratio);
            tmpw = (originsize.width*tmph)/originsize.height;
        }
        return NSMakeSize(tmpw, tmph);
    }
}


@end
