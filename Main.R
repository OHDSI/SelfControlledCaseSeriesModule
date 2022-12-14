# Copyright 2022 Observational Health Data Sciences and Informatics
#
# This file is part of CohortMethodModule
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Module methods -------------------------
execute <- function(jobContext) {
  checkmate::assert_list(x = jobContext)
  if (is.null(jobContext$settings)) {
    stop("Analysis settings not found in job context")
  }
  if (is.null(jobContext$sharedResources)) {
    stop("Shared resources not found in job context")
  }
  if (is.null(jobContext$moduleExecutionSettings)) {
    stop("Execution settings not found in job context")
  }
  
  message("Executing self-controlled case series")
  sccsMultiThreadingSettings  <- SelfControlledCaseSeries::createDefaultSccsMultiThreadingSettings(parallel::detectCores())
  
  args <- jobContext$settings
  args$connectionDetails <- jobContext$moduleExecutionSettings$connectionDetails
  args$cdmDatabaseSchema <- jobContext$moduleExecutionSettings$cdmDatabaseSchema
  args$exposureDatabaseSchema <- jobContext$moduleExecutionSettings$workDatabaseSchema
  args$exposureTable <- jobContext$moduleExecutionSettings$cohortTableNames$cohortTable
  args$outcomeDatabaseSchema <- jobContext$moduleExecutionSettings$workDatabaseSchema
  args$outcomeTable <- jobContext$moduleExecutionSettings$cohortTableNames$cohortTable
  args$nestingCohortDatabaseSchema <- jobContext$moduleExecutionSettings$workDatabaseSchema
  args$nestingCohortTable  <- jobContext$moduleExecutionSettings$cohortTableNames$cohortTable
  args$customCovariateDatabaseSchema <- jobContext$moduleExecutionSettings$workDatabaseSchema
  args$customCovariateTable <- jobContext$moduleExecutionSettings$cohortTableNames$cohortTable
  args$outputFolder <- jobContext$moduleExecutionSettings$workSubFolder
  args$sccsMultiThreadingSettings  <- sccsMultiThreadingSettings 
  do.call(SelfControlledCaseSeries::runSccsAnalyses, args)
  
  exportFolder <- jobContext$moduleExecutionSettings$resultsSubFolder
  SelfControlledCaseSeries::exportToCsv(outputFolder = jobContext$moduleExecutionSettings$workSubFolder,
                                        exportFolder = exportFolder,
                                        databaseId = jobContext$moduleExecutionSettings$databaseId,
                                        minCellCount = jobContext$moduleExecutionSettings$minCellCount)
  unlink(file.path(exportFolder, sprintf("Results_%s.zip", jobContext$moduleExecutionSettings$databaseId)))
  
  moduleInfo <- ParallelLogger::loadSettingsFromJson("MetaData.json")
  resultsDataModel <- CohortGenerator::readCsv(file = system.file("csv", "resultsDataModelSpecification.csv", package = "SelfControlledCaseSeries"))
  resultsDataModel <- resultsDataModel[file.exists(file.path(exportFolder, paste0(resultsDataModel$tableName, ".csv"))), ]
  if (any(!startsWith(resultsDataModel$tableName, moduleInfo$TablePrefix))) {
    stop("Table names do not have required prefix")
  }
  CohortGenerator::writeCsv(x = resultsDataModel, 
                            file = file.path(exportFolder, "resultsDataModelSpecification.csv"),
                            warnOnFileNameCaseMismatch = FALSE)
}

