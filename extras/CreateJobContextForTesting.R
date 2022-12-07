# Create a job context for testing purposes

library(Strategus)
library(dplyr)
source("SettingsFunctions.R")

# Generic Helpers ----------------------------
getModuleInfo <- function() {
  checkmate::assert_file_exists("MetaData.json")
  return(ParallelLogger::loadSettingsFromJson("MetaData.json"))
}

# Sample Data Helpers ----------------------------
getSampleCohortDefintionSet <- function() {
  sampleCohorts <- CohortGenerator::createEmptyCohortDefinitionSet()
  cohortJsonFiles <- list.files(path = system.file("testdata/name/cohorts", package = "CohortGenerator"), full.names = TRUE)
  for (i in 1:length(cohortJsonFiles)) {
    cohortJsonFileName <- cohortJsonFiles[i]
    cohortName <- tools::file_path_sans_ext(basename(cohortJsonFileName))
    cohortJson <- readChar(cohortJsonFileName, file.info(cohortJsonFileName)$size)
    sampleCohorts <- rbind(sampleCohorts, data.frame(cohortId = i,
                                                     cohortName = cohortName,
                                                     cohortDefinition = cohortJson,
                                                     stringsAsFactors = FALSE))
  }
  sampleCohorts <- apply(sampleCohorts,1,as.list)
  return(sampleCohorts)
}

createCohortSharedResource <- function(cohortDefinitionSet) {
  sharedResource <- list(cohortDefinitions = cohortDefinitionSet)
  class(sharedResource) <- c("CohortDefinitionSharedResources", "SharedResources")
  return(sharedResource)
}

# Create SelfControlledCaseSeriesModule settings ---------------------------------------
tcos <- createTargetComparatorOutcomes(
  targetId = 1,
  comparatorId = 2,
  outcomes = list(
    createOutcome(
      outcomeId = 3,
      priorOutcomeLookback = 30
    )
  ),
  excludedCovariateConceptIds = c(1118084, 1124300)
)
targetComparatorOutcomesList <- list(tcos)

covarSettings <- createDefaultCovariateSettings(addDescendantsToExclude = TRUE)

getDbCmDataArgs <- createGetDbCohortMethodDataArgs(
  washoutPeriod = 183,
  firstExposureOnly = TRUE,
  removeDuplicateSubjects = "remove all",
  covariateSettings = covarSettings
)

createStudyPopArgs <- createCreateStudyPopulationArgs(
  minDaysAtRisk = 1,
  riskWindowStart = 0,
  startAnchor = "cohort start",
  riskWindowEnd = 30,
  endAnchor = "cohort end"
)

fitOutcomeModelArgs <- createFitOutcomeModelArgs(modelType = "cox")

cmAnalysis <- createCmAnalysis(
  analysisId = 1,
  description = "No matching, simple outcome model",
  getDbCohortMethodDataArgs = getDbCmDataArgs,
  createStudyPopArgs = createStudyPopArgs,
  fitOutcomeModel = TRUE,
  fitOutcomeModelArgs = fitOutcomeModelArgs
)

cmAnalysisList <- list(cmAnalysis)

analysesToExclude <- NULL


cohortMethodModuleSpecifications <- createCohortMethodModuleSpecifications(
  cmAnalysisList = cmAnalysisList,
  targetComparatorOutcomesList = targetComparatorOutcomesList,
  analysesToExclude = analysesToExclude
)

# Module Settings Spec ----------------------------
analysisSpecifications <- createEmptyAnalysisSpecificiations() %>%
  addSharedResources(createCohortSharedResource(getSampleCohortDefintionSet())) %>%
  addModuleSpecifications(cohortMethodModuleSpecifications)

executionSettings <- Strategus::createExecutionSettings(connectionDetailsReference = "dummy",
                                                        workDatabaseSchema = "main",
                                                        cdmDatabaseSchema = "main",
                                                        cohortTableNames = CohortGenerator::getCohortTableNames(cohortTable = "cohort"),
                                                        workFolder = "dummy",
                                                        resultsFolder = "dummy",
                                                        minCellCount = 5)

# Job Context ----------------------------
module <- "CohortMethodModule"
moduleIndex <- 1
moduleExecutionSettings <- executionSettings
moduleExecutionSettings$workSubFolder <- "dummy"
moduleExecutionSettings$resultsSubFolder <- "dummy"
moduleExecutionSettings$databaseId <- 123
jobContext <- list(sharedResources = analysisSpecifications$sharedResources,
                   settings = analysisSpecifications$moduleSpecifications[[moduleIndex]]$settings,
                   moduleExecutionSettings = moduleExecutionSettings)
saveRDS(jobContext, "tests/testJobContext.rds")

