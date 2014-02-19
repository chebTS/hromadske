//
//  NSDateUtil.h
//  friendsNavApp
//
//  Created by Comonitos on 24.01.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject {

	
}

#define APP_STORE_PATH(APP_ID)  ([NSString stringWithFormat:@"http://itunes.apple.com/app/id%d", APP_ID])

#pragma mark - dates
+ (NSString *) timeStringFormSeconds:(float)seconds;
+ (NSString *) stringFromDate:(NSDate *)date withFormat:(NSString *)format;
+ (NSDate *) dateFromString:(NSString *)string withFormat:(NSString *)format;

+ (NSDate *) dateFromEventString:(NSString *)string;
+ (NSDate *) dateFromSeminarString:(NSString *)string;

+ (NSDate *) dateFromTSString:(NSTimeInterval) ts;
+ (NSString *) stringHoursFromDate:(NSDate *)date;

+ (int) getHoversToPastDate:(NSDate *)date;
+ (NSString *) timeToEventHumanRecognizable:(NSDate *)eventDate eventName:(NSString *)name;
+ (NSString *) timeShortToEventHumanRecognizable:(NSDate *)eventDate;
+ (NSString *) timeExactHumanRecognizible:(NSDate *)eventDate;
+ (NSString *) stringHumanRecognizableFromDate:(NSDate *)eventDate;

+ (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect;
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)targetSize;
+ (UIImageView *) addCorners:(UIImageView *)view withSize:(float)size borders:(float)bsize andColor:(UIColor *)color;
+ (void) addCornersToLayer:(CALayer *)layer withSize:(float)size borders:(float)bsize andColor:(UIColor *)color;

#pragma mark - Images
+ (void) bezierRoundedCornersforView:(UIView *)view;
+ (UIImage *) roundCornersOfImage:(UIImage *)source size:(int)size top:(BOOL)yes;
+ (UIImage *) roundCornersOfImage:(UIImage *)source size:(int)size;
+ (void) addShadowForView:(UIView *)viev withRadious:(int)size andColor:(UIColor *)color opacity:(float)o;
+ (void) addRoundedCornersOfView:(UIView *)viev withRadious:(int)size;
+ (void) clearRoundedCornersOfView:(UIView *)viev;

#pragma mark - COLOR
+(UIColor *) colorFromHtmlSting:(NSString *)stringToConvert;

+(void) dimmScreen:(BOOL) yes;
+(BOOL) isSlowDevice;

+ (void) updateFrameForLabel:(UILabel *)detailTextLabel;
@end
