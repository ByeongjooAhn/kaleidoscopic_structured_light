# Kaleidoscopic Structured Light

This repsitory is an implementation of the method described in the following paper:

["Kaleidoscopic Structured Light"](http://imaging.cs.cmu.edu/kaleidoscopic_structured_light/)\
[Byeongjoo Ahn](https://byeongjooahn.com), [Ioannis Gkioulekas](https://www.cs.cmu.edu/~igkioule/), and [Aswin C. Sankaranarayanan](https://users.ece.cmu.edu/~saswin/)\
ACM Transactions on Graphics (Proc. SIGGRAPH ASIA), 2021


## Run Code
1. Download data at [this link](https://www.dropbox.com/sh/47fch29djrizdqx/AACfEVfLVuj9T_rS7TphoCdpa?dl=0) for scanned data and calibration, and place it under the `data/` directory.  The scanned data is located `data/scan/real/[dataName]`.
2. Run `demo.m` script. It includes epipolar labeling, multi-view triangulation, and computing PCA normals.

## Data
Data includes kaleidoscopic images, their *unlabeled* projector-camera correspondences, and calibration results as follows:

| dataName                       | Description                                                  |
| ------------------------------ | ------------------------------------------------------------ |
| virtual_system.mat             | Calibration results                                          |
| cat_brush                      | Scanned data for cat_brush                                   |
| elephant                       | Scanned data for elephant                                    |
| skeleton                       | Scanned data for skeleton                                    |
| skull                          | Scanned data for skull                                       |
| treble_clef                    | Scanned data for treble_clef                                 |