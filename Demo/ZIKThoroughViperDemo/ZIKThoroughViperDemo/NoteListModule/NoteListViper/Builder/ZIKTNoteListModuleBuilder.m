//
//  ZIKTNoteListModuleBuilder.m
//  ZIKTViperDemo
//
//  Created by zuik on 2017/7/31.
//  Copyright © 2017年 zuik. All rights reserved.
//

#import "ZIKTNoteListModuleBuilder.h"
@import ZIKTViper;

#import "ZIKTNoteListViewController.h"
#import "ZIKTNoteListViewPresenter.h"
#import "ZIKTNoteListInteractor.h"
#import "ZIKTNoteListDataService.h"
#import "ZIKTNoteListWireframe.h"
#import "ZIKTNoteListRouter.h"

@implementation ZIKTNoteListModuleBuilder

+ (UIViewController *)viewControllerWithNoteListDataService:(id<ZIKTNoteListDataService>)service router:(id<ZIKTNoteListRouter>)router {
    //xib 加载UIViewController
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *view = [sb instantiateViewControllerWithIdentifier:@"ZIKTNoteListViewController"];
    //加载view之后为VIPER 设置 IPER
    NSAssert([view isKindOfClass:[ZIKTNoteListViewController class]], nil);
    [self buildView:(id<ZIKTViperViewPrivate>)view noteListDataService:service router:router];
    return view;
}

+ (void)buildView:(id<ZIKTViperViewPrivate>)view noteListDataService:(id<ZIKTNoteListDataService>)service router:(id<ZIKTNoteListRouter>)router {
    NSParameterAssert([view isKindOfClass:[ZIKTNoteListViewController class]]);
    NSParameterAssert(service);
    //生成P
    ZIKTNoteListViewPresenter *presenter = [[ZIKTNoteListViewPresenter alloc] init];
    //生成I  Interactor需要委托presenter 办事 eventHandler 和 dataSource
    ZIKTNoteListInteractor *interactor = [[ZIKTNoteListInteractor alloc] initWithNoteListDataService:service];
    //把presenter设置成 Interactor的代理
    interactor.eventHandler = presenter;
    //把 presenter 设置成 Interactor的代理
    interactor.dataSource = presenter;
    //生成wireFrame wrieFrame 需要委托view 和 router 办事情
    id<ZIKTViperWireframePrivate> wireframe = (id)[[ZIKTNoteListWireframe alloc] init];
    NSAssert([wireframe conformsToProtocol:@protocol(ZIKTViperWireframePrivate)], nil);
    //把view设置成router的delegate
    wireframe.view = view;
    //把router设置成wireframe的delegate  请注意此处是强引用
    wireframe.router = router;
    
    //把view 设置成presenter的代理 presenter 需要委托view，wireframe，vinteractor 办事情
    [(id<ZIKTViperPresenterPrivate>)presenter setView:view];//弱引用
    //把wireframe 设置成presenter的代理
    [(id<ZIKTViperPresenterPrivate>)presenter setWireframe:wireframe];//强引用
    //把interactor 设置成presenter 的代理
    [(id<ZIKTViperPresenterPrivate>)presenter setInteractor:interactor];//强引用
    
    //把view持有了presenter  view 需要presenter 办eventHandler和viewDataSource的事情
    view.eventHandler = presenter;
    //把view持有了presenter 办理viewDataSource
    view.viewDataSource = presenter;
}

@end
