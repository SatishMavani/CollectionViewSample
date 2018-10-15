//
//  ViewController.h
//  FYND
//
//  Created by Satish Mavani on 09/10/18.
//  Copyright © 2018 FYND. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>{
    
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSMutableArray* categoryDataArray;
@property (nonatomic,retain) NSMutableDictionary* categoryDetailDic;
@property (nonatomic) BOOL isListView;
@property (assign) NSInteger expandedSectionHeaderNumber,numberOFRows;
@property (assign) UITableViewHeaderFooterView *expandedSectionHeader;
@property (strong) NSArray *sectionItems;
@property (strong) NSArray *sectionNames;


- (IBAction)sortTypeChange:(UISegmentedControl *)sender;


@end

