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

- (void)setStyle:(NSString *)style {
    // The very first time a style is set on a UIView, we swizzle the layout!
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //do it once, and only once!
        [UIView swizzleLayoutSubviews];
    });
    // set the associated style string, so we have it later.
    objc_setAssociatedObject(self, @selector(style), style, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)style {
    return objc_getAssociatedObject(self, @selector(style));
}

+ (void)swizzleLayoutSubviews {
    //this static method is invoked the first time a UIView's style is set.
    //a method to swizzle the layoutSubviews call, so we can force all UIViews using this
    //category to first apply the style, and THEN do the original layout subviews.  Swanky, huh?
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
