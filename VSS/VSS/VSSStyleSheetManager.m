//
//  VSSStyleSheetManager.m
//  VSS
//
//  Created by Flor, Daniel J on 9/23/15.
//  Copyright © 2015 ObiDan. All rights reserved.
//

#import "VSSStyleSheetManager.h"

@implementation VSSStyleSheetManager

+ (VSSStyleSheetManager *)instance {
    static VSSStyleSheetManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[VSSStyleSheetManager alloc] init];
    });
    return _instance;
}

- (void)applyStyleToView:(UIView*)view {
    //lot to do here, we'll get to that soon...
}

@end
