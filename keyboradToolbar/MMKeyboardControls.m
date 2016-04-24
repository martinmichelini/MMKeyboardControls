//
//  MMKeyboardControls.m
//  keyboradToolbar
//
//  Created by Martin Michelini on 3/19/16.
//  Copyright © 2016 Martin Michelini. All rights reserved.
//

#import "MMKeyboardControls.h"

@interface MMKeyboardControls ()

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIBarButtonItem *leftArrowButton;
@property (nonatomic, strong) UIBarButtonItem *rightArrowButton;

@end

@implementation MMKeyboardControls

#pragma mark - Set initializers

- (id)init
{
    return [self initWithFields:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFields:nil];
}

- (id)initWithFields:(NSArray *)fields
{
    if (self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)])
    {
        [self setToolbar:[[UIToolbar alloc] initWithFrame:self.frame]];
        [self.toolbar setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth)];
        [self addSubview:self.toolbar];
        [self setLeftArrowButton:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:105 target:self action:@selector(selectPreviousField)]];
        [self setRightArrowButton:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:106 target:self action:@selector(selectNextField)]];
        UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedSpace.width = 22.0;
        self.toolbar.items = @[self.leftArrowButton, fixedSpace, self.rightArrowButton];
        [self setFields:fields];
    }
    return self;
}

#pragma mark - Prepare fields

- (void)setFields:(NSArray *)fields
{
    if (fields != _fields)
    {
        int tag = 0;
        for (UITextField *field in fields)
        {
            [(UITextField *)field setInputAccessoryView:self];
            field.autocorrectionType = UITextAutocorrectionTypeNo;
            [field setReturnKeyType:UIReturnKeyDone];
            field.tag = tag;
            tag++;
        }
        _fields = fields;
    }
}

#pragma mark - Set active field

- (void)setActiveField:(id)activeField
{
    if (activeField != _activeField)
    {
        if (!activeField || [self.fields containsObject:activeField])
        {
            _activeField = activeField;
            if (activeField)
            {
                if (![activeField isFirstResponder])
                {
                    [activeField becomeFirstResponder];
                }
            }
        }
    }
}

#pragma mark - Select previous / next field

-(void)selectNextField
{
    int nextField = 0;
    if (self.activeField.tag < self.fields.count -1)
    {
        nextField = (int)self.activeField.tag +1;
        self.activeField = self.fields[nextField];
    }
    else
    {
        self.activeField = self.fields.firstObject;
    }
    [self.activeField becomeFirstResponder];
}

-(void)selectPreviousField
{
    int nextField = 0;
    if ((self.activeField.tag < self.fields.count) && (self.activeField.tag > 0))
    {
        nextField = (int)self.activeField.tag -1;
        self.activeField = self.fields[nextField];
    }
    else
    {
        self.activeField = self.fields.lastObject;
    }
    [self.activeField becomeFirstResponder];
}

@end
