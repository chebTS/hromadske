//
//  NSDateUtil.m
//  friendsNavApp
//
//  Created by Comonitos on 24.01.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <sys/utsname.h>
@implementation Utils

#pragma mark - Dates
+ (NSDateFormatter *)df
{
    static NSDateFormatter *__df = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __df = [[NSDateFormatter alloc] init];
    });
    
    return __df;
}
+ (NSString *) timeStringFormSeconds:(float)secondsTime {
    int minutes = floor(secondsTime/59);
    int seconds = round(secondsTime - minutes * 59);
    
    NSString *min = [NSString stringWithFormat:@"%d",minutes];
    NSString *sec = [NSString stringWithFormat:@"%d",seconds];
    if (minutes<10 && minutes >= 0) {
        min = [NSString stringWithFormat:@"0%@",min];
    }
    if (seconds<10 && seconds >= 0) {
        sec = [NSString stringWithFormat:@"0%@",sec];
    }
    
    return [NSString stringWithFormat:@"%@:%@",min,sec];
}

+ (NSString *) stringFromDate:(NSDate *)date withFormat:(NSString *)format
{
    [[Utils df] setDateFormat:format];
    NSString *dateFromString = [[Utils df] stringFromDate:date];
    return dateFromString;
}

+ (NSDate *) dateFromString:(NSString *)string withFormat:(NSString *)format
{
    [[Utils df] setDateFormat:format];
    NSDate *dateFromString = [[Utils df] dateFromString:string];
    return dateFromString;
}





+ (NSDate *) dateFromEventString:(NSString *)string
{
    [[Utils df] setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateFromString = [[Utils df] dateFromString:string];
//    NSLog(@"%@ dddddd %@",dateFromString,string);
    return dateFromString;
}
+ (NSDate *) dateFromSeminarString:(NSString *)string
{
    [[Utils df] setDateFormat:@"MM/dd/yyyy"];
    NSDate *dateFromString = [[Utils df] dateFromString:string];
    return dateFromString;
}
+ (NSDate *) dateFromTSString:(NSTimeInterval)ts
{

    return [NSDate dateWithTimeIntervalSince1970:ts];
}
+ (NSString *) stringHoursFromDate:(NSDate *)date
{
	[[Utils df] setDateFormat:@"HH"];
	
	NSString *stringFromDate = [[Utils df] stringFromDate:date];
	
	return stringFromDate;
}
+ (int) getHoversToPastDate:(NSDate *)date
{
	NSTimeInterval timeInt = [[NSDate date] timeIntervalSinceDate:date];
	int hours = (int) timeInt/3600;
	return hours;
}
+(NSDate *) date 
{
	return [NSDate date];
}
    
+ (NSString *) timeToEventHumanRecognizable:(NSDate *)eventDate eventName:(NSString *)name {
	
    if (eventDate == nil)
        return @"";
    
	NSTimeInterval timeInt = [[NSDate date] timeIntervalSinceDate:eventDate];
	NSTimeInterval timeIntNow = [[NSDate date] timeIntervalSinceNow];
	
	int interval = (int)(timeInt - timeIntNow);
	
	int hours = interval/-3600;
	int minutes = interval/-60;
	int days = interval/(-3600*24);
	int weeks = interval/(-3600*24*7);
	int month = interval/(-3600*24*30);
	
	int toMinutes = (minutes)-(hours*60);
	int toHours = hours-(days*24);
		
	if (name == nil) {
		if (hours < 24) {
            return @"Today";
            
			if (hours == 1) {
				return [NSString stringWithFormat:@"1 hour %d minutes left",toMinutes];
			} else if (hours < 1) {
				return [NSString stringWithFormat:@"%d minutes left",toMinutes];
			}
			
            return [NSString stringWithFormat:@"%d hours %d minutes left",hours,toMinutes];
            
		} else if (hours >= 24 && weeks <= 1)
		{
			if(days == 1) 
			{
				return [NSString stringWithFormat:@"%d day %d hours left",days,toHours];
			}
			return [NSString stringWithFormat:@"%d days %d hours left",days,toHours];
		} else if (weeks > 1 && weeks <= 4) {
			return [NSString stringWithFormat:@"%d weeks left",weeks];
		} else {
            if (month==1) 
                return [NSString stringWithFormat:@"1 month left"];
            else 
                return [NSString stringWithFormat:@"%d months left",month];
		}	
	} else {
		if (hours < 24) {
            return @"Today";

			if (hours == 1) {
				return [NSString stringWithFormat:@"1 hour %d minutes left to %@",toMinutes,name];
			} else if (hours < 1) {
				return [NSString stringWithFormat:@"%d minutes left to %@",toMinutes,name];
			}
			return [NSString stringWithFormat:@"%d hours %d minutes left to %@",hours,toMinutes,name];
		} else if (hours >= 24 && weeks <= 1)
		{
			if(days == 1) 
			{
				return [NSString stringWithFormat:@"%d day %d hours left to %@",days,toHours,name];
			}
			return [NSString stringWithFormat:@"%d days %d hours left to %@",days,toHours,name];
		} else if (weeks > 1 && weeks <= 4) {
			if (weeks==1) {
				return [NSString stringWithFormat:@"%@ in %d week",name,weeks];
			}
			return [NSString stringWithFormat:@"%@ in %d weeks",name,weeks];
		} else {
            if (month==1) 
                return [NSString stringWithFormat:@"%@ in 1 month",name];
            else 
                return [NSString stringWithFormat:@"%@ in %d months",name,month];
		}	
	}
}
+ (NSString *) stringHumanRecognizableFromDate:(NSDate *)eventDate 
{
    if (eventDate == nil)
        return @"";

//    NSLog(@"%@",eventDate);
    BOOL future = NO;

	NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:eventDate];
	if (interval < 0 )
    {
        future = YES;
        interval = (-1) *interval;
    }
    
	int hours = interval/3600;
	int minutes = interval/60;
	int days = interval/(3600*24);
	int weeks = interval/(3600*24*7);
	int month = interval/(3600*24*30);
	
	int toMinutes = (minutes)-(hours*60);

    NSString *result = @"";
    
    if (hours < 24) {
        if (hours == 1) {
            result = [NSString stringWithFormat:@"година %d хв.",toMinutes];
        } else if (hours < 1) {
            result = [NSString stringWithFormat:@"%d хв.",toMinutes];
        } else 
            result = [NSString stringWithFormat:@"%d год. %d хв.",hours,toMinutes];
    } else if (hours >= 24 && weeks <= 1)
    {
        if(days == 1) 
        {
            result = [NSString stringWithFormat:@"Вчора"];
        } else 
            result = [NSString stringWithFormat:@"%d дн.",days];
    } else if (weeks == 1) {
        result = [NSString stringWithFormat:@"Тиждень"];
    } else {
        if (month == 0)
        {
            result = [NSString stringWithFormat:@"%d тиж.",weeks];
        } else if (month == 1) 
            result = [NSString stringWithFormat:@"1 місяць"];
        else 
            result = [NSString stringWithFormat:@"%d міс.",month];
    }
    
    if (future)
        result = [NSString stringWithFormat:@"через %@",result];
    else 
        result = [result stringByAppendingString:@" тому"];

    return result;
}

