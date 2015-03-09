//
//  CR.h
//  prrr
//
//  Created by Daniele Ciriello on 13/11/14.
//  Copyright (c) 2014 Daniele Ciriello. All rights reserved.
//

#ifndef __prrr__CR__
#define __prrr__CR__




#include <stdio.h>


#ifdef check
#undef check
#endif
#include <pcl/io/pcd_io.h>
#include <pcl/point_cloud.h>
#include <pcl/correspondence.h>
#include <pcl/features/normal_3d_omp.h>
#include <pcl/features/shot_omp.h>
#include <pcl/features/board.h>
#include <pcl/keypoints/uniform_sampling.h>
#include <pcl/recognition/cg/hough_3d.h>
#include <pcl/recognition/cg/geometric_consistency.h>
#include <pcl/visualization/pcl_visualizer.h>
#include <pcl/kdtree/kdtree_flann.h>
#include <pcl/kdtree/impl/kdtree_flann.hpp>
#include <pcl/common/transforms.h>
#include <pcl/console/parse.h>
#include <boost/date_time/posix_time/posix_time.hpp>
#include <boost/thread/thread.hpp>

typedef pcl::PointXYZRGB PointType;
typedef pcl::Normal NormalType;
typedef pcl::ReferenceFrame RFType;
typedef pcl::SHOT352 DescriptorType;
typedef boost::signals2::signal<void ()>  signal_t;

class CorrespondenceGrouping
{
public:
    CorrespondenceGrouping();
    
    CorrespondenceGrouping(std::string model_filename_,
                           std::string scene_filename_,
                           bool show_keypoints_,
                           bool show_correspondences_,
                           bool use_cloud_resolution_,
                           bool use_hough_,
                           bool transform_model_,
                           float model_ss_ ,
                           float scene_ss_,
                           float rf_rad_ ,
                           float descr_rad_,
                           float cg_size_,
                           float cg_thresh_);
    
    CorrespondenceGrouping(std::string model_filename_,
                           std::string scene_filename_);
    
    CorrespondenceGrouping(std::string model_filename_,
                           std::string scene_filename_,
                           bool show_keypoints_,
                           bool show_correspondences_,
                           bool use_cloud_resolution_,
                           bool use_hough_);
    
    void setupDefaultValues();
    void run ();
    void stop();
    void setParent(id _parent);
    double computeCloudResolution (const pcl::PointCloud<PointType>::ConstPtr &cloud);
    void transformCloud (pcl::PointCloud<PointType>::Ptr &cloud);
private:
    std::string model_filename;
    std::string scene_filename;
    //Algorithm params
    bool show_keypoints = false;
    bool show_correspondences = false;
    bool use_cloud_resolution = false;
    bool use_hough = true ;
    bool transform_model = false ;
    float model_ss = 0.01f;
    float scene_ss = 0.03f;
    float rf_rad = 0.015f;
    float descr_rad = 0.02f;
    float cg_size = 0.01f;
    float cg_thresh = 5.0f;
    bool stopValue;
//    pcl::visualization::PCLVisualizer viewer;

};


#endif /* defined(__prrr__CR__) */
