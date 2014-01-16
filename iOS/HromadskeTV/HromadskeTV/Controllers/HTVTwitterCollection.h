//
//  HTVTwitterCollection.h
//  HromadskeTV
//
//  Created by Max Tymchii on 1/16/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTVParentNativeVC.h"

@interface HTVTwitterCollection : HTVParentNativeVC
- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier ;
@end
