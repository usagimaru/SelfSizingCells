//
//  ViewController.m
//  SelfSizingCells
//
//  Created by M.Satori on 15.01.10.
//  Copyright (c) 2015年 M.Satori. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
#import "NSIndexPath+USGNSStringValue.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *fixSwitch;

@property (copy, nonatomic) NSArray *dataSoruce;
@property (strong, nonatomic) NSMutableDictionary *cellHeights;

- (IBAction)fixSwitchAction:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	self.cellHeights = @{}.mutableCopy;
	self.dataSoruce = @[];
	
	// セルの高さの計算は Autolayout に任せる
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.estimatedRowHeight = 76;
	
	self.tableView.separatorInset = UIEdgeInsetsMake(0, 8, 0, 0);
	
	[self __addStringArrayToDataSource];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


#pragma mark -

- (NSArray*)__stringArray
{
	return @[
			 @"あのイーハトーヴォのすきとおった風、夏でも底に冷たさをもつ青いそら、うつくしい森で飾られたモーリオ市、郊外のぎらぎらひかる草の波。",
			 @"祇辻飴葛蛸鯖鰯噌庖箸",
			 @"ABCDEFGHIJKLM\nabcdefghijklm\n1234567890",
			 @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
			 @"Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.",
			 @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.",
			 @"いろはにほへとちりぬるをわかよたれそつねならむうゐのおくやまけふこえてあさきゆめみしゑひもせすん",
			 @"月日は百代の過客にして、行かふ年も又旅人也。舟の上に生涯をうかべ、馬の口とらえて老をむかふる物は、日々旅にして旅を栖とす。古人も多く旅に死せるあり。",
			 @"予もいづれの年よりか、片雲の風にさそはれて、漂泊の思ひやまず、海浜にさすらへ、去年の秋、江上の破屋に蜘蛛の古巣を払ひて、やゝ年も暮、春立る霞の空に白川の関こえんと、そゞろ神の物につきて心をくるはせ、道祖神のまねきにあひて、取もの手につかず。もゝ引の破をつゞり、笠の緒付かえて、三里に灸すゆるより、松島の月先心にかゝりて、住る方は人に譲り、杉風が別墅に移るに、",
			 @"草の戸も住替る代ぞひなの家",
			 @"面八句を庵の柱に懸置。",
			 ];
}

- (void)__addStringArrayToDataSource
{
	NSMutableArray *mutableArray = self.dataSoruce.mutableCopy;
	NSUInteger repeat = 5;
	
	for (NSUInteger i = 0; i < repeat; i++) {
		[mutableArray addObjectsFromArray:[self __stringArray]];
	}
	
	self.dataSoruce = mutableArray;
}

- (void)__endDecelerating
{
	NSIndexPath *indexPath = [[self.tableView indexPathsForVisibleRows] lastObject];
	
	// 最下端のセルに到達したらデータソースを増やしてリロード
	if (indexPath && indexPath.row == self.dataSoruce.count-1) {
		[self __addStringArrayToDataSource];
		[self.tableView reloadData];
		
		CGPoint offset = self.tableView.contentOffset;
		offset.y += self.tableView.estimatedRowHeight;
		[self.tableView setContentOffset:offset animated:YES];
		
		__weak typeof(self) wself = self;
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			
			[wself.tableView flashScrollIndicators];
		});
	}
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.dataSoruce.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	
	cell.label.text = [NSString stringWithFormat:@"%ld\n%@", indexPath.row, self.dataSoruce[indexPath.row]];
	
	return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *key = [indexPath stringValue];
	NSNumber *height = self.cellHeights[key];
	
	// セルの高さが既に決定しているなら保持している値を返す
	if (height && self.fixSwitch.on) {
		return height.doubleValue;
	}
	
	return tableView.estimatedRowHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	// セルの制約を更新
	[cell.contentView updateConstraints];
	
	// 確定したセルの高さを保持しておく
	NSString *key = [indexPath stringValue];
	if (!self.cellHeights[key]) {
		self.cellHeights[key] = @(cell.bounds.size.height);
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (!decelerate) {
		[self __endDecelerating];
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	[self __endDecelerating];
}


#pragma mark -

- (IBAction)fixSwitchAction:(id)sender
{
	[self.tableView reloadData];
}

@end
