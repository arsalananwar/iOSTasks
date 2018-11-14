//
//  ViewController.m
//  TestAnimation
//
//  Created by O16Labs on 09/11/2018.
//  Copyright © 2018 O16 Labs. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "CardTableCell.h"

@interface FirstViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) Transition *transition;
@end

@implementation FirstViewController
static NSString *cellID = @"cellID";
- (void)viewDidLoad {
	[super viewDidLoad];
	[self setupNavigationBar];
	[self setupTableView];
}

- (void)setupNavigationBar {
	self.navigationItem.title = @"Today";
	[self.navigationController setNavigationBarHidden:YES];
}

- (void)setupTableView {
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.tableView.backgroundColor = [UIColor lightGrayColor];
	
	UINib *nib = [UINib nibWithNibName:@"CardTableCell" bundle:nil];
	[self.tableView registerNib:nib forCellReuseIdentifier:cellID];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	CardTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
	
	if (cell == nil) {
		cell = [CardTableCell.new initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
	}
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 450;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	CardTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	[cell freezeAnimations];
	
	CGRect currentFrame = cell.layer.presentationLayer.frame;
	
	CGRect cardPresentationFrameOnScreen = [cell.superview convertRect:currentFrame toView:nil];
	
	CGRect cardFrameWithoutTransform = [self rectWithoutTransform:cell];
	
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	
	SecondViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"SecondViewController"];
	self.transition = [Transition.new init:[self fromCardFrame:cardPresentationFrameOnScreen
                                 fromCardFrameWithoutTransform:cardFrameWithoutTransform
                                                     tableCell:cell]];
    
	[controller setTransitioningDelegate:self.transition];
	[controller setModalPresentationStyle:UIModalPresentationCustom];
	controller.modalPresentationCapturesStatusBarAppearance = YES;
	
	[self presentViewController:controller animated:YES completion:^{
		[cell unFreezeAnimations];
	}];
	
}

- (CGRect)rectWithoutTransform:(CardTableCell *)cell {
	CGPoint center = cell.center;
	CGSize size = cell.bounds.size;
	CGRect rect = CGRectMake(center.x - size.width / 2,
                             center.y - size.height / 2,
                             size.width,
                             size.height);
    
	return [cell.superview convertRect:rect toView:nil];
}

- (struct Params)fromCardFrame:(CGRect)frame
                    fromCardFrameWithoutTransform:(CGRect)frameWithoutTransform
                        tableCell:(CardTableCell*)cell {
    
	struct Params param;
	param.fromCell = cell;
	param.fromCardFrame = frame;
	param.fromCardFrameWithoutTransform = frameWithoutTransform;
	return param;
}

@end
