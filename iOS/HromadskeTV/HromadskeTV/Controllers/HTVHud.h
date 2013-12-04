#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>


@interface HTVHud : NSObject
@property (nonatomic, strong) MBProgressHUD *hud;

+ (instancetype)sharedManager;
- (void)startHUD;
- (void)finishHUD;

@end
