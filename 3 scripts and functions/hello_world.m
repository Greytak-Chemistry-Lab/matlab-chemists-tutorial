% demo script
disp('Hello World!') % displays this text to default stream (command window)

if(exist('cat_paws','var'))
    warning('There is already a variable cat_paws in the workspace!')
    return
end
cat_paws=4; % set a variable in the current workspace

% initialize random number generator used by rand() with a random seed
% based on current time
rng('shuffle') 

% set a variable with a random value between zero and 10 in the current
% workspace
a_random_number=round(10*rand(),3);

