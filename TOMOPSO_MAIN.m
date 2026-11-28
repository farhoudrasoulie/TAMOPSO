% TOMOPSO_MAIN - launch NEW TAMOPSO Table 10 verification experiments.
% IMPORTANT: The resulting files are new verification outputs, NOT recovered
% historical raw data or original metadata from the published article.

clc;
fprintf('\n============================================================\n');
fprintf('TAMOPSO - NEW Table 10 verification workflow\n');
fprintf('============================================================\n');
thisFile = mfilename('fullpath');
if isempty(thisFile), projectDir = pwd; else, projectDir = fileparts(thisFile); end
addpath(projectDir);
requiredFiles = {'run_table10_ablation.m','TAMOPSO_RUN.m','CreateModel.m', ...
    'MyCost.m','MyCostComponents_Table10.m','SphericalToCart.m','DistP2S.m', ...
    'PlotModel.m','BUILD_TABLE10_METADATA.m'};
for k=1:numel(requiredFiles)
    if exist(fullfile(projectDir,requiredFiles{k}),'file')~=2
        error('TAMOPSO:MissingPackageFiles','Missing required file: %s',requiredFiles{k});
    end
end

% These are NEW verification settings. The run count is not asserted to be
% the historical Table 10 protocol. Adjust only with a documented rationale.
cfg = struct();
cfg.nRuns = 30;
cfg.nPop = 500;
cfg.MaxIt = 200;
cfg.nArchive = 200;
cfg.baseSeed = 20261128;
cfg.maxInitAttempts = 5000;
cfg.makePlotsEachRun = false;
cfg.verbose = false;
cfg.displayEvery = 25;
cfg.convergenceRelativeTolerance = 0.01;
cfg.outputRoot = fullfile(projectDir,'Table10_Verification_Results');

fprintf('Project folder: %s\n',projectDir);
fprintf('NEW runs/configuration: %d | Population: %d | Iterations: %d | Archive: %d\n', ...
    cfg.nRuns,cfg.nPop,cfg.MaxIt,cfg.nArchive);
fprintf(['NOTICE: outputs will be labelled as new verification experiments; ' ...
    'they are not historical data recovery.\n\n']);
outputDir = run_table10_ablation(cfg);
xlsxFile = BUILD_TABLE10_METADATA(outputDir);
assignin('base','TAMOPSO_Table10_OutputDir',outputDir);
assignin('base','TAMOPSO_Table10_MetadataWorkbook',xlsxFile);
fprintf('\nCompleted. Output folder:\n%s\n',outputDir);
fprintf('Metadata workbook:\n%s\n',xlsxFile);
fprintf('The summary table has also been displayed in the MATLAB Command Window.\n');
