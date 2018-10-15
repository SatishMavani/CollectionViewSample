//
//  ViewController.m
//  FYND
//
//  Created by Satish Mavani on 09/10/18.
//  Copyright © 2018 FYND. All rights reserved.
//

#import "ViewController.h"
#import "Constant.h"
#import "collectionTableViewCell.h"

static int const kHeaderSectionTag = 6900;

@interface ViewController ()

@end



@implementation ViewController

@synthesize expandedSectionHeader,expandedSectionHeaderNumber;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isListView = NO;
    [self.navigationController.navigationBar setBackgroundColor:[UIColor redColor]];
    [self fetchCategoryList];
    self.numberOFRows = 0;
}

-(void)createCategoryDataWithDetails:(NSDictionary*)json{
    
    self.categoryDataArray = [[NSMutableArray alloc]init];
    self.categoryDetailDic = [[NSMutableDictionary alloc]init];
    for ( NSString*category in [[[json valueForKey:@"objects"] valueForKey:@"all"] valueForKeyPath:@"name"] ) {

        NSString*urlStr;
        if ([category isEqualToString:@"POLOS"]) {
            urlStr = @"http://demo3325365.mockable.io/polos";
        }
        else if ([category isEqualToString:@"Sweatshirts"]){
            urlStr = @"http://demo3325365.mockable.io/sweatshirt";
        }
        else if ([category isEqualToString:@"Shirts"]){
            urlStr = @"http://demo3325365.mockable.io/shirts";
        }
        else if ([category isEqualToString:@"Jackets"]){
            urlStr = @"http://demo3325365.mockable.io/jackets";
        }
        else{
            urlStr = @"";
        }
        [self.categoryDataArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:urlStr,@"URL",@"cost",@"SORT",[category uppercaseString],@"CATEGORY",nil]];
    }
    
    NSSortDescriptor*brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"CATEGORY" ascending:YES];
    NSArray* sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
    [self.categoryDataArray sortedArrayUsingDescriptors:sortDescriptors];

    dispatch_sync(dispatch_get_main_queue(), ^{
        self.numberOFRows = self.categoryDataArray.count;
        [self.tableView reloadData];
    });
    
}

-(void)fetchCategoryList{
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:CATEGORYLIST] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"%@", json);
        [self createCategoryDataWithDetails:json];
    }]resume] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.isListView) {
        return self.categoryDataArray.count;
    }
    else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.isListView) {
        
        if (self.expandedSectionHeaderNumber == section) {
            NSDictionary*productDic = [self.categoryDataArray objectAtIndex:section];
            if ([productDic objectForKey:@"PRODUCTS"]) {
                return [[productDic objectForKey:@"PRODUCTS"] count];
            }
        }
        return 0;
    }
    else{
       return self.numberOFRows;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (self.isListView) {
        if (self.categoryDataArray.count) {
            return [[self.categoryDataArray objectAtIndex:section] valueForKey:@"CATEGORY"];
        }
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isListView) {
        return 40;
    }
    else{
        return 400;
    }
}


-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section{
    
    if (_isListView) {
        
        // recast your view as a UITableViewHeaderFooterView
        UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
        header.contentView.backgroundColor = [UIColor redColor];
        header.textLabel.textColor = [UIColor whiteColor];
        UIImageView *viewWithTag = [self.view viewWithTag:kHeaderSectionTag + section];
        if (viewWithTag) {
            [viewWithTag removeFromSuperview];
        }
        
        // add the arrow image
        CGSize headerFrame = self.view.frame.size;
        UIImageView *theImageView = [[UIImageView alloc] initWithFrame:CGRectMake(headerFrame.width - 32, 13, 18, 18)];
        theImageView.image = [UIImage imageNamed:@"downArrow"];
        theImageView.tag = kHeaderSectionTag + section;
        [header addSubview:theImageView];
        
        // make headers touchable
        header.tag = section;
        UITapGestureRecognizer *headerTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderWasTouched:)];
        [header addGestureRecognizer:headerTapGesture];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!self.isListView) {
        collectionTableViewCell *collectionCell = (collectionTableViewCell*)cell;
        collectionCell.productCollectionView.dataSource =  collectionCell.productCollectionView;
        collectionCell.productCollectionView.delegate =  collectionCell.productCollectionView;
        collectionCell.productCollectionView.tag = indexPath.row;
        collectionCell.productCollectionView.pagingEnabled = YES;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_isListView) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
        NSDictionary*productDic = [self.categoryDataArray objectAtIndex:indexPath.section];
        NSArray*proArray = [productDic objectForKey:@"PRODUCTS"];
        NSArray*sorted = [[NSArray alloc]initWithArray:[self sortArray:proArray]];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.text = [[sorted objectAtIndex:indexPath.row] valueForKey:@"name"];
        
        return cell;
    }
    else{
        
        static NSString *CellIdentifier = @"collectionTableViewCell";
        collectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.segSortType.tag = indexPath.row;
        if (self.categoryDetailDic) {
            
            NSDictionary*productDic = [self.categoryDataArray objectAtIndex:indexPath.row];
            NSString*keyStr = [productDic valueForKey:@"CATEGORY"];
            NSString*sort = [productDic valueForKey:@"SORT"];
            
            [cell.productCollectionView setCategoryDataArray:self.categoryDataArray];
            [cell.lblCategoryName setText:keyStr];
            [cell.productCollectionView setCategory:keyStr];
            [cell.productCollectionView setSortType:sort];
            [cell.segSortType setSelectedSegmentIndex:[sort isEqualToString:@"cost"] ? 0:1];
            
            NSString*urlStr = [productDic valueForKey:@"URL"];
            if (urlStr.length>0) {
                cell.productCollectionView.productListURL = [[NSURL alloc]initWithString:urlStr];
                [cell.productCollectionView getDataAndReloadFor:indexPath.row];
            }
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)updateTableViewRowDisplay:(NSArray *)arrayOfIndexPaths {
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:arrayOfIndexPaths withRowAnimation: UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)sectionHeaderWasTouched:(UITapGestureRecognizer *)sender {
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)sender.view;
    NSInteger section = headerView.tag;
    UIImageView *eImageView = (UIImageView *)[headerView viewWithTag:kHeaderSectionTag + section];
    self.expandedSectionHeader = headerView;
    if (self.expandedSectionHeaderNumber == -1) {
        self.expandedSectionHeaderNumber = section;
        [self tableViewExpandSection:section withImage: eImageView];
    } else {
        if (self.expandedSectionHeaderNumber == section) {
            [self tableViewCollapeSection:section withImage: eImageView];
            self.expandedSectionHeader = nil;
        } else {
            UIImageView *cImageView  = (UIImageView *)[self.view viewWithTag:kHeaderSectionTag + self.expandedSectionHeaderNumber];
            [self tableViewCollapeSection:self.expandedSectionHeaderNumber withImage: cImageView];
            [self tableViewExpandSection:section withImage: eImageView];
        }
    }
}

