//
//  UIView+StyleSheet.m
//  VSS
//
//  Created by Flor, Daniel J on 9/23/15.
//  Copyright © 2015 ObiDan. All rights reserved.
//

#import "UIView+StyleSheet.h"
#import "VSSStyleSheetManager.h"
#import <objc/runtime.h>

@implementation UIView (StyleSheet)

- (void)applyStyles {
    UIView * __weak weakSelf = self;  //create a weak reference to self...
    [[VSSStyleSheetManager instance] applyStyleToView:weakSelf]; //...and apply!
}

+ (void)swizzleLayoutSubviews {
    //call this static method in the ApplicationDelegate's applicationDidFinishLaunchingWithOptions.
    //a method to swizzle the layoutSubviews call, so we can force all UIViews using this
    //category to first appoy the style, and THEN do the original layout subviews.  Swanky, huh?
    Method oldLayout = class_getInstanceMethod(UIView.class, @selector(layoutSubviews));
    Method newLayout = class_getInstanceMethod(UIView.class, @selector(oldLayoutSubviews));
    method_exchangeImplementations(oldLayout, newLayout);
    
}

- (void)oldLayoutSubviews {
    //this method gets swizzled to contain the original [UIView layoutSubviews] call
    //and the logic herein gets moved to [UIView layoutSubviews]
    [self applyStyles];        //Go and apply the styles, for crying out loud!
    [self oldLayoutSubviews];  //NOT an infintie loop, if we are swizzled first! #HereBeDragons
}

@end
