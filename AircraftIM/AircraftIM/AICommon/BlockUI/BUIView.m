//
//  BUIView.m
//  sample
//
//  Created by 张玺 on 12-9-10.
//  Copyright (c) 2012年 张玺. All rights reserved.
//

#import "BUIView.h"
#import <objc/runtime.h>


@implementation UIView(BUIView)

const char oldDelegateKey;
const char completionBlockKey;

#pragma -mark UIAlerView
- (void)showWithCompletionBlock:(void (^)(NSInteger buttonIndex))completionBlock
{
    UIAlertView *alert = (UIAlertView *)self;
    if(completionBlock != nil){
        id oldDelegate = objc_getAssociatedObject(self, &oldDelegateKey);
        if(oldDelegate == nil){
            objc_setAssociatedObject(self, &oldDelegateKey, oldDelegate, OBJC_ASSOCIATION_ASSIGN);
        }
        
        oldDelegate = alert.delegate;
        alert.delegate = self;
        objc_setAssociatedObject(self, &completionBlockKey, completionBlock, OBJC_ASSOCIATION_COPY);
    }
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIAlertView *alert = (UIAlertView *)self;
    void (^completionBlock)(NSInteger buttonIndex) = objc_getAssociatedObject(self, &completionBlockKey);
    
    if(completionBlock == nil){
        return;
    }
    
    completionBlock(buttonIndex);
    alert.delegate = objc_getAssociatedObject(self, &oldDelegateKey);
}


#pragma -mark UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    void (^theCompletionHandler)(NSInteger buttonIndex) = objc_getAssociatedObject(self, &completionBlockKey);
    
    if(theCompletionHandler == nil){
        return;
    }
    
    theCompletionHandler(buttonIndex);
    UIActionSheet *sheet = (UIActionSheet *)self;
    
    sheet.delegate = objc_getAssociatedObject(self, &oldDelegateKey);
}
- (UIActionSheet *)actionSheetWithComplete:(void(^)(NSInteger buttonIndex))complete
{
    UIActionSheet *sheet = (UIActionSheet *)self;
    if(complete != nil){
        id oldDelegate = objc_getAssociatedObject(self, &oldDelegateKey);
        if(oldDelegate == nil){
            objc_setAssociatedObject(self, &oldDelegateKey, oldDelegate, OBJC_ASSOCIATION_ASSIGN);
        }
        
        oldDelegate = sheet.delegate;
        sheet.delegate = self;
        objc_setAssociatedObject(self, &completionBlockKey, complete, OBJC_ASSOCIATION_COPY);
    }
    return sheet;
}

- (void)showInView:(UIView *)view complete:(void (^)(NSInteger buttonIndex))complete
{
    UIActionSheet *sheet = [self actionSheetWithComplete:complete];
    [sheet showInView:view];
}

- (void)showFromToolbar:(UIToolbar *)view complete:(void (^)(NSInteger buttonIndex))complete
{
    UIActionSheet *sheet = [self actionSheetWithComplete:complete];
    [sheet showFromToolbar:view];
}

- (void)showFromTabBar:(UITabBar *)view complete:(void (^)(NSInteger buttonIndex))complete
{
    UIActionSheet *sheet = [self actionSheetWithComplete:complete];
    [sheet showFromTabBar:view];
}

- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated complete:(void (^)(NSInteger buttonIndex))complete
{
    UIActionSheet *sheet = [self actionSheetWithComplete:complete];
    [sheet showFromRect:rect inView:view animated:animated];
}

- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated complete:(void (^)(NSInteger buttonIndex))complete
{
    UIActionSheet *sheet = [self actionSheetWithComplete:complete];
    [sheet showFromBarButtonItem:item animated:animated];
}

const char tapBlockKey;
const char tapGestureKey;

#pragma -mark TapGesture ( 注意： 必须使用weakSelf : __weak typeof(self) weakSelf = self; )
- (void)setTapActionWithBlock:(void (^)(void))block
{
    self.userInteractionEnabled = YES;
    
	UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &tapGestureKey);
	if (!gesture){
		gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
		[self addGestureRecognizer:gesture];
		objc_setAssociatedObject(self, &tapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	objc_setAssociatedObject(self, &tapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)tapGestureAction:(UITapGestureRecognizer *)gesture
{
	if (gesture.state == UIGestureRecognizerStateRecognized){
		void(^action)(void) = objc_getAssociatedObject(self, &tapBlockKey);
		action ? action() : nil;
	}
}

@end
