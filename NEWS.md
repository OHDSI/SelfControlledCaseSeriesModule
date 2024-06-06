SelfControlledCaseSeriesModule 0.5.1
====================================
- Switching to newer version of SelfControledCaseSeries v5.2.1

SelfControlledCaseSeriesModule 0.5.0
====================================
- Switching to newer version of SelfControledCaseSeries v5.2.0

SelfControlledCaseSeriesModule 0.4.1
====================================
- Switching to newer version of SelfControledCaseSeries 5.1.1

SelfControlledCaseSeriesModule 0.4.0
====================================
- Using renv project profiles to manage core packages required for module execution vs. those that are needed for development purposes.

SelfControlledCaseSeriesModule 0.3.2
====================================

- Switching to newer version of SelfControledCaseSeries 5.1.0 (currently unreleased).

SelfControlledCaseSeriesModule 0.3.1
====================================

- Switching to SelfControledCaseSeries 5.1.0 (currently unreleased).

SelfControlledCaseSeriesModule 0.3.0
====================================

- Switching to (currently unreleased) SelfControledCaseSeries v5.0.0. (Required updating SqlRender to v1.16.1)

SelfControlledCaseSeriesModule 0.2.0
====================================

- Updated module to use HADES wide lock file and updated to use renv v1.0.2
- Added functions and tests for creating the results data model for use by Strategus upload functionality
- Added additional GitHub Action tests to unit test the module functionality on HADES supported R version (v4.2.3) and the latest release of R

SelfControlledCaseSeriesModule 0.1.3
====================================

Changes

1. Updating `SelfControlledCaseSeries`. Not ignoring 'allowRegularization' in calendar time settings.

SelfControlledCaseSeriesModule 0.1.2
====================================

Changes

1. Updating `SelfControlledCaseSeries`. Fixes MDRR edge case when all observed time is exposed.

SelfControlledCaseSeriesModule 0.1.1
====================================

Changes

1. Updating `SelfControlledCaseSeries`. Changes `observed_days` field to BIGINT.

SelfControlledCaseSeriesModule 0.1.0
====================================

Changes

1. Updating `SelfControlledCaseSeries`. Now exposing diagnostics thresholds.


SelfControlledCaseSeriesModule 0.0.5
====================================

Changes

1. Add missing `renv/settings.dcf` file.

SelfControlledCaseSeriesModule 0.0.4
====================================

Changes

1. Upgrading `SelfControlledCaseSeries` version. Setting `sccs_spline.knot_month` to a float in specifications.


SelfControlledCaseSeriesModule 0.0.3
====================================

Changes

1. Upgrading `SelfControlledCaseSeries` version. No longer importing `survival`. Should fix `function strata not found` error.


SelfControlledCaseSeriesModule 0.0.2
====================================

Changes

1. Upgrading `SelfControlledCaseSeries` version. Downgrading `renv` version.


SelfControlledCaseSeriesModule 0.0.1
====================================

Initial version.