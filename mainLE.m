%Main file for running Lagrangian-Eulerian point particle tracking method.

clear all;
clc;

%Run Parameter Prompt
prompt = {'Run Time (0-10)','Time Steps  [dt=time/(time steps)]','Time Period',...
    '# of Parcels','Reynolds #', 'Stokes #','Grid Size'};
dlgtitle = 'Input';
dims = [1 40];
definput = {'10','1000','1','144', '100', '0.2','100'};
params = inputdlg(prompt,dlgtitle,dims,definput);

%Convert Cell Array Values to Scalar Values
%Extract Run Time
t = str2double(params{1}); 
%Extract Time Step
t_steps = str2double(params{2});     dt = t/t_steps;
%Extract Time Period
T = str2double(params{3}); 
%Extract Number of Parcels
n = str2double(params{4});
%Extract Reynolds Number
Re = str2double(params{5});
%Extract Stokes Number
St = str2double(params{6});
%Extract Mesh Grid Size
Nx = str2double(params{7});
Ny = Nx; 

%%%%%%%%%%%Run Time
%%%%%%%%%%%t = input('Input simulation time:  ');     %seconds
%Time Step
%%%%%%%%%%%dt = 1;     %seconds
currentTime = 0;

%Input number of parcels
%%%%%%n = input('Choose number of parcels: ');

%If no input specified, defaults to 12^2 parcels
%%%%%%%%%if isempty(n)
%%%%%%%%%%    n = 12^2;
%%%%%%%%%%end
%One particle roughly in middle
%mode = 1;
%Uniform Distribution of particles
%mode = 2;
%Random Distribution of particles
%mode = 3;

%Choose run mode
list = {'Single Parcel', 'Uniform', 'Random'};
[mode,tf] = listdlg('PromptString',{'Select run mode',''}, 'SelectionMode', 'single','ListString',list);

%Call initialization function (uncomment subplot line when finished)
subplot(2,2,1)
[xPos,yPos] = InitPosition(n,mode);
xPosInit = xPos;
yPosInit = yPos;
scatter(xPosInit(),yPosInit())
title('Initial Parcel Positions')
xlim([0 1])
ylim([0 1])

%Particle velocity at t = 0
initVelx = zeros(1,n);
initVely = zeros(1,n);

%Calculate Velocity and Position

maxit = 0;
%initialize parcel velocities
uVel = initVelx;
vVel = initVely;
while currentTime <= t && maxit <= t_steps
    maxit = maxit + 1;
    [xPos,yPos, uVel, vVel] = ParticleVelocity(n,t,dt,xPos,yPos,uVel,vVel,Re,St,Nx,Ny);
    fprintf('Iteration: %d\n', maxit)
    currentTime = currentTime + dt;
end

%Plot Final parcel positions
subplot(2,2,2)
scatter(xPos,yPos)
title('Final Parcel Positions')
xlim([0 1])
ylim([0 1])

%Choose 100 random parcels for plotting
xIndex = ceil(length(xPos)*rand(1,100));

xPosInit_100 = zeros(1,length(xIndex));
yPosInit_100 = zeros(1,length(xIndex));
xPos_100 = zeros(1,length(xIndex));
yPos_100 = zeros(1,length(xIndex));

for z = 1:length(xIndex)
    xPosInit_100(z) = xPosInit(xIndex(z));
    yPosInit_100(z) = yPosInit(xIndex(z));
    
    xPos_100(z) = xPos(xIndex(z));
    yPos_100(z) = yPos(xIndex(z));
end

%Plot 100 randomly selected initial parcels
subplot(2,2,3)
scatter(xPosInit_100,yPosInit_100)
title('100 Initial Parcel Positions')
xlim([0 1])
ylim([0 1])

%Plot 100 randomly selected parcels
subplot(2,2,4)
scatter(xPos_100,yPos_100)
title('100 Final Parcel Positions')
xlim([0 1])
ylim([0 1])