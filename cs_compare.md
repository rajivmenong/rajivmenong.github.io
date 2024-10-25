## Comparison of Compressed Sensing Algorithms for accelerating quantitative MRI Brain mapping

**Project description:** We compared the performance of 5 compressive sensing
(CS) algorithms with acceleration factors (AF) up to 10. We evaluated image quality and T1ρ estimation errors as a function of AF. Six healthy volunteers were recruited and they underwent T1ρ imaging of the whole brain with full Cartesian acquisition. Assessment of image reconstruction and T1ρ estimation errors in this study show that the CS method using spatial and temporal finite differences as a regularization function performs the best for accelerating T1ρ quantification in the brain.

### Methods
3D-Brain MRI data were acquired. The fully sampled reconstruction served as the reference, and the resulting T1ρ maps were used to compare the performance of the CS algorithms used. The reference images were reconstructed with SENSE, with coil sensitivity maps estimated using the ESPIRiT algorithm. The fully sampled dataset was retrospectively undersampled with a 2D Poisson-disk to simulate AF (AF= 2,5,10). Five different CS reconstruction models were tested with regularization functions: spatial and temporal finite differences (STFD), exponential dictionary (DIC), 3D wavelet transform (WAV), low-rank (LOW), and low-rank plus sparse model with spatial finite differences (LPS-SFD). Three techniques (STFD, DIC, WAV) used an l1-norm penalty, LOW used a nuclear norm, and the LPS-SFD used where L used nuclear norm, and the S used an l1-norm regularization penalty.

### Results

<img src="images/Figure1.PNG?raw=true"/>
<br><br>
<img src="images/Figure2.PNG?raw=true"/>
<br><br>
<img src="images/Figure3.PNG?raw=true"/>
<br><br>
<img src="images/Figure4.PNG?raw=true"/>
<br><br>
<img src="images/Figure5.PNG?raw=true"/>

### DISCUSSION
The results in this study suggest that while at lower AF the choice of CS method is insignificant, at higher AF, the highest gain is obtained from using the STFD technique. The performance of the low rank technique is comparable but worse when compared to the STFD technique. Although L+S method is a promising approach, its performance is not better than the other techniques. The combination of first order spatial and second order temporal finite differences provides excellent performance, but the regularization parameters have to be chosen carefully to avoid being over- regularized. 
