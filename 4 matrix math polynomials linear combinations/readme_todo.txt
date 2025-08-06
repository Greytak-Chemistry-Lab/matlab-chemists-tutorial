This unit is mainly meant to demonstrate matrix math, and its use for 1) polynomial fits and 2) linear combination fits. It also includes some examples with varying degrees of complexity.

Tutorial part 1: Demonstrates calculating y values from x values with a polynomial (quadratic) function, and recovering polynomial coefficients from simulated noisy data. Generates its own fake data: no external example data. Is complete.

Simple polynomial fit example(s): polynomial_fit_intensity_profile: fit a slowly-varying background with a polynomial, and obtain peak heights/areas. This uses a microscope image profile line, with example data file and is complete. Would be good to add one(s) with fit of Raman background from N-methylformamide lab or O2 lab NIR absorption from 541L/542L.


Tutorial part 2: Demonstrates linear combination fits with lsqnonneg. Generates its own fake data: no external example data, though it refers to "polynomial fit intensity profile" example.

lsqnonneg_demo.m: another simple demo with fake data. TODO: Should be described in Tutorial part 2 as an additional example of the same thing, but isn't currently.

QD_dye_example: this should perhaps be moved into "linear combination fit with lsqnonneg" folder, or things in there should be spun out. In any case, this should be a simple fit of a QD-dye conjugate absorption spectrum as a sum of the two components. There should be a basic version that does not use any of our custom functions, and a more advanced version that does. 
TODO: Examples of this fitting script exist, but the stub that's in there now is un-related to them. 

Cu-cryptand example: a more advanced model that should explore several levels of Matlab / chemical concepts. Example data is a series of UV-vis absorption spectra of a copper-cryptand complexation system at a series of total concentrations. Need script templates to describe fit in terms of 2 components, 3 components, and extraction of equilbrium constants and component spectra, and a narrative or Powerpoint presentation that describes the chemical problem (put some of this together elsewhere for Caryn Outten lab). TODO: Put all this together without (and with?) the use of our custom functions.



