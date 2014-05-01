//
//  UIView+LENibLoading.h
//  Auto Layout By Example
//
//  Created by Julius Parishy on 4/30/14.
//  Copyright (c) 2014 jp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LENibLoading)

- (void)le_loadFromNib;
- (void)le_loadFromNibWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle;

@end
