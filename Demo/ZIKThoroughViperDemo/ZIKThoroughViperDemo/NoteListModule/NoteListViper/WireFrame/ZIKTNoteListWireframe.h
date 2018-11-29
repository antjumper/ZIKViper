//
//  ZIKTNoteListWireframe.h
//  ZIKTViperDemo
//
//  Created by zuik on 2017/7/24.
//  Copyright © 2017年 zuik. All rights reserved.
//

#import <Foundation/Foundation.h>
@import ZIKTViper.ZIKTViperWireframe;

NS_ASSUME_NONNULL_BEGIN

@protocol ZIKTLoginViewDelegate,ZIKTEditorDelegate;
@interface ZIKTNoteListWireframe : NSObject <ZIKTViperWireframe>

//跳转到 登陆界面 放在了 Wireframe中
- (void)presentLoginViewWithMessage:(NSString *)message delegate:(id<ZIKTLoginViewDelegate>)delegate completion:(void (^ __nullable)(void))completion;
//登陆界面的 dismiss也是放在了Wireframe中
- (void)dismissLoginView:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;

//添加新的笔记界面也是放在了Wireframe中
- (void)presentEditorForCreatingNewNoteWithDelegate:(id<ZIKTEditorDelegate>)delegate completion:(void (^ __nullable)(void))completion;
- (void)pushEditorViewForEditingNoteWithUUID:(NSString *)uuid title:(NSString *)title content:(NSString *)content delegate:(id<ZIKTEditorDelegate>)delegate;
- (UIViewController *)editorViewForEditingNoteWithUUID:(NSString *)uuid title:(NSString *)title content:(NSString *)content delegate:(id<ZIKTEditorDelegate>)delegate;
- (void)pushEditorViewController:(UIViewController *)destination fromViewController:(UIViewController *)source animated:(BOOL)animated;
- (void)quitEditorViewWithAnimated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
