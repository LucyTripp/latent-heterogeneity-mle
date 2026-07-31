repo_root = fileparts(fileparts(mfilename("fullpath")));
results = runtests(fullfile(repo_root, "tests"));
disp(results);
assert(all([results.Passed]), "At least one test failed.");