+ (NSString *) timeShortToEventHumanRecognizable:(NSDate *)eventDate
{
	
	NSTimeInterval timeInt = [[NSDate date] timeIntervalSinceDate:eventDate];
	NSTimeInterval timeIntNow = [[NSDate date] timeIntervalSinceNow];
	
	int interval = (int)(timeInt - timeIntNow);
	
	int hours = interval/-3600;
	int days = interval/(-3600*24);
    if (days > 0)
    {
        return [NSString stringWithFormat:@"+%d d",days];
    } 
        else if ( hours < 24 && [[Utils stringHoursFromDate:[NSDate date]] intValue] + hours > 24)
    {
        return [NSString stringWithFormat:@"+1 d"];
    } else {
        return @"Today";
    }
    
}


+ (NSString *) timeExactHumanRecognizible:(NSDate *)eventDate
{
	[[Utils df] setDateFormat:@"d MMMM HH:mm"];
	NSString *stringFromDate = [[Utils df] stringFromDate:eventDate];

	return stringFromDate;
}



#pragma mark -
#pragma mark Scale and crop image
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)targetSize 
{
	UIImage *sourceImage = image;
	UIImage *newImage = nil;        
	CGSize imageSize = sourceImage.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	
	if (CGSizeEqualToSize(imageSize, targetSize) == NO) 
	{
		CGFloat widthFactor = targetWidth / width;
		CGFloat heightFactor = targetHeight / height;
		
		if (widthFactor > heightFactor) 
			scaleFactor = widthFactor; // scale to fit height
		else
			scaleFactor = heightFactor; // scale to fit width
		scaledWidth  = width * scaleFactor;
		scaledHeight = height * scaleFactor;
		
		// center the image
		if (widthFactor > heightFactor)
		{
			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
		}
		else 
			if (widthFactor < heightFactor)
			{
				thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
			}
	}       
	
	UIGraphicsBeginImageContext(targetSize); // this will crop
	
	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;
	
	[sourceImage drawInRect:thumbnailRect];
	
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	if(newImage == nil) 
		NSLog(@"could not scale image");
	
	//pop the context to get back to the default
	UIGraphicsEndImageContext();
	return newImage;
}
+ (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect
{
	////////////////////////////////////
	
	//create a context to do our clipping in
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef currentContext = UIGraphicsGetCurrentContext();
	
	//create a rect with the size we want to crop the image to
	//the X and Y here are zero so we start at the beginning of our
	//newly created context
	CGRect clippedRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
	CGContextClipToRect( currentContext, clippedRect);
	
	//create a rect equivalent to the full size of the image
	//offset the rect by the X and Y we want to start the crop
	//from in order to cut off anything before them
	CGRect drawRect = CGRectMake(rect.origin.x * -1,
								 rect.origin.y * -1,
								 imageToCrop.size.width,
								 imageToCrop.size.height);
	
	//draw the image to our clipped context using our offset rect
	CGContextDrawImage(currentContext, drawRect, imageToCrop.CGImage);
	
	//pull the image from our cropped context
	UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();
	
	//pop the context to get back to the default
	UIGraphicsEndImageContext();
	
	//Note: this is autoreleased
	return cropped;
}
+ (UIImageView *) addCorners:(UIImageView *)view withSize:(float)size borders:(float)bsize andColor:(UIColor *)color 
{
	// Get the Layer of any view
	CALayer * l = [view layer];
	[l setMasksToBounds:YES];
	[l setCornerRadius:size];
	
	// You can even add a border
	[l setBorderWidth:bsize];
	[l setBorderColor:[color CGColor]];
	
	return view;
}
+ (void) addCornersToLayer:(CALayer *)layer withSize:(float)size borders:(float)bsize andColor:(UIColor *)color
{
	// Get the Layer of any view
	CALayer * l = layer;
	[l setMasksToBounds:YES];
	[l setCornerRadius:size];
	
	// You can even add a border
	[l setBorderWidth:bsize];
	[l setBorderColor:[color CGColor]];
}

#pragma mark - Images
void addRoundedRectToPathTopBottom(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight,BOOL top)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);

    if (top) {
        CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 9);
        CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 9);
        CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 0);
        CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 0);
    } else {
        CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 0);
        CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 0);
        CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 9);
        CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 9);
    }

    CGContextClosePath(context);
    CGContextRestoreGState(context);
}
+ (UIImage *) roundCornersOfImage:(UIImage *)source size:(int)size top:(BOOL)yes {
    int w = source.size.width;
    int h = source.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextBeginPath(context);
    CGRect rect = CGRectMake(0, 0, w, h);
    addRoundedRectToPathTopBottom(context, rect, size, size,yes);
    CGContextClosePath(context);
    CGContextClip(context);
    
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), source.CGImage);
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *processedImage = [UIImage imageWithCGImage:imageMasked];
    CGImageRelease(imageMasked);
    
    return processedImage;    
}

