//
//  VSSStyleSheetManager.h
//  VSS
//
//  Created by Flor, Daniel J on 9/23/15.
//  Copyright © 2015 ObiDan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VSSStyleSheetManager : NSObject

+ (VSSStyleSheetManager *)instance;

- (void)applyStyleToView:(UIView *)view;

@end
