//
//  collectionTableViewCell.m
//  FYND
//
//  Created by Satish Mavani on 09/10/18.
//  Copyright © 2018 FYND. All rights reserved.
//

#import "collectionTableViewCell.h"

@implementation collectionTableViewCell
@synthesize productCollectionView;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCollectionViewDataSourceDelegate{
    
    
}

@end
