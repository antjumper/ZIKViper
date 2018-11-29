//
//  ZIKTNoteListModuleBuilder.h
//  ZIKTViperDemo
//
//  Created by zuik on 2017/7/31.
//  Copyright © 2017年 zuik. All rights reserved.
//
/*
 作用就是构建VIPER之间的连接和相互引用的规则
 */
#import <UIKit/UIKit.h>

@protocol ZIKTViperViewPrivate,ZIKTNoteListDataService,ZIKTNoteListRouter;

@interface ZIKTNoteListModuleBuilder : NSObject
+ (UIViewController *)viewControllerWithNoteListDataService:(id<ZIKTNoteListDataService>)service router:(id<ZIKTNoteListRouter>)router;
+ (void)buildView:(id<ZIKTViperViewPrivate>)view noteListDataService:(id<ZIKTNoteListDataService>)service router:(id<ZIKTNoteListRouter>)router;
@end
