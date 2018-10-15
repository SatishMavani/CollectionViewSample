//
//  ProductViewCell.h
//  FYND
//
//  Created by Satish Mavani on 10/10/18.
//  Copyright © 2018 FYND. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblProductName;
@property (strong, nonatomic) IBOutlet UILabel *lblProductPrice;
@property (strong, nonatomic) IBOutlet UIImageView *productImage;

@end
