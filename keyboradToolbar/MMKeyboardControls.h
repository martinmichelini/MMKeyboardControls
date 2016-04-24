//
//  MMKeyboardControls.h
//  keyboradToolbar
//
//  Created by Martin Michelini on 3/19/16.
//  Copyright © 2016 Martin Michelini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMKeyboardControls : UIView

@property (strong, nonatomic) NSArray *fields;
@property (strong, nonatomic) UIView *activeField;
- (id)initWithFields:(NSArray *)fields;

@end