void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 0);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 9);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 9);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 9);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+ (NSArray*)getRGBAsFromImage:(UIImage*)image atX:(int)xx andY:(int)yy count:(int)count
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
    
    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    NSUInteger byteIndex = (bytesPerRow * yy) + xx * bytesPerPixel;
    for (int ii = 0 ; ii < count ; ++ii)
    {
        CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
        CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
        CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
        CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
        byteIndex += 4;
        
        UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        [result addObject:acolor];
    }
    
    free(rawData);
    
    return result;
}

+ (void) bezierRoundedCornersforView:(UIView *)view {

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds 
                                                   byRoundingCorners:UIRectCornerAllCorners
                                                         cornerRadii:CGSizeMake(8, 8)];
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    
    // Set the newly created shape layer as the mask for the image view's layer
    view.layer.mask = maskLayer;
}

+ (UIImage *) roundCornersOfImage:(UIImage *)source size:(int)size {
    int w = source.size.width;
    int h = source.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextBeginPath(context);
    CGRect rect = CGRectMake(0, 0, w, h);
    addRoundedRectToPath(context, rect, size, size);
    CGContextClosePath(context);
    CGContextClip(context);
    
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), source.CGImage);
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *proccesedImage = [UIImage imageWithCGImage:imageMasked];
    CGImageRelease(imageMasked);
    
    return proccesedImage;    
}
+ (void) clearRoundedCornersOfView:(UIView *)viev {
    [viev setOpaque:YES];
    
    CALayer * l = [viev layer];
	[l setMasksToBounds:NO];
	[l setCornerRadius:0];
    [l setShouldRasterize:YES];
    [l setRasterizationScale:[UIScreen mainScreen].scale];
}
+ (void) addRoundedCornersOfView:(UIView *)viev withRadious:(int)size
{
//    [viev setOpaque:YES];
    
    CALayer * l = [viev layer];
    int rad = l.cornerRadius;

    if (rad == size) {
        return;
    }

	[l setMasksToBounds:YES];
	[l setCornerRadius:size];
    [l setShouldRasterize:YES];
    [l setRasterizationScale:[UIScreen mainScreen].scale];
}
+ (void) addShadowForView:(UIView *)viev withRadious:(int)size andColor:(UIColor *)color opacity:(float)o
{
    CALayer * l = [viev layer];
	[l setMasksToBounds:NO];

    [l setShadowColor:[color CGColor]];
    [l setShadowOffset:CGSizeMake(1, 1)];
    [l setShadowOpacity:o];
    [l setShadowRadius:size];
}


