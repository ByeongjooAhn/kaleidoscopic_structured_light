# Kaleidoscopic Structured Light

This repsitory is an implementation of the method described in the following paper:

["Kaleidoscopic Structured Light"](http://imaging.cs.cmu.edu/kaleidoscopic_structured_light/)\
[Byeongjoo Ahn](https://byeongjooahn.com), [Ioannis Gkioulekas](https://www.cs.cmu.edu/~igkioule/), and [Aswin C. Sankaranarayanan](https://users.ece.cmu.edu/~saswin/)\
ACM Transactions on Graphics (Proc. SIGGRAPH ASIA), 2021


## Run Code
1. Download `lib/lib_convnlos/mex/complie_mex.m` to complie mex codes.
2. Run `demo.m` script. It includes epipolar labeling, multi-view triangulation, and computing PCA normals.

## Data
Data can be download at this link: It includes *unlabeled* projector-camera correspondences and calibration results as follows:

| data                      | Description                                                  |
| ------------------------------ | ------------------------------------------------------------ |
| virtual_system.mat             | Calibration results                                          |
| cat_brush                      | Scanned data for cat_brush                                   |
| elephant                       | Scanned data for elephant                                    |
| skull                          | Scanned data for skull                                       |
| treble_clef                    | Scanned data for treble_clef                                 |