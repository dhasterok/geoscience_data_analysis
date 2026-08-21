# Geoscience Data Analysis --- Revised Outline (v2)

## Framing

Two parts. **Part I** is portable method (any quantitative field). **Part II** is where
those methods meet real Earth-science data --- and is where the book's geoscience identity
lives. Ten focused chapters rather than six sprawling ones: the breadth course benefits
from small, single-purpose chapters held together by the two-part grouping.

**Non-parametric methods are a woven theme**, flagged `[NP]`, concentrated in Ch 4 but
reappearing wherever they're the right tool (robust regression, censored data,
Lomb–Scargle, KDE, smoothing).

### Tag legend
- `[NEW]` add · `[EXPAND]` develop a stub · `[FIX]` structural fix · `[NP]` non-parametric
- `[THREAD-arc]` arc crustal-thickness/elevation data (continuity)
- `[THREAD-zircon]` detrital-zircon provenance (the non-parametric spine: KDE → distribution
  comparison → MDS)
- `[GUEST: …]` deliberately different dataset, to signal breadth
- Boxes (`notes.sty`): *(core)* derivation · *(mathtool)* math refresher ·
  *(alert)* caveat/limit · *(aside)* commentary

---

# PART I --- GENERAL METHODS

## Ch 1 --- Distributions & Sampling
*Question: what does my data look like, and how do I characterise it?*

- 1.1 Introduction *(aside: errors vs uncertainties)*
  - 1.1.1 `[NEW]` Two views of probability --- frequentist vs Bayesian framing, brief *(aside)*
- 1.2 Describing data --- types · PDF/CDF · averages *(aside: the "average" gripe)* · moments
  - *(alert: a mean & SD describe multimodal/mixed data poorly --- sets up the zircon case)*
- 1.3 Common parametric distributions --- normal *(core)* · log-normal *(core)* · power-law ·
  Poisson · (von Mises forward-referenced to the directional section)
- 1.4 `[NEW]` Transforming to normality --- log · Box–Cox · logit *(alert: what it does to
  units & error bars; cross-ref Ch 7 log-ratios)*
- 1.5 `[MOVED] [NP]` **Empirical density estimation (KDE)** --- moved ahead of propagation;
  it characterises distributions, it isn't uncertainty propagation
  - *(mathtool: kernel & bandwidth; alert: bandwidth choice drives the result)*
  - `[THREAD-zircon]` detrital age spectra are multimodal mixtures of source terranes --- the
    mean age is no real source; motivates KDE *and* retroactively earns the 1.2 "average" aside
- 1.6 Sampling --- natural vs observational variability · sample size · how small *n* degrades
  both a parametric fit and a KDE

## Ch 2 --- Uncertainty: Propagation & Simulation
*Question: given quantities I'm unsure of, how does that uncertainty move through a calculation?*
*(This is the natural cut from Ch 1 --- a genuine change of intellectual activity.)*

- 2.1 Synthetic data --- generating random draws *(mathtool: RNG, seeds, reproducibility)*
- 2.2 Propagation of errors --- analytical, first-order *(core: general formula)*
  - arithmetic mean · linear · reciprocal · ratios · exponential
  - *(alert: independence assumption; where covariance terms enter)*
- 2.3 Monte Carlo analysis --- CLT · propagation by simulation *(aside: Manhattan-Project origin)*
- 2.4 `[NEW]` Propagation vs simulation --- when each wins *(alert)*; forward-ref to the
  resampling family in Ch 4

## Ch 3 --- Parametric Inference
*Organised by the question a test answers --- not by whether it needs normality (that property
cuts across tests and is flagged per test). Closes with the normality "hinge".*

- 3.1 What is statistical inference?
- 3.2 Confidence --- confidence interval · level of significance
- 3.3 Location --- Z · t (one- & two-sample, paired) *(alert: equal-n two-sample t is very
  skew-robust; one-sample is not)*
- 3.4 Scale / variance --- F-test · Bartlett *(alert: both are dangerously kurtosis-sensitive;
  prefer Levene / Brown–Forsythe --- "rowboat to test the ocean")*
