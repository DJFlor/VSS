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
    //Get the class name:
    NSString *className = NSStringFromClass(view.class);
    NSDictionary *classStyles = _styles[className];
    if (classStyles != nil) {
        NSDictionary *style;
        if ([view style]) {
            //Our view has a style set, may not be default...
            style = classStyles[[view style]];
        }
        else {
            //Our view is not styleable, it will get the default style.
            style = classStyles[@"default"];
        }
        for (NSString *path in [style allKeys]) {
            id val = [style valueForKey:path];
            NSObject *target = view;
            NSArray *keys = [path componentsSeparatedByString:@"."];
            for (int i = 0; i < keys.count; i++) {
                NSString *key = keys[i];
                SEL selector = NSSelectorFromString(key);
                if ([target respondsToSelector:selector]) {
                    if (i == keys.count - 1) {
                        //We have found the leaf, set the target val!
                        NSLog(@"Applying value '%@' to atrribute '%@'",val,key);
                        if ([key hasSuffix:@"olor"]) {
                            //It's a color!
                            val = [UIColor colorFromHexString:val];
                        }
                        if ([key isEqualToString:@"transform"]) {
                            NSArray *args = [val componentsSeparatedByString:@","];
                            CGFloat angle = [args[0] floatValue] * M_PI / 180.f;
                            CGFloat x = [args[1] floatValue];
                            CGFloat y = [args[2] floatValue];
                            CGFloat z = [args[3] floatValue];
                            val = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(angle, x, y, z)];
                        }
                        [target setValue:val forKey:key];
                    }
                    else {
                        NSLog(@"Retrieving property '%@'",key);
                        target = [target valueForKey:key];
                    }
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
