#import "HTVHud.h"

#define HUD_WIDTH 60    
#define HUD_HEIGHT 60

@implementation HTVHud

+ (instancetype)sharedManager
{
    static HTVHud *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init
{
    if (self = [super init]) {
            }
    return self;
}

- (MBProgressHUD *)hud
{
    if (!_hud) {
        CGRect hudRect  = CGRectMake(0, 0, HUD_WIDTH, HUD_HEIGHT);
        _hud = [[MBProgressHUD alloc] initWithFrame:hudRect];
        _hud.mode = MBProgressHUDModeIndeterminate;
    }
    return _hud;
}

- (void)startHUD
{
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = @"Завантаження";
//    int numberOfwindows =  [[UIApplication sharedApplication].windows count] - 2;
//    [[[UIApplication sharedApplication].windows objectAtIndex:numberOfwindows] addSubview:self.hud];
    [DELEGATE.window.rootViewController.view addSubview:self.hud];
    [self.hud show:YES];
}

- (void)finishHUD
{
    self.hud.mode = MBProgressHUDModeIndeterminate;
     [self.hud hide:YES];
    [self.hud removeFromSuperViewOnHide];
}


@end
