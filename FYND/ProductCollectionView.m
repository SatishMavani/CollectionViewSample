//
//  ProductCollectionView.m
//  FYND
//
//  Created by Satish Mavani on 10/10/18.
//  Copyright © 2018 FYND. All rights reserved.
//

#import "ProductCollectionView.h"

@implementation ProductCollectionView

@synthesize productListURL;
@synthesize productListArray,categoryDataArray;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 
*/

-(void)getDataAndReloadFor:(NSInteger)row{
    
    NSMutableDictionary*dataDic = [[NSMutableDictionary alloc]initWithDictionary:[categoryDataArray objectAtIndex:row]];
    
    if (![dataDic valueForKey:@"PRODUCTS"]) {
        
        if(self.productListURL){
            NSURLSession *session = [NSURLSession sharedSession];
            [[session dataTaskWithURL:self.productListURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                self.productListArray = [[NSArray alloc]initWithArray:[json valueForKey:@"objects"]];
                [self SortArray];
                NSArray*temp = [[NSArray alloc]initWithArray:self.productListArray];
                [dataDic setObject:temp forKey:@"PRODUCTS"];
                
                [self.categoryDataArray replaceObjectAtIndex:row withObject:dataDic];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self reloadData];
                });
            }]resume] ;
        }
    }
    else{
        self.productListArray = [[NSArray alloc]initWithArray:[dataDic valueForKey:@"PRODUCTS"]];
        [self SortArray];
        [self reloadData];
    }
}

-(void)SortArray{
    
    NSSortDescriptor *sortDescriptor;
    if ([self.sortType isEqualToString:@"name"]) {
        sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES comparator:^NSComparisonResult(id obj1, id obj2) {
            return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
        }];
    }
    else{
        sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"cost" ascending:YES];
    }
    NSArray *sortedArray = [productListArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];

    productListArray = [[NSArray alloc]initWithArray:sortedArray];
}

#pragma mark - CollectionView Delegate



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.productListArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"ProductViewCell";
    ProductViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blueColor];
    
    NSString*strPrice = [[productListArray objectAtIndex:indexPath.row] valueForKey:@"cost"];
    cell.productImage.image = [UIImage imageNamed:self.category];
    cell.lblProductName.text = [[productListArray objectAtIndex:indexPath.row] valueForKey:@"name"];
    cell.lblProductPrice.text = [NSString stringWithFormat:@"₹%@",strPrice];

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((CGRectGetHeight(collectionView.frame)/3), (CGRectGetHeight(collectionView.frame)/2)-10);
}

@end
