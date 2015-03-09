//
//  EC.h
//  prrr
//
//  Created by Daniele Ciriello on 18/11/14.
//  Copyright (c) 2014 Daniele Ciriello. All rights reserved.
//

#ifndef __prrr__EC__
#define __prrr__EC__

#include <pcl/ModelCoefficients.h>
#include <pcl/point_types.h>
#include <pcl/io/pcd_io.h>
#include <pcl/filters/extract_indices.h>
#include <pcl/filters/voxel_grid.h>
#include <pcl/features/normal_3d.h>
#include <pcl/kdtree/kdtree.h>
#include <pcl/sample_consensus/method_types.h>
#include <pcl/sample_consensus/model_types.h>
#include <pcl/segmentation/sac_segmentation.h>
#include <pcl/segmentation/extract_clusters.h>
#include <pcl/visualization/pcl_visualizer.h>


class EuclideanClustering{
public:
    EuclideanClustering(std::string input_filename_, float leaf_size_);

    void run();
private:
    std::string input_filename;
    float leaf_size;

    
};
#endif
