//
//  VSSStyleSheetManager.m
//  VSS
//
//  Created by Flor, Daniel J on 9/23/15.
//  Copyright © 2015 ObiDan. All rights reserved.
//

#import "VSSStyleSheetManager.h"
#import "UIView+StyleSheet.h"
#import "UIColor+HexString.h"
#import <objc/runtime.h>

@interface VSSStyleSheetManager ()

@property NSDictionary *styles;

- (void)loadStyles;

@end

@implementation VSSStyleSheetManager

+ (VSSStyleSheetManager *)instance {
    static VSSStyleSheetManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[VSSStyleSheetManager alloc] init];
        [_instance loadStyles];
    });
    return _instance;
}

- (void)applyStyleToView:(UIView*)view {
    //TODO: pepper this full of assertions to enforce VSS.plist format
    //TODO: add hierarchy to styles so that defaults applied first, THEN desired style!
    //Get the class name:
    NSString *className = NSStringFromClass(view.class);
    NSDictionary *classStyles = _styles[className];
    if (classStyles != nil) {
        NSDictionary *style;
        if ([view conformsToProtocol:@protocol(styleable)]) {
            //Our view implements the styleable protocol, may not be default...
            UIView <styleable> *styledView = (UIView <styleable> *)view;
            style = classStyles[styledView.style];
        }
        else {
            //Our view is not styleable, it will get the default style.
            style = classStyles[@"default"];
        }
        for (NSString *key in [style allKeys]) {
            SEL selector = NSSelectorFromString(key);
            NSString *val = [style valueForKey:key];
            if ([view respondsToSelector:selector]) {
                NSLog(@"Applying value '%@' to atrribute '%@'",val,key);
                if ([key hasSuffix:@"olor"]) {
                    //It's a color!
                    UIColor *color = [UIColor colorFromHexString:val];
                    [view setValue:color forKey:key];
                }
                else {
                    [view setValue:val forKey:key];
                }
            }
        }
    }
    
}

- (void)loadStyles {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"VSS" ofType:@"plist"];
    NSAssert(plistPath != nil, @"VSS.plist not found in project!  See README.md for details.");
    _styles = [NSDictionary dictionaryWithContentsOfFile:plistPath];
}

@end
