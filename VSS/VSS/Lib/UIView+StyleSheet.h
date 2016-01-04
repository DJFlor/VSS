//
//  UIView+StyleSheet.h
//  VSS
//
//  Created by Flor, Daniel J on 9/23/15.
//  Copyright © 2015 ObiDan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (StyleSheet)

@property IBInspectable NSString *style;

- (void)applyStyles;
- (void)oldLayoutSubviews;
+ (void)swizzleLayoutSubviews;

@end
