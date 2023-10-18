# CLAW Stain Normalization - Class-Agnostic Weighted Normalization of Staining in Histopathology Images Using a Spatially Constrained Mixture Model
### Paper Abstract
The colorless biopsied tissue samples are
usually stained in order to visualize different microscopic
structures for diagnostic purposes. But color variations
associated with the process of sample preparation, usage
of raw materials, diverse staining protocols, and using
different slide scanners may adversely influence both visual
inspection and computer-aided image analysis. As a result,
many methods are proposed for histopathology image stain
normalization in recent years. In this study, we introduce
a novel approach for stain normalization based on learning a mixture of multivariate skew-normal distributions for
stain clustering and parameter estimation alongside a stain
transformation technique. The proposed method, labeled
“Class-Agnostic Weighted Normalization” (short CLAW normalization), has the ability to normalize a source image by
learning the color distribution of both source and target
images within an expectation-maximization framework. The
novelty of this approach is its flexibility to quantify the
underlying both symmetric and nonsymmetric distributions
of the different stain components while it is considering
the spatial information. The performance of this new stain
normalization scheme is tested on several publicly available
digital pathology datasets to compare it against state-ofthe-art normalization algorithms in terms of ability to preserve the image structure and information. All in all, our
proposed method performed superior more consistently in
comparison with existing methods in terms of information
preservation, visual quality enhancement, and boosting
computer-aided diagnosis algorithm performance.
### Useful Links
- [Paper](https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=9086617&tag=1)
- [Learn more on Kimia Lab](https://kimialab.uwaterloo.ca/kimia/index.php/data-and-code-2/kimia-net/)
### Disclaimer
Rhazes Lab does not own the code in this repository. This code and data were produced in Kimia Lab at the University of Waterloo. The code is provided as-is without any guarantees, and is stored here as part of Kimia Lab's history. We welcome questions and comments.