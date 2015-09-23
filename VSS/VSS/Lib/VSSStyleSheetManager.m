//
//  VSSStyleSheetManager.m
//  VSS
//
//  Created by Flor, Daniel J on 9/23/15.
//  Copyright © 2015 ObiDan. All rights reserved.
//

#import "VSSStyleSheetManager.h"
#import "UIView+StyleSheet.h"

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
    });
    [_instance loadStyles];
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
        if ([view conformsToProtocol:@protocol(stylable)]) {
            //Our view implements the stylable protocol, may not be default...
            UIView <stylable> *styledView = (UIView <stylable> *)view;
            style = classStyles[styledView.style];
        }
        else {
            //Our view is not stylable, it will get the default style.
            style = classStyles[@"default"];
        }
    }
    
}

- (void)loadStyles {
    NSString *plistFile;
    
    if (NSClassFromString(@"VSSTests") != nil) {
        //we are running from testmode
        plistFile = @"SampleVSS.plist";
    }
    else {
        plistFile = @"VSS.plist";
    }
    
    NSString *plistPath = [[NSBundle bundleForClass:self.class] pathForResource:plistFile ofType:@"plist"];
    NSAssert(plistPath != nil, @"VSS.plist not found in project!  See README.md for details.");
    _styles = [NSDictionary dictionaryWithContentsOfFile:plistPath];
}

@end
