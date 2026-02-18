# impIndicator 0.6.0

- Create the prepare_indicators_bootstrap function which returns parameters need for
bootstrapping and confidence interval via the dubicube

- Make the prepare_indicators_bootstrap to use only impact cube object. An impact cube is 
an object that contain occurrence cube and impact data. It can save the computational time
due to recombining during a multiple computation from a set of data such as bootstrapping.

# impIndicator 0.5.0

-   Add cross_validation result to README using the Acacia example
-   Create and export function to create occurrence cube with impact data (impact_cube_data)

# impIndicator 0.4.0

-   Allow users to specify region for the indicator to be calculated on. The occurrence is intersected with the region provided as shapefile in the indicator functions.

# impIndicator 0.3.2

-   Use GBIF occurrence cube as example

# impIndicator 0.3.1

-   Correct versioning in codemeta file

# impIndicator 0.3.0

-   Improve logo

-   Improve Readme and vignettes for b-cuded website

-   Styling of README and vignettes for b-cuded website

-   Return indicators' information

-   

# impIndicator 0.2.0

-   Improve function names according to B-cubed guidelines

-   Add descriptions to exported functions

-   Move helper functions to R/utils.R

# impIndicator 0.1.1

# impIndicator 0.1.0

-   Set up basic package structure.

# impIndicator 0.0.0

-   Added a `NEWS.md` file to track changes to the package.