#pragma mark - COLOR
+(UIColor *) colorFromHtmlSting:(NSString *)stringToConvert
{
    static NSMutableDictionary *colors = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        colors = [[NSMutableDictionary alloc] init];
    });

    UIColor *color = [colors objectForKey:stringToConvert];
    if (color) {
        return color;
    }
    
    NSString *str = [stringToConvert stringByReplacingOccurrencesOfString:@"#" withString:@"0X"];
    
    NSString *cString = [str uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString length] != 6) return [UIColor blackColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    color = [UIColor colorWithRed:((float) r / 255.0f)
                                     green:((float) g / 255.0f)
                                      blue:((float) b / 255.0f)
                                     alpha:1.0f];
    
    [colors setObject:color forKey:stringToConvert];
    
    return color;
}

+(void) dimmScreen:(BOOL) yes {
    UIApplication *app = [UIApplication sharedApplication];
    app.idleTimerDisabled = !yes;
    
    NSLog(@"light is on: %d", !yes);
}

+(BOOL) isSlowDevice {
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *modelName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];

    if([modelName isEqualToString:@"i386"]) {
        modelName = @"iPhone Simulator";
    }
    else if([modelName isEqualToString:@"iPhone1,1"]) {
        modelName = @"iPhone";
        return YES;
    }
    else if([modelName isEqualToString:@"iPhone1,2"]) {
        modelName = @"iPhone 3G";
        return YES;
    }
    else if([modelName isEqualToString:@"iPhone2,1"]) {
        modelName = @"iPhone 3GS";
        return YES;
    }
    else if([modelName isEqualToString:@"iPhone3,1"]) {
        modelName = @"iPhone 4";
        return YES;
    }
    else if([modelName isEqualToString:@"iPhone4,1"]) {
        modelName = @"iPhone 4S";
    }
    else if([modelName isEqualToString:@"iPod1,1"]) {
        modelName = @"iPod 1st Gen";
        return YES;
    }
    else if([modelName isEqualToString:@"iPod2,1"]) {
        modelName = @"iPod 2nd Gen";
        return YES;
    }
    else if([modelName isEqualToString:@"iPod3,1"]) {
        modelName = @"iPod 3rd Gen";
        return YES;
    }
    else if([modelName isEqualToString:@"iPad1,1"]) {
        modelName = @"iPad";
    }
    else if([modelName isEqualToString:@"iPad2,1"]) {
        modelName = @"iPad 2(WiFi)";
    }
    else if([modelName isEqualToString:@"iPad2,2"]) {
        modelName = @"iPad 2(GSM)";
    }
    else if([modelName isEqualToString:@"iPad2,3"]) {
        modelName = @"iPad 2(CDMA)";
    }
    
    return NO;
}


+ (void) updateFrameForLabel:(UILabel *)detailTextLabel
{
    CGSize maximumSize = CGSizeMake(300, 9999);
    NSString *dateString = @"The date today is January 1st, 1999";
    UIFont *dateFont = [UIFont fontWithName:@"Helvetica" size:14];
    CGSize dateStringSize = [dateString sizeWithFont:dateFont
                                   constrainedToSize:maximumSize
                                       lineBreakMode:detailTextLabel.lineBreakMode];
    
    CGRect dateFrame = CGRectMake(10, 10, 300, dateStringSize.height);
    detailTextLabel.frame = dateFrame;
}

@end
























