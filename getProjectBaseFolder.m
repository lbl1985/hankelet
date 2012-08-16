function projectBaseFolder = getProjectBaseFolder
projectBaseFolder = which('hankeletFlag.m');
projectBaseFolder = projectBaseFolder(1:strfind(projectBaseFolder, 'hankeletFlag.m') - 1);
 