//
//  ProductCollectionView.h
//  FYND
//
//  Created by Satish Mavani on 10/10/18.
//  Copyright © 2018 FYND. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductViewCell.h"

@interface ProductCollectionView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    
}

@property(nonatomic,retain)NSURL*productListURL;
@property(nonatomic,retain)NSArray*productListArray;
@property(nonatomic,retain)NSMutableArray*categoryDataArray;
@property(nonatomic,retain)NSString*category;
@property(nonatomic,retain)NSString*sortType;
-(void)getDataAndReloadFor:(NSInteger)row;

@end
