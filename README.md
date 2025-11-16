# PSRICalc — Plant Stress Response Index Calculator  
### *Direct PSRI Calculation from Germination Data*

**Author:** Richard A. Feiss  
**Version:** 1.0.0  
**License:** MIT  
**Institution:** Minnesota Center for Prion Research and Outreach (MNPRO), University of Minnesota  

---

## Overview

**PSRICalc** provides clean, direct calculation of Plant Stress Response Index (PSRI) values from time-series germination data with optional radicle vigor integration. Built on the methodological foundation of the Osmotic Stress Response Index (OSRI) framework developed by Walne et al. (2020), PSRICalc offers a simplified, transparent approach suitable for agricultural research and statistical analysis.

Unlike complex optimization-based approaches, PSRICalc focuses on **direct calculation** using established germination parameters: Maximum Stress-adjusted Germination (MSG), Maximum Rate of Germination (MRG), and Mean Time to Germination (MTG).

---

## Why PSRICalc Exists

The need emerged for a standalone, reproducible method to calculate PSRI values without the complexity of full optimization workflows. Researchers needed:

- **Transparent methodology**: Clear, auditable calculations
- **Statistical compatibility**: Individual replicate values for proper ANOVA
- **Publication readiness**: Defendable, straightforward approach
- **Accessibility**: No complex optimization dependencies

PSRICalc addresses these needs by extracting the core PSRI calculation logic into a focused, user-friendly R package.

---

## Key Features

- **Direct calculation**: No iterative optimization required
- **Radicle integration**: Optional vigor assessment from radicle measurements  
- **Quality control**: Built-in mass balance validation
- **Statistical ready**: Produces individual replicate values for analysis
- **Well documented**: Complete function documentation with examples
- **CRAN compliant**: Professional R package standards

---

## Scientific Attribution

PSRICalc builds directly on the Osmotic Stress Response Index (OSRI) methodology established by:

**Walne, C.H., Gaudin, A., Henry, W.B., and Reddy, K.R. (2020).** In vitro seed germination response of corn hybrids to osmotic stress conditions. *Agrosystems, Geosciences & Environment*, 3(1), e20087. https://doi.org/10.1002/agg2.20087

---

## Installation
```r
# From CRAN (when available)
install.packages("PSRICalc")

# From source
devtools::install_github("username/PSRICalc")
```

## Basic Usage
```r
library(PSRICalc)

# Calculate PSRI from germination data
result <- calculate_psri(
  germination_counts = c(5, 8, 10),
  time_points = c(3, 5, 7),
  total_seeds = 15,
  species = "corn"
)

print(result$PSRI)
```

---

## Human–AI Development Transparency

Development followed a **collaborative human-machine process** with full human oversight. All scientific methodology, mathematical formulations, and validation were designed and conceived by the author.

AI systems (*Anthropic Claude*) provided substantial assistance with:
- R package structure and CRAN compliance
- Function implementation and code debugging
- Documentation formatting and roxygen2 syntax
- Code organization and best practices
- Professional presentation standards

AI systems did **not** contribute to:
- Scientific methodology design
- Mathematical formulations
- Biological interpretation
- Research conclusions

---

## Citation

If you use PSRICalc in your research, please cite:
```
Feiss, R.A. (2025). PSRICalc: Plant Stress Response Index Calculator. 
R package version 1.0.0.
```

## License

MIT License - see LICENSE file for details.

---

## Related Work

PSRICalc is part of a broader research ecosystem including the GALAHAD and SQUIRE optimization frameworks, but operates independently with no external dependencies beyond base R.