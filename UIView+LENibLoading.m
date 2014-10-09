//
//  UIView+LENibLoading.m
//  Auto Layout By Example
//
//  Created by Julius Parishy on 4/30/14.
//  Copyright (c) 2014 jp. All rights reserved.
//

#import "UIView+LENibLoading.h"

#import <objc/runtime.h>

static void *LELoadFromNibAlreadyLoadedKey = &LELoadFromNibAlreadyLoadedKey;

@implementation UIView (LENibLoading)

- (void)le_setAlreadyLoadedFromNib
{
    objc_setAssociatedObject(self, LELoadFromNibAlreadyLoadedKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)le_alreadyLoadedFromNib
{
    NSNumber *loaded = objc_getAssociatedObject(self, LELoadFromNibAlreadyLoadedKey);
    return (loaded != nil);
}

- (UIView *)le_rootView
{
    return self;
}

- (void)le_loadFromNib
{
    [self le_loadFromNibWithNibName:nil bundle:nil];
}

- (void)le_loadFromNibWithNibName:(NSString *)name bundle:(NSBundle *)bundle
{
    if(![self le_alreadyLoadedFromNib])
    {
        NSString *nibName = name ?: NSStringFromClass([self class]);
        NSBundle *nibBundle = bundle ?: [NSBundle mainBundle];
        
        UINib *nib = [UINib nibWithNibName:nibName bundle:nibBundle];
        
        NSArray *views = [nib instantiateWithOwner:self options:nil];
        NSAssert(views.count == 1, @"The xib must have a single root view.");
        
        UIView *view = views[0];
        
        self.frame = view.frame;
        
        [self copyBasePropertiesFromView:view toView:[self le_rootView]];
        
        if([self le_rootView].translatesAutoresizingMaskIntoConstraints == NO)
        {
            NSArray *constraints = [view.constraints copy];
            
            [self copySubviewsFromView:view toView:[self le_rootView]];
            [[self class] le_copyLayoutConstraints:constraints fromView:view toView:[self le_rootView]];
        }
        else
        {
            [self copySubviewsFromView:view toView:[self le_rootView]];
        }
        
        [self le_setAlreadyLoadedFromNib];
    }
}

- (void)copyBasePropertiesFromView:(UIView *)sourceView toView:(UIView *)destinationView
{
    destinationView.opaque = sourceView.opaque;
    destinationView.alpha  = sourceView.alpha;
    destinationView.hidden = sourceView.hidden;
    
    destinationView.backgroundColor = sourceView.backgroundColor;
    destinationView.tintColor = sourceView.tintColor;
    
    destinationView.contentMode = sourceView.contentMode;
    destinationView.clipsToBounds = sourceView.clipsToBounds;
    destinationView.clearsContextBeforeDrawing = sourceView.clearsContextBeforeDrawing;
}

- (void)copySubviewsFromView:(UIView *)sourceView toView:(UIView *)destinationView
{
    for(UIView *subview in sourceView.subviews)
    {
        [subview removeFromSuperview];
        [destinationView addSubview:subview];
    }
}

+ (NSArray *)le_copyLayoutConstraints:(NSArray *)constraints fromView:(UIView *)originalView toView:(UIView *)destinationView
{
    NSMutableArray *newConstraints = [[NSMutableArray alloc] init];
    
    for(NSLayoutConstraint *originalConstraint in constraints)
    {
        id firstItem = (originalConstraint.firstItem == originalView) ? destinationView : originalConstraint.firstItem;
        id secondItem = (originalConstraint.secondItem == originalView) ? destinationView : originalConstraint.secondItem;
                
        NSLayoutAttribute firstAttribute = originalConstraint.firstAttribute;
        NSLayoutAttribute secondAttribute = originalConstraint.secondAttribute;
        
        NSLayoutRelation relation = originalConstraint.relation;
        
        CGFloat multipler = originalConstraint.multiplier;
        CGFloat constant = originalConstraint.constant;
        
        NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:firstItem attribute:firstAttribute relatedBy:relation toItem:secondItem attribute:secondAttribute multiplier:multipler constant:constant];
        [destinationView addConstraint:newConstraint];
        
        [newConstraints addObject:newConstraint];
    }
    
    return [newConstraints copy];
}

@end