- 3.5 Association --- covariance · Pearson correlation (rank correlation deferred to 4.x) *(core)*
- 3.6 Distribution shape / goodness-of-fit --- χ² · Shapiro–Wilk · K–S · Anderson–Darling
- 3.7 Counts & categorical --- χ² contingency · exact binomial / Poisson
- 3.8 `[NEW]` Bayesian inference (brief) --- prior/likelihood/posterior · one conjugate example ·
  MCMC named-only *(aside: philosophy; mathtool: Bayes' rule)*
- 3.9 `[NEW]` Effect size & the limits of p-values *(alert + aside)* --- aimed at research students
- 3.10 `[NEW]` **How much does normality matter?** *(core hinge section)* --- the bridge to Ch 4:
  it's the sampling distribution of the *statistic* that must be ~normal, not the data;
  skewness error ~1/√n, kurtosis ~1/n, so required n scales as skewness²; location-robust,
  scale-NOT-robust; multimodality breaks the *estimand*, not just validity
  - *(alert: do NOT use a normality test as a gatekeeper --- it's lenient when you need
    strictness (small n) and strict when you need leniency (large n))*

## Ch 4 --- Distribution-free & Non-parametric Inference
*Now a first-class chapter, signalling that distribution-free methods are a primary toolkit
for messy Earth data --- not a last resort.*

- 4.1 Order & rank statistics `[NP]` --- the foundation for what follows
- 4.2 Rank correlation --- Spearman ρ · Kendall τ `[NP]` *(alert: when monotonic-nonlinear or
  outlier-prone data make Pearson misleading)*
- 4.3 Distribution-free tests `[NP]` *(core: the rank logic; alert: ties/assumptions)*
  - sign · Wilcoxon signed-rank · Mann–Whitney U / rank-sum · Kruskal–Wallis
  - `[THREAD-arc]` island vs continental arcs (Moho/elevation) as the two-sample example
- 4.4 Whole-distribution comparison `[NP]` --- two-sample K–S · Kuiper
  - `[THREAD-zircon]` comparing detrital spectra between samples *(alert: legitimate but
    debated for age spectra --- a teachable caveat)*
- 4.5 Resampling & permutation inference `[NP]` *(core)* --- permutation/randomisation tests ·
  jackknife · bootstrap CIs (cross-ref MC in Ch 2, regression bootstrap in Ch 5)
- 4.6 Robust statistics & outliers `[NP]` --- median/MAD/trimmed/Winsorised · IQR & MAD
  outlier rules · Grubbs *(alert: Grubbs assumes normality)* --- cross-ref regression
  leverage (5.7)
- 4.7 Sequence tests `[NP]` --- runs test · single change-point test (multiple change-points /
  segmentation deferred to Ch 10)
- 4.8 `[STANDALONE]` **Directional & circular statistics** --- sits outside the
  parametric/non-parametric divide as its own framework: von Mises distribution, circular &
  spherical descriptive statistics (from old 1.2.9–10) + directional tests (old 2.5)
  - `[GUEST: structural/paleomag]` fault or palaeomagnetic orientations
  - *Option:* promote to its own short chapter, or move to Part II beside compositional data
    as "constrained-geometry data"

## Ch 5 --- Regression & Curve-Fitting  *(CLOSED DESIGN --- builder-ready)*
*Source key: `[INV-lift]` = transplant near-verbatim from `inversion.tex`; `[INV-light]` =
lift but trim geophysics; `[INV-leave]` = deliberately NOT brought over. Dataset thread is the
arc elevation/crustal-thickness set (full table once in App. B). Default code pattern: see
"Code: own vs library" in Conventions below.*

- 5.1 Introduction & framing
  - plain-sentence-first: what regression *is* in one sentence before any symbols
  - curve-fitting = estimation = regression = inversion = training --- same math, different
    vocabulary `[INV-lift: comparative terminology table, box:inverse_terms]` --- promote to
    prominent early placement (keep as *aside* box but call it out from the body)
  - the conceptual shift: not "which single model is correct" but "which models are
    compatible with the data + assumptions" `[INV-light: curve-fitting framing paras]`
  - optional: forward vs inverse with the y=mx example `[INV-light]`
  - `[INV-leave]` forward operator · model/data space · discretization (geophysics-specific).
    Rumsfeld known/unknown quadrants are NOT dropped --- they relocate to 7.5 (censored data),
    where below-detection-limit values are the natural entry point to the
    information-vs-knowledge idea.
- 5.2 Measures of misfit --- residual · L² norm · RMS · normalised RMS · χ² `[FIX numbering gap]`
  `[INV-light: sec:misfit]` *(core: misfit definitions; alert: L² vs L¹ outlier sensitivity →
  forward-ref 5.7)*
- 5.3 The shape of the problem --- under/over-determined · uniqueness · stability/conditioning ·
  inversion recipes `[INV-light]` *(mathtool: condition number)* --- anchor of the recurring
  "when to use what" thread
- 5.4 Linear least squares **(chapter centerpiece)**
  - scalar derivation `[INV-lift: box:llsq, already streamlined]` --- *aside*, skippable, with
    its closing forward-pointer to the matrix form
  - matrix form **A m = d**, pseudo-inverse, normal equations `[INV-lift]` *(core / coreeq)*
  - **plant orthogonality here** (AᵀA, Aᵀr = 0) --- the reusable framing; do NOT bury it in the
    skippable scalar box; echoes in PCA (6.4.1)
  - polynomials & multivariate
  - **CODE FLAGSHIP --- agree-then-diverge:** from-scratch normal equations (matches text) +
    `np.linalg.lstsq`; show they agree, then the ill-conditioned case where forming AᵀA squares
    the condition number and lstsq (QR/SVD) wins *(alert + mathtool: conditioning)* --- the
    distinctive teaching moment of the chapter
  - 0-based pseudocode in body
- 5.5 Incorporating uncertainty (weighted LSQ)
  - WLLSQ + model covariance **C_m = (AᵀW²A)⁻¹**, reduction to σ²(AᵀA)⁻¹ `[INV-lift]` *(core)*
  - `[FIX]` this is the CORRECT general form --- replaces the §3.4.3 formula that had the ν−1
    slip; CI via Student-t with ν = N − M
  - bootstrapping `[NP]` (own loop; cross-ref 4.5)
- 5.6 Errors in x and y --- Deming/orthogonal · Monte Carlo *(cross-ref: PC1 = orthogonal-
  distance line, 6.4.1)*
- 5.7 Leverage, outliers & robust regression
  - leverage via the hat matrix (natural now the matrix form exists) · outlier detection
  - 5.7.x `[NEW] [NP]` robust & non-parametric --- Theil–Sen · RANSAC · Huber · quantile (brief)
    *(alert: breakdown point; detect ≠ delete)*
  - CODE: leverage *figure* carries it (don't print a hat-diagonal table); robust fits via
    library (sklearn/scipy), note Theil–Sen is simple enough to show from scratch
- 5.8 `[NEW]` **Mixed populations & Simpson's paradox** --- the relationship-level aggregation
  hazard, with NO visual warning in the pooled fit (highest-cost case)
  - within/between covariance decomposition *(core or mathtool box)*:
    Cov(X,Y) = E[Cov(X,Y|g)] + Cov(E[X|g], E[Y|g])
  - worked example: pooled fit clean & tight but slope is none of the real slopes / opposite
    sign --- **try the arc data itself** (island vs continental arcs may carry different
    slopes; reuses the 4.3 two-sample split → one dataset, two lessons). Guest set as fallback.
  - **AGGREGATION ALERT fires here** (see Conventions motif)
  - diagnostic: colour by suspected group *before* pooling; pointer to grouped / mixed-effects
    regression (named, light)
- 5.9 Non-linear regression --- linearising *(alert: linearising distorts the error structure ---
  transforming changes what least-squares optimises)* · 5.9.x `[FIX]` Newton–Raphson /
  root-finding (currently mislabeled "6.7.2") · Gauss–Newton / Levenberg–Marquardt
  `[INV-light]`
  - CODE: simple Gauss–Newton from scratch (understanding) + `scipy.optimize` (production ---
    hand-rolled LM is a chapter unto itself; library category)
- 5.10 `[EXPAND]` Regularization *(core + mathtool)* --- damping / Tikhonov `[INV-lift]` +
  **tethered-goat analogy** `[INV-lift → aside]` · ridge from (AᵀWA + λI) · lasso intuition
  (L¹, named) · L-curve for choosing λ `[INV-lift]` *(alert: bias–variance trade-off)*
  - CODE: ridge is own (add λI --- trivial, matches text)
  - `[INV-leave]` smoothing operators L₁/L₂ · Occam · bounded constraints --- one-line mention
    that roughness penalties exist for spatially distributed parameters, cross-ref Ch 8
- 5.11 `[NEW]` Model selection & diagnostics --- overfitting · residual analysis · R²/adjusted R²
  · cross-validation `[NP]` (own loop) · AIC/BIC named *(alert: overfitting; high R² ≠ right
  model --- tie back to 5.8)*
- 5.12 `[NEW]` Bayesian view (brief, the unifying closer) --- posterior ∝ likelihood × prior;
  weighted + regularized LSQ = MAP under Gaussian noise + Gaussian prior `[INV-lift: Bayesian
  punchline para]` *(aside: philosophy; mathtool: Bayes' rule)* --- retroactively unifies 5.5,
  5.10; cross-ref the brief Bayesian inference in 3.8

## Ch 6 --- Multivariate Analysis
- 6.1 Visualising multivariate data --- heat map · 6.1.3 `[EXPAND]` scatter-matrix ·
  contour/surface · radar
- 6.2 `[REFRAME]` Matrix formulation of the basics --- re-cast mean/centering/covariance/
  correlation as linear-algebra setup for PCA; cross-ref Ch 1 & 3 so it reads as deliberate
  *(mathtool: centering matrix)*
- 6.3 Metrics --- Euclidean · Mahalanobis · cosine · city-block · Frobenius
- 6.4 Dimensional reduction
  - 6.4.1 PCA *(core + mathtool: eigen/SVD)* --- `[FIX]` PC1 minimises orthogonal distance
    (= Deming line), not vertical residuals
  - 6.4.2 MDS --- `[THREAD-zircon]` classical MDS for comparing detrital samples against
    candidate source terranes (Vermeesch) --- the provenance spine lands here
  - 6.4.3 LDA · 6.4.4 NMF · 6.4.5 Factor analysis
  - 6.4.6 `[NEW]` **t-SNE** --- full section, math light *(alert: preserves local
    neighbourhoods only --- inter-cluster distances & cluster sizes are NOT meaningful;
    perplexity- and seed-dependent; for visual hypothesis generation, not metric inference)*
  - 6.4.7 `[NEW]` **UMAP** --- full section, math light *(alert: same cautions;
    `n_neighbors`/`min_dist` dependent)*
    - `[NEW]` worked comparison: PCA vs UMAP on the same geochemical set --- PCA gives
      interpretable axes, UMAP gives cleaner separation but no axis meaning; the trade-off
      *is* the lesson
- 6.5 Cluster analysis --- k-means/hierarchical `[FIX numbering]` · fuzzy c-means · spectral
  - 6.5.x `[NEW]` Choosing k --- **elbow plot** (within-cluster SS vs k) + silhouette
    *(alert: elbow is often ambiguous/subjective; mention gap statistic as the principled
    cousin; all three can disagree --- k is ultimately a domain decision)*
- 6.6 Stochastic clustering methods
- `[THREAD-arc]` PCA on the arc data; `[GUEST: geochemistry]` PCA again on a major/trace set ---
  same method, familiar + unfamiliar data

---

# PART II --- GEOSCIENCE APPLICATIONS

## Ch 7 --- Compositional Data (Geochemistry)
- 7.1 Introduction *(aside: why "just normalise it" fails)*
- 7.2 Aitchison geometry / simplex --- simplex · closure *(alert: spurious correlation from
  closure)* · 7.2.3 `[EXPAND]` mean of compositional data · operations on the simplex
- 7.3 Transformations --- alr · clr · ilr *(core + mathtool: log-ratios)*
- 7.4 Proportionality --- variation matrix τ_ij = var(ln(x_i/x_j)) as the key diagnostic
- 7.5 Censored / below-detection data --- good & bad practice *(alert)* · distributions
  - 7.5.4 `[EXPAND] [NP]` hypothesis testing on censored data
  - 7.5.5 `[EXPAND]` regression on censored data
  - 7.5.6 `[NEW] [NP]` imputation & the survival-analysis link (Kaplan–Meier / ROS for
    below-DL values) --- the geoscience face of "missing data"
- 7.6 Visualising geochemistry --- ternary · spider/REE
- 7.7 `[NEW]` **Worked example: PCA under three transforms** --- the centrepiece figure of the
  chapter; keep all three plots and make the disagreement the point *(core + alert)*
  - raw wt% PCA is driven by *absolute* variance → SiO₂/MgO → recovers the mafic–felsic and
    melting trends "for free" (still formally invalid --- closure *alert*)
  - clr/ilr care about *relative* variance → K₂O (most incompatible) and P₂O₅ lead, SiO₂
    nearly drops out (smallest proportional variation) --- the result is *correct*, just
    unfamiliar
  - **diagnostics to show, not assert:** clr-variance-per-oxide table vs raw-variance table
    (they're nearly anti-sorted); the variation matrix τ_ij
  - *(alert: check P₂O₅/K₂O behaviour near detection limit FIRST --- near-zero/imputed values
    manufacture spurious log-variance and hijack a component; links straight to 7.5)*
  - ilr opacity: same eigenvalues/geometry as clr but loadings are in an arbitrary balance
    basis → uninterpretable unless you design the sequential binary partition from petrology
    (felsic-vs-mafic balance, alkali balance, …) or use principal balances; or back-project
    ilr loadings to clr for the covariance biplot
  - subcompositional coherence: analyse abundance carriers (SiO₂,Al₂O₃,FeO,MgO,CaO) and
    incompatible minors (K₂O,P₂O₅,TiO₂,Na₂O) separately → two clean signals from one dataset
  - one-line framing: *raw PCA asks where the mass moves; log-ratio PCA asks where the
    proportions move --- and in igneous suites those are different questions*
  - refs: Aitchison; Egozcue & Pawlowsky-Glahn (ilr, balances); Greenacre (biplots)

## Ch 8 --- Interpolation & Geostatistics
*Source note: Olea (2009/2018), USGS OFR 2009–1103 "A Practical Primer on Geostatistics" ---
**public domain** (USGS), so figures/framings are freely adaptable (check any individually-marked
copyrighted figure first). Goes far deeper on kriging/simulation than this course needs; use as a
starting point, stay introductory.*
- 8.1 Interpolation (1-D) --- nearest-neighbour · linear · polynomial · cubic spline `[NP]`
  *(mathtool: spline continuity)*
- 8.2 Extrapolation *(alert: the dangers --- keep prominent)*
- 8.3 Two-dimensional interpolation --- scattered data · gridding · mosaic grids
- 8.4 Geostatistics
  - 8.4.0 `[NEW]` **How spatial data breaks classical assumptions** --- the "why is this a
    different chapter?" motivation; place BEFORE variograms; the Part II structure-marginalized-
    vs-modeled pivot made concrete. *(core or mathtool: a two-column contrast box,
    "geostatistics vs classical statistics")* --- iid → spatially correlated (correlation is the
    *signal*, not a nuisance); many realisations of one RV → **one realisation of a random
    function** (one draw of the Earth); location ignored → **location is data**; point value →
    **support** (a grade on a drill core ≠ on a mining block; no classical analogue; underlies
    block kriging & change-of-support). *(aside: the **ergodic assumption** --- one realisation
    taken as enough to infer ensemble properties, untestable by construction; pairs with the
    aggregation-humility thread)*
  - 8.4.1 `[NEW]` Stationarity & the intrinsic hypothesis *(core + alert)* --- second-order /
    intrinsic; reused in Ch 10
  - 8.4.2 `[NEW] [NP]` Spatial autocorrelation (Moran's I)
  - 8.4.3 `[NEW]` **Declustering** --- geologic sampling is almost always clustered (high-grade
    zones, outcrops, roads). Kriging is robust to it, but **parameters inferred from the sample
    first --- the histogram, the mean --- are distorted**, worst at small n. The clustered mean is
    "an average across processes weighted by where you sampled" → **direct spatial instance of
    the aggregation motif (cross-ref 5.8)**. Detect: CDF of nearest-neighbour distance. Fix at
    concept level: **cell declustering** (inverse-count weights) and **polygonal/Voronoi
    declustering** (Voronoi-cell-area weights --- ties to 8.1 nearest-neighbour & Ch 9
    Voronoi/Delaunay). Payoff figure: raw vs declustered histogram/mean on a real clustered set.
    *(alert: your summary stats lie before you ever krige)* --- keep introductory; skip Olea's full
    nearest-neighbour-transfer algorithm
  - 8.4.4 Variograms *(already strong)*
  - 8.4.5 `[EXPAND]` **Kriging** --- currently the variogram is built but the *estimator* isn't:
    add the ordinary-kriging system & weights from the fitted variogram, the Lagrange
    multiplier, and the **kriging variance** (the thing that makes it more than IDW);
    simple vs ordinary vs universal; variogram-model cross-validation; **block kriging** as the
    change-of-support case (cross-ref the support concept in 8.4.0)
    *(core + mathtool; alert: stationarity assumption, smoothing artefacts)*
  - 8.4.6 `[NEW]` Gaussian processes as the generalisation, named-only *(aside)*
- 8.5 Producing profiles --- projecting irregular data · gridded data · projecting geographic data
- `[GUEST: non-geochem geospatial]` ore grade / heat flow / water-table elevation --- so
  geostatistics doesn't read as a geochemistry technique
- `[voice thread]` Olea's "uncertainty is not a property of the system but of incomplete
  knowledge by the observer" = the same epistemology as the relocated Rumsfeld quote (7.5). A
  unifying Part II stance --- *uncertainty lives in the observer, not the rocks* --- linking censored
  data, declustering, and kriging variance.

## Ch 9 --- Coordinate Systems & the Geometry of Spatial Analysis  *(CLOSED DESIGN --- builder-ready)*
*Retitled away from "Map Projections": the subject is **coordinates as a source of error in
quantitative analysis**, not cartography. Concept-led, GIS-acknowledged, code-where-code-adds.
`[OPEN: reorder?]` strong case to place this BEFORE Ch 8 (geostatistics) --- "choose the right
projection" is a prerequisite for "now krige," not a postscript --- but that breaks the
general(1–6)/applications(7–10) framing. Author to decide; left at Ch 9 for now.*

**Code stance:** routine reprojecting is a QGIS/ArcGIS job --- say so, don't write a GUI tutorial.
`pyproj` (wraps PROJ, same engine as QGIS) + `rHEALPixDGGS`/`h3` are for what the GUI *hides*:
explicit datum transform (see the shift), geodesic-vs-Euclidean distance (see the discrepancy),
reproject-then-rerun-a-variogram (see the result move). "Look under the hood," not GIS-replacement.

- 9.1 Why coordinates are a data-analysis problem, not a mapping problem *(aside)* --- the GIS app
  projects; what it hides is that the projection changes the numbers your stats/interpolation run
  on. This chapter teaches the judgement, not the dropdown.
- 9.2 Geographic vs projected coordinates --- lat/lon are angles on an ellipsoid, not Cartesian
  distances; commonest student error is Euclidean distance/area/density on raw lat/lon. Worked
  contrast: two points "1.4 units apart" in degrees → meaningless until projected. Great-circle
  vs straight line. *(alert: never compute distance/area on unprojected lat/lon; mathtool: why a
  degree of longitude shrinks with latitude)*
- 9.3 You can't flatten a sphere for free --- distortion core, projection-independent: every
  projection sacrifices area, angle, distance, or direction. Tissot's indicatrix as the one figure
  that makes it concrete. *(core: preserve-one-sacrifice-the-rest)*
- 9.4 Three families, by what you'll DO with the map --- conformal (Mercator, Lambert conformal
  conic, UTM --- local angle/shape) · equal-area (Albers, Mollweide, sinusoidal --- *mandatory* for
  densities/proportions/spatial stats) · compromise/equidistant (Robinson --- display, not
  computation). **Decision rule:** the projection's preserved quantity must match the quantity you
  intend to measure. *(core; alert: equal-area for ANY area-based statistic)*
- 9.5 UTM in practice --- the projection students actually meet; 6° zones, distortion toward zone
  edges, the classic disaster of computing across a zone boundary (two different coordinate
  systems). Ties to the author's UTM→lat/lon work. *(alert: never analyse across a zone boundary
  without reprojecting)*
- 9.6 `[EXPAND from stub]` Datums & the geoid --- ellipsoid vs geoid; WGS84 vs local/legacy datums;
  why GPS and an old map disagree by tens–hundreds of m; mixing datums injects a systematic offset
  no downstream care will catch. **Australian hook:** continent drifts ~7 cm/yr → GDA94→GDA2020
  moved coordinates ~1.8 m, a live issue here. *(alert: datum-transform before merging; mathtool:
  ellipsoid vs geoid)*
- 9.7 `[NEW]` How projection choice corrupts your analysis *(the payoff --- ties back to Chs 6 & 8)*
  --- variograms on lat/lon have fake position-dependent lags; kriging weights neighbours by
  distorted distance; KDE / points-per-km² over-counts where area is inflated. **Worked demo:** run
  one existing analysis (variogram or Nevada-style gridding) under two projections, show the result
  *changes* → distortion becomes a quantified error in a result they can already compute.
  *(alert; cross-ref 6.4, 8.3–8.4)*
- 9.8 `[NEW]` **Tiling the whole globe: discrete global grid systems** *(spherical/global capstone)*
  - the question 9.4 forces at global scale: lat/lon cells shrink to zero area at the poles --- what
    is the *right* even tiling of a sphere?
  - no-free-lunch again: equal-area + regular-lattice + hexagons-only can't all hold (Euler →
    exactly 12 pentagons; can't tile a sphere with hexagons alone). *(core: the tessellation
    no-free-lunch mirrors the projection one)*
  - DGGS family: **H3** (hexagonal, icosahedral, *approx* equal-area, 12 pentagons, best tooling,
    `h3`) vs **rHEALPix / AusPIX** (quadrilateral, *exactly* equal-area, hierarchical,
    `rHEALPixDGGS` on PyPI; Australian --- Geoscience Australia/CSIRO, Loc-I, on Gibb's 2016 rHEALPix,
    itself the ellipsoidal extension of astrophysics' HEALPix). The hex-approx vs quad-exact
    tradeoff *is* the choice. *(aside: Australian provenance hook)*
  - `[author exploring]` both `rHEALPixDGGS` and `h3` now installed --- pick per task after play.
  - **Waterman, situated:** a low-distortion *display* projection --- compute on the DGGS (equal-area
    on the sphere), then render cell boundaries *through* the Waterman for display. Display-grade vs
    computation-grade --- same distinction as 9.4.
  - **interpolation resolution** *(ties to Ch 8 scattered-data)*: rectangular-grid expectation is an
    implementation convenience, not a method requirement --- kriging/IDW/natural-neighbour are
    scattered-data methods indifferent to grid shape. Interpolate *to* the DGGS cell centroids; the
    "grid problem" dissolves. Hexagons↔triangles are duals → geodesic/icosahedral **triangulation**
    (spherical Delaunay) gives a mesh for barycentric (linear-on-triangles) interpolation *and*, by
    duality, the hex cells. *(core; cross-ref 8.3)*
  - *(alert: for regional honours projects a single local equal-area projection is correct and
    sufficient --- DGGS is overkill until continental/global scale; interpolation across H3 pentagons
    or rHEALPix's complex quad adjacencies needs care)*


## Ch 10 --- Spatial & Temporal Signals  *(CLOSED DESIGN --- builder-ready)*
*Reordered to the honest arc: time-domain → frequency-domain → time-frequency. Source key:
`[FT-lift]` near-verbatim from `fourier_transforms.tex`; `[FT-light]` lift but trim geophysics;
`[FT-leave]` not brought over. NB: the FT chapter already has the **correct** versions of three
data-analysis errors --- lifting it IS the fix (flagged at 10.8).*

**Entry point (do NOT replace):** keep the author's compression/temperature framing as the
opener --- "many points to draw a wave, three numbers to define it"; the century of hourly
temperature with daily / annual / ~fortnightly-weather / ENSO cycles + incoherent noise. The
formal CFT is the *second* beat, never the entry point. (Synthetic-then-real spectral pair:
synthetic first (clean spikes where predicted), real station second (messy, spikes still there).)
The temperature series is the **stationary 1-D thread** carrying gateway → DFT → spectrum →
filtering; it also sets up wavelets *by contrast* --- its cycles persist at ~constant frequency,
so it's the case wavelets aren't needed for, which is the clean pivot into 10.15.

- 10.1 Introduction --- the temperature/compression gateway above
- 10.2 `[MOVED]` **Detrending & smoothing first** --- moving averages · LOESS/LOWESS `[NP]` ·
  linear/low-order-polynomial detrending
  - *(core: a moving average IS a low-pass filter and a convolution --- plant now; the 10.11
    convolution theorem pays it back; boxcar kernel = running mean)*
  - *(alert: detrend BEFORE transforming --- same series with/without detrending shows leakage)*
- 10.3 `[NEW] [NP]` Autocorrelation & cross-correlation (temporal) --- ACF · PACF · lag/lead;
  cross-ref spatial autocorrelation (8.4.2)
- 10.4 `[NEW]` Multiple change-points & segmentation --- binary segmentation · PELT · CUSUM;
  regime shifts / stratigraphic & climate breaks *(cross-ref single change-point test 4.7)*
- 10.5 Review of waves `[FT-lift]` --- temporal & spatial; amplitude/frequency/phase; the
  `\mlbox`-annotated A·cos(ωt−φ) figure *(mathtool: complex exponentials --- also fixes the broken
  "Figure ??"; NB check `\mlbox` compiles against the data-analysis preamble)*
- 10.6 Fourier series --- orthogonality · basis
- 10.7 Continuous Fourier transform `[FT-lift]` --- forward/inverse pair; variable interpretation
  (time↔frequency, space↔wavenumber); amplitude & phase `[FT-lift, compress]` (two signals,
  same amplitude spectrum, different phase → look different --- motivates why filter choice matters)
- 10.8 Discrete Fourier transform `[FT-lift]` *(core)* --- 0-based definition + the clean MATLAB
  1-based footnote (n→n−1, k→k−1); FFT-is-an-algorithm-not-a-transform
  - `[FIX via lift]` correct discrete frequency **ν_k = k/(N·Δξ)** (replaces the reciprocal
    form); correct **ν_Ny = 1/(2Δξ)** kept distinct from sampling rate; FFT≠DFT
  - `[FIX in BOTH docs]` "Heinrich Gauss" → **Carl Friedrich Gauss**. (FT chapter has "Tukey"
    correct; data-analysis had "Turkey" --- merge to the correct token of each.)
  - implicit-periodicity note → sets up leakage/windowing (10.11)
- 10.9 Sampling & aliasing `[FT-lift]` --- wagon-wheel example · irreversibility · the four
  consequences (can't represent / get something false / can't tell / can't fix)
  *(alert: aliasing is irreversible)*
  - `[copyright]` paraphrase the one verbatim Rolling Stones line; keep the four *ideas* and the
    allusion (idea/style isn't protected; the exact lyric line is). See note to author.
  - keep a **simple synthetic aliasing visual** in the body (clean mechanism); the Nevada
    three-panel figure (case study below) shows it biting on real data
- 10.10 `[NEW]` Spectral estimation --- periodogram → Welch's method *(alert: variance of the raw
  periodogram)*
  - `[NEW, lift principle not code from nevada_fft.py Part 3.3]` worked principle: how many
    independent samples does a spectrum really have? --- effective N from the autocorrelation
    length, prewhiten against a red-noise background, χ² significance threshold. This is the
    "have you earned your degrees of freedom?" motif (thread 2) made concrete; students *apply*
    it in the Nevada case study.
- 10.11 `[EXPAND via FT-lift]` **Convolution → convolution theorem → Filtering** (the stub's
  fix) --- convolution as weighted average (boxcar = running mean, ties back to 10.2); convolution
  theorem (convolution ↔ multiplication); amplitude vs phase filters; ideal vs realisable;
  sharp spectral cutoff → broad oscillatory kernel → **Gibbs ringing**; windowing is itself
  convolution *(core + alert)*
- 10.12 Continuation `[FT-light]` (potential-field 2-D example) --- upward = low-pass/stable,
  downward = unstable/needs regularization; derivative operator F{df/dx}=i2πk·F generalizes
  *(alert: downward continuation & derivatives amplify noise)*
- 10.13 `[NEW] [NP]` Unevenly-sampled data: Lomb–Scargle periodogram `[GUEST: palaeoclimate/core]`
- 10.14 Time-series basics & stationarity --- trend/seasonality · differencing · stationarity
  (cross-ref 8.4.1) · AR/MA conceptual, light
- 10.15 **Wavelet transforms** (time-frequency --- the natural closer) --- motivate by the question
  Fourier *can't* answer: "what if the frequencies change with time?" Demonstrate on a
  **non-stationary** signal, not the stationary temperature series --- point the wavelet at a band
  whose amplitude waxes and wanes over the record (ENSO in a long station series is the natural
  candidate; the scalogram shows what the global spectrum averaged away). `[GUEST or temperature-
  ENSO band]`
- 10.16 `[FT-lift → closing alert section]` Interpretation & pitfalls --- resolution limits ·
  noise amplification · edge effects/windowing · physical vs non-physical spectral features ·
  the "does it persist under reasonable changes in processing?" test

### Ch 10 capstone case study --- Nevada basin thickness from gravity  `[from nevada_fft.py]`
*One of the last demonstrations; threads most of the chapter through one real 2-D dataset.
Scope deliberately reduced for this course --- body figures + an optional light guided walkthrough,
NOT the full pipeline as an assessed exercise (too much).*
- **Simplification:** drop the isostatic correction --- replace with a single long-wavelength
  (high-pass) filter `[the original did it twice because the isostatic model leaves a residual
  trend; one empirical filter is honest and sufficient here, and stays inside the chapter's
  toolkit]`. Signal chain: real Bouguer map → high-pass → invert for thickness → show aliasing.
- **Physics given conceptually, not derived:** gravity intuition only (more/denser mass → more
  pull; sediment basins are low-density → gravity lows). Black-box functions (`parker_oldenburg`,
  grid IO, hillshade) are fine *here* because it's late and the real versions were built earlier
  --- label each with what it does + a section pointer (inversion = regularized deconvolution, §5.10
  / §10.11). Black box, not magic box.
- **Body payoff figure(s):** a static 3-panel Bouguer → isostatic/long-wavelength residual →
  high-pass result (regional–residual separation on real data); plus the **3-panel aliasing
  figure as a sequence of increasing station spacing** (full res, basins crisp → moderate, Nyquist
  just left of basin band, blurring → coarse, Nyquist inside 20–60 km band, phantom basins),
  each map paired with its E–W power spectrum and the moving Nyquist line. The *progression* is
  the argument.
- Significance analysis (10.10 principle) is where students apply prewhitening + χ² here.
- `[FIX]` reconcile Δρ: prose table says sediment 2000 kg/m³, code uses 2500 --- pick one.
- Infrastructure note: depends on project modules + ETOPO/pyproj/geopandas + a multi-MB grid →
  ships as a data bundle + notebook (companion layer), not body `\input`.
- `[FT-leave / demote]` **Deconvolution** → one short *(aside)*: division in the Fourier domain,
  division by small values amplifies noise, hence regularization (= Fourier-domain Tikhonov,
  cross-ref 5.10); keep the compact convolution-vs-deconvolution contrast table if useful.
  Drop seismic/instrument-response depth.
- `[FT-leave]` field-specific previews (migration, reduction-to-pole, magnetotellurics)

---


# APPENDICES
- **A. Math refreshers** --- overflow from *(mathtool)* boxes too large for the margin: linear
  algebra · calculus · complex numbers · trig identities.
- **B. Datasets** --- one table: dataset → subdiscipline → techniques used (see strategy below).
- **C. Code companions** --- MATLAB Live Scripts / Python notebooks, referenced from the
  pseudocode in the body.

---

# Cross-cutting threads (woven, not chaptered)
1. **"When to use this --- and when not to."** Turn breadth into judgement. Seed in 5.3
   (inversion recipes); a short *(alert)*/*(aside)* closing each major method.
2. **Aggregation is a modeling choice with a cost.** Recurring *(alert)* --- *"is this
   aggregate a property of a process, or an average across processes?"* --- fired wherever a
   method pools positioned/sequential/mixed data. Distributional form in Ch 1 (multimodality /
   zircon); the estimand point at the 3.10 normality hinge; relationship form at 5.8 (Simpson's);
   constructive responses in clustering (6.5) and the 7.7 subcomposition example. Pairs with
   the structure-marginalized-vs-modeled framing of Part II and the "have you earned
   independence here?" check on autocorrelation.
3. **Non-parametric `[NP]` track** --- Ch 4 hub, threads outward.
3. **Two recurring datasets:** `[THREAD-arc]` for continuity through Ch 1–6;
   `[THREAD-zircon]` as the non-parametric spine (KDE 1.5 → K–S/Kuiper 4.4 → classical MDS
   6.4.2). Deliberate `[GUEST]` sets elsewhere so breadth spans subdisciplines. Show the
   top methods (regression, PCA, hypothesis tests) on both a familiar thread and a guest set.
4. **Notation** --- standardise sample vs population (x̄/μ, s/σ); one-page table up front *(mathtool)*.
5. **Conceptual figures** --- add schematics (KDE bandwidth; grid-search misfit surface;
   a "which test?" flowchart for Ch 3) to balance the code-generated plots.

# Box migration (using notes.sty)
- *(core)* --- propagation formula · LLSQ normal equations · kriging system · Fourier pair ·
  log-ratio transforms · the normality-robustness hinge.
- *(mathtool)* --- partial derivatives · eigen/SVD · complex exponentials · pseudo-inverse ·
  spline conditions · projection geometry · Bayes' rule.
- *(alert)* --- extrapolation · aliasing · p-value misuse · closure/spurious correlation ·
  stationarity · overfitting · detect≠delete · datum mismatch · F-test fragility ·
  t-SNE/UMAP distortion · log-ratio sensitivity to near-zero values.
- *(aside)* --- errors-vs-uncertainties · the "average" gripe · Bayesian-vs-frequentist ·
  why you avoid black-box toolbox functions · Monte Carlo / FFT history.

# Conventions (apply chapter-wide)

**Code: own vs library.** Two jobs, opposite answers, do both deliberately.
- *From scratch* (teaching artifact, lives next to the derivation, matches the pseudocode):
  least squares (normal equations + matrix solve), error propagation, basic Monte Carlo loop,
  the DFT as a literal sum, simple k-means, the variogram/kriging system, ridge (add λI).
- *Library* (production artifact, isolated in the companion notebook, the swappable layer):
  eigen/SVD, the FFT, `scipy.optimize` for nonlinear LM, `pyproj`, test distributions.
- *Deliberately simplified* (matches text, flag what the library adds): DFT→FFT; teaching
  k-means vs k-means++. Never a *silent* simplification.
- **Agree-then-diverge** for the few methods where the numerical gap is the lesson --- flagship
  is LLSQ §5.4 (naive AᵀA vs QR/SVD conditioning). Use sparingly; it's distinctive.
- Durability: from-scratch code is written against math (doesn't version) → durable; library
  calls are fragile → keep thin, marked, in companions.

**Data display: match the display to the role.**
- *Inputs you want reproducible* → full table, **once**, in an appendix; reference back
  (the 42×5 arc set incl. uncertainty columns → App. B; print once, cite as "Table B.x").
- *Summary stats & fitted parameters* → inline, formatted, with uncertainties, 2–3 sig figs
  (e.g. m₁ = 6.6 ± 0.4), plus χ²/R²/residual spread.
- *Intermediate arrays* → suppressed, or shown as a *shape* ("a 42×2 design matrix"), never a
  raw solver dump. Rule: show a number if a reader would cite or check it; suppress it if the
  code merely passed it to the next line. (Also clears the Live-Script `[output:…]` artifacts.)
- Let *figures* carry qualitative detail (e.g. leverage plot) so printed numbers stay sparse.

This box mechanism resolves the earlier "split core from commentary" idea **without**
sterilising the voice --- sort the asides into boxes, don't delete them.

---
*Chapter count: 10 (Part I: 1–6, Part II: 7–10). Downstream cross-references above use the
new numbering.*
