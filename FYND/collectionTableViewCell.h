//
//  collectionTableViewCell.h
//  FYND
//
//  Created by Satish Mavani on 09/10/18.
//  Copyright © 2018 FYND. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCollectionView.h"

@interface collectionTableViewCell : UITableViewCell{
    
}
@property (strong, nonatomic) IBOutlet ProductCollectionView *productCollectionView;
@property (strong, nonatomic) IBOutlet UILabel *lblCategoryName;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segSortType;

@end
