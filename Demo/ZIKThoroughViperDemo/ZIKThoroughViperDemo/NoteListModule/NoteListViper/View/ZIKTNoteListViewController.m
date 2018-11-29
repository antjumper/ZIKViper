//
//  ZIKTNoteListViewController
//  ZIKTViperDemo
//
//  Created by zuik on 2017/7/16.
//  Copyright © 2017年 zuik. All rights reserved.
//

#import "ZIKTNoteListViewController.h"
@import ZIKTViper.ZIKTViperViewPrivate;
@import ZIKTViper.UIViewController_ZIKTViperRouter;
#import "ZIKTNoteListViewEventHandler.h"
#import "ZIKTNoteListViewDataSource.h"

@interface ZIKTNoteListViewController () <ZIKTViperViewPrivate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) BOOL appeared;
@property (nonatomic, strong) id<ZIKTNoteListViewEventHandler> eventHandler;
@property (nonatomic, strong) id<ZIKTNoteListViewDataSource> viewDataSource;
@property (weak, nonatomic) IBOutlet UITableView *noteListTableView;
@end

@implementation ZIKTNoteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.noteListTableView.delegate = self;
    self.noteListTableView.dataSource = self;
}

- (UIViewController *)routeSource {
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.appeared == NO) {
        NSAssert([self.eventHandler conformsToProtocol:@protocol(ZIKTNoteListViewEventHandler)], nil);
        
        
        [self registerForPreviewingWithDelegate:self.eventHandler sourceView:self.view];
        UIBarButtonItem *addNoteItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                     target:self.eventHandler
                                                                                     action:@selector(didTouchNavigationBarAddButton)];
        self.navigationItem.rightBarButtonItem = addNoteItem;
        
        //通知presenter  执行 handleViewReady
        if ([self.eventHandler respondsToSelector:@selector(handleViewReady)]) {
            [self.eventHandler handleViewReady];
        }
        self.appeared = YES;
    }
    //通知presenter  执行 handleViewWillAppear
    if ([self.eventHandler respondsToSelector:@selector(handleViewWillAppear:)]) {
        [self.eventHandler handleViewWillAppear:animated];
    };
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //通知presenter  执行 handleViewDidAppear
    if ([self.eventHandler respondsToSelector:@selector(handleViewDidAppear:)]) {
        [self.eventHandler handleViewDidAppear:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //通知presenter  执行 handleViewWillDisappear
    if ([self.eventHandler respondsToSelector:@selector(handleViewWillDisappear:)]) {
        [self.eventHandler handleViewWillDisappear:animated];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //通知presenter  执行 handleViewDidDisappear
    if ([self.eventHandler respondsToSelector:@selector(handleViewDidDisappear:)]) {
        [self.eventHandler handleViewDidDisappear:animated];
    }
     //通知presenter  执行 handleViewRemoved
    if (self.ZIK_isRemoving == YES) {
        if ([self.eventHandler respondsToSelector:@selector(handleViewRemoved)]) {
            [self.eventHandler handleViewRemoved];
        }
    }
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath
                                      text:(NSString *)text
                                detailText:(NSString *)detailText {
    UITableViewCell *cell = [self.noteListTableView dequeueReusableCellWithIdentifier:@"noteListCell" forIndexPath:indexPath];
    cell.textLabel.text = text;
    cell.detailTextLabel.text = detailText;
    return cell;
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //通知viewDataSource(此处的viewDataSource就是presenter) 执行 numberOfRowsInSection
    return [self.viewDataSource numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //通知viewDataSource(此处的viewDataSource就是presenter) 执行 textOfCellForRowAtIndexPath detailTextOfCellForRowAtIndexPath

    NSString *text = [self.viewDataSource textOfCellForRowAtIndexPath:indexPath];
    NSString *detailText = [self.viewDataSource detailTextOfCellForRowAtIndexPath:indexPath];
    UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath
                                                   text:text
                                             detailText:detailText];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //通知presenter  执行 canEditRowAtIndexPath
    return [self.eventHandler canEditRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //通知presenter  执行 handleDeleteCellForRowAtIndexPath
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.eventHandler handleDeleteCellForRowAtIndexPath:indexPath];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

#pragma mark UITableViewDelegate

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @[
             [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                 [self.eventHandler handleDeleteCellForRowAtIndexPath:indexPath];
                 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
             }]
             ];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self .eventHandler handleDidSelectRowAtIndexPath:indexPath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
