//
//  LENibLoadedView.m
//  Auto Layout By Example
//
//  Created by Julius Parishy on 4/30/14.
//  Copyright (c) 2014 jp. All rights reserved.
//

#import "LENibLoadedView.h"

#import "UIView+LENibLoading.h"

@implementation LENibLoadedView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initializeSubviews];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initializeSubviews];
}

- (void)initializeSubviews
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self le_loadFromNib];
}

@end
