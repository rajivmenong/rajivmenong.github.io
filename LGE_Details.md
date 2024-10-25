## Development of a free-breathing Cardiac MRI method using motion correction

### Q: Background of this method?
Late gadolinium enhancement (LGE) was a cardiac MRI technique developed in the early 2000’s and offered a way to visualize areas of the heart that were damaged after a heart attack. This technique allowed to distinguish between viable tissue and non-viable heart tissue and take treatment decisions based on this. This technique has since become standard of clinical care. 

Although it is a widely used clinical technique it has two main drawbacks. First, it requires the cardiac patient to hold his/her breath during the scanning process to avoid breathing motion of the heart. This is uncomfortable for the patient and it slows down the image acquisition speed. About 10-12 images (which takes 10-12 breath-hold scans) are typically required to cover the heart and this takes about 15-20 minutes to acquire. Second, the clinically used LGE technique is a 2D technique and as such does not cover the heart in 3 dimensions with equal resolution.

### Q:  	What were the main challenge in this project ?
The main challenge was to develop a technique to estimate motion with minimal time penalty during imaging

### Q:  	What are outer volume suppressed projection navigators?
Outer volume suppressed projection navigators is an element of the imaging sequence that we developed using a combination of radio frequency (RF) pulses and magnetic fields that allows us to measure and correct for the breathing motion. This allows the patient in the MRI to breathe normally during the cardiac MRI acquisition. 

### Q:  	What is Late Gd Enhancement MRI?
Late Gadolinium enhancement (LGE) is an intravascular contrast agent (meaning that after being injected into the blood stream it stays within the blood vessel network and the extra-cellular matrix(ECM), but does not enter the cells), and gadolinium lights up on the MR scan. Typically, for the LGE scan, the contrast agent is injected and imaging is done 10 minutes later. If tissue is healthy, there are few gaps between cells in cardiac cells and the gadolinium is cleared out such that there is no hyperenhancemeant of the MRI signal. But when a myocardial infarct occurs (heart attack due to blood supply blockage) cellular structure around the affected area begins to break down giving more space for the Gadolinium to accumulate in the ECM. After contrast agent injection, it takes about 10 minutes for contrast agent to reach these areas where hyperenhancement is seen, thus clearly delineating the area and extent of affected tissue. This then directs medical intervention and treatment options. 


### Q: 	What are the advantages of this implementation vs the conventional implementation?
**1. Free-breathing:** This significantly increases patient comfort. More importantly patients who get cardiac imaging may be non compliant to breath hold instructions due to acute onset or may have trouble holding their breath. This will result in non- diagnostic quality images using the conventional technique while our technique vastly outperforms in such cases. This is crucial advantage in patients who are the most vulnerable.<br>
**2. 3D coverage:** our technique offers contiguous 3D coverage of the left ventricle which is better for diagnosis than 2D conventional technique.<br>
**3. Multiple views:** because our technique offers near isotropic resolution (imaging voxel is a cube in shape) the data can be reformatted offline in different views. Conventional LGE requires a separate acquisition of these alternate views. Typically in a cardiac MR exam 12-14 Slices of a “short- axis” view is taken, after which 2-4 slices in a “long-axis “ view are taken. In our method, we can get the long- axis (and other) views for free by offline refomatting of the 3D data. <br>
**4. Takes a very less amount of time:** while the conventional MRI can take up to 15 minutes to acquire data, our method takes only 3 minutes. This represents a 5-fold reduction in MRI scanning time.

### Q:      What question were you investigating in this project? Purpose
The goal of the project was the development and clinical validation of a 3D free breathing cardiac LGE MRI technique 

### Q:      What experiments did you conduct? 
The imaging sequence was first designed and developed using the scanner’s C++ based development environment. Using the developed imaging sequence, FB 3D-LGE data were obtained in 29 adult, cardiac patients who were scheduled for clinically ordered CMR exams that included the conventional breath-hold 2D-LGE scans. Contrast agent was administered intravenously. 

### Q:    What were results and discoveries? 
In this study, we developed a 3D free-breathing LGE CMR technique and developed a respiratory motion correction technique based on outer-volume- suppressed projection navigators. The time efficiency inherent in spiral encoding along with 100% navigator efficiency allowed for 3D acquisition with near-isotropic resolution in scan times as short as 2.5 min. The free- breathing nature of the 3D LGE sequence reduces patient fatigue, and is particularly beneficial for patients who have trouble with breath-holding, thus reducing the likelihood of image artifacts. The 3D encoding ensures contiguous LV coverage and prevents slice misregistration errors, potentially allowing for more accurate quantification of myocardial volume. 

Using the new technique the MRI image quality and diagnostic quality was similar to the conventional technique. Myocardial infarcts were identified in 5 of the 29 patients and the calculated volume of the infarcted area using the two techniques were in excellent agreement. 

The FB 3D-LGE offers near-isotropic resolution and contiguous LV coverage, in significantly shorter imaging time than the clinically used BH 2D-LGE, while delivering similar image quality and diagnostic value. 
		
### Q:    What is the significance of your research? How does it impact your field/healthcare?
The free-breathing 3D-LGE technique is a viable option for patients, particularly in acute settings or in patients who are unable to comply with breath-hold instructions.

This results in a 5-fold reduction in the time required for this cardiac scan while simultaneously providing a better patient experience. Additionally improves the accuracy of results in patients 

### Publication
RG Menon, GW Miller, J Jeudy, S Rajagopalan, T Shin. “Free-breathing 3D Late Gadolinium Enhancement MRI using Outer Volume Suppressed Projection Navigators.” Magnetic Resonance in Medicine, 2017

### Conference Talk
Free-breathing 3D late gadolinium enhancement cardiovascular magnetic resonance using outer volume suppressed projection navigators: Development and clinical validation, ISMRM Conference, Singapore, 2016