- (void)tableViewCollapeSection:(NSInteger)section withImage:(UIImageView *)imageView {
    
    NSMutableDictionary * dataDic = [[NSMutableDictionary alloc]initWithDictionary:[self.categoryDataArray objectAtIndex:section]];
    NSArray*productArray = [NSArray arrayWithArray:[dataDic valueForKey:@"PRODUCTS"]];
    self.expandedSectionHeaderNumber = -1;
    if (productArray.count == 0) {
        return;
    } else {
        [UIView animateWithDuration:0.4 animations:^{
            imageView.transform = CGAffineTransformMakeRotation((0.0 * M_PI) / 180.0);
        }];
        NSMutableArray *arrayOfIndexPaths = [NSMutableArray array];
        for (int i=0; i< productArray.count; i++) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:section];
            [arrayOfIndexPaths addObject:index];
        }
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:arrayOfIndexPaths withRowAnimation: UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}

- (void)tableViewExpandSection:(NSInteger)section withImage:(UIImageView *)imageView {
    
    NSMutableDictionary * dataDic = [[NSMutableDictionary alloc]initWithDictionary:[self.categoryDataArray objectAtIndex:section]];
    __block NSArray*productArray;
    if (![dataDic valueForKey:@"PRODUCTS"]) {
        
        NSURL*url = [NSURL URLWithString:[dataDic valueForKey:@"URL"]];
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (data) {
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSArray*arr = [[NSArray alloc]initWithArray:[json valueForKey:@"objects"]];
                [dataDic setObject:arr forKey:@"PRODUCTS"];
                [self.categoryDataArray replaceObjectAtIndex:section withObject:dataDic];
                
                if (productArray.count == 0) {
                    self.expandedSectionHeaderNumber = -1;
                    return;
                }
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self updateRowData:productArray inSection:section with:imageView];
                });
            }
            else{
                [self showAlertForCat:[dataDic valueForKey:@"CATEGORY"]];
            }

        }]resume] ;
    }
    else{
        productArray = [NSArray arrayWithArray:[dataDic valueForKey:@"PRODUCTS"]];
        if (productArray.count == 0) {
            self.expandedSectionHeaderNumber = -1;
            [self showAlertForCat:[dataDic valueForKey:@"CATEGORY"]];
            return;
        }
        productArray = [[NSArray alloc]initWithArray:[dataDic valueForKey:@"PRODUCTS"]];
        [self updateRowData:productArray inSection:section with:imageView];
    }
}

-(void)showAlertForCat:(NSString*)cate{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Not Available"
                                                                   message:[NSString stringWithFormat:@"Currently, No products avaialble for %@",cate]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * _Nonnull action) {
                                               }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)updateRowData:(NSArray*)sectionData inSection:(NSInteger)section with:(UIImageView*)imageView{
    
    [UIView animateWithDuration:0.4 animations:^{
        imageView.transform = CGAffineTransformMakeRotation((180.0 * M_PI) / 180.0);
    }];
    NSMutableArray *arrayOfIndexPaths = [NSMutableArray array];
    for (int i=0; i< sectionData.count; i++) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:section];
        [arrayOfIndexPaths addObject:index];
    }
    self.expandedSectionHeaderNumber = section;
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:arrayOfIndexPaths withRowAnimation: UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}
    

-(NSArray*)sortArray:(NSArray*)productListArray{
    
    NSSortDescriptor*sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES comparator:^NSComparisonResult(id obj1, id obj2) {
        return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
    }];
    NSArray *sortedArray = [productListArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    return sortedArray;
}

- (IBAction)sortTypeChange:(UISegmentedControl *)sender {

  NSMutableDictionary*dic = [[NSMutableDictionary alloc] initWithDictionary:[self.categoryDataArray objectAtIndex:sender.tag]];
  NSString*sort = sender.selectedSegmentIndex==0 ? @"cost" : @"name";
  [dic setObject:sort forKey:@"SORT"];
  [self.categoryDataArray replaceObjectAtIndex:sender.tag withObject:dic];
  [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:sender.tag inSection:0], nil] withRowAnimation:UITableViewRowAnimationRight];
}
- (IBAction)viewStyleChanged:(UISwitch *)sender {
    
    if (sender.isOn) {
        self.isListView = NO;
        self.numberOFRows = self.categoryDataArray.count;
    }
    else{
        self.numberOFRows=0;
        self.isListView = YES;
        self.numberOFRows = 0;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 100;
        self.expandedSectionHeaderNumber = -1;
    }
    [self.tableView reloadData];
}
@end
