% Hybrid Firefly & Sperm Swarm Optimization with Newton-Raphson (HFASSON)
% Replaced classic PSO with Task Allocation & Archive‑Guided Mutation PSO (TAMOPSO)

clc;
clear;
close all;

%% Problem Definition
model = CreateModel();                           % Map & parameters
CostFunction = @(x) MyCost(x,model);             % Cost function handle

nVar    = model.n;            % Number of decision variables
VarSize = [1 nVar];            % Decision vector size

% Spatial bounds (Cartesian)
VarMin.x = model.xmin; VarMax.x = model.xmax;
VarMin.y = model.ymin; VarMax.y = model.ymax;
VarMin.z = model.zmin; VarMax.z = model.zmax;

% Spherical radius bounds
VarMax.r = 2*norm(model.start-model.end)/nVar;
VarMin.r = 0;

% Elevation (psi) bounds
AngleRange    = pi/4;
VarMin.psi    = -AngleRange; VarMax.psi = AngleRange;

% Azimuth (phi) bounds
dirVector = model.end - model.start;
phi0      = atan2(dirVector(2),dirVector(1));
VarMin.phi = phi0 - AngleRange; VarMax.phi = phi0 + AngleRange;

% Velocity limits
alpha         = 0.5;
VelMax.r      = alpha*(VarMax.r-VarMin.r); VelMin.r   = -VelMax.r;
VelMax.psi    = alpha*(VarMax.psi-VarMin.psi); VelMin.psi = -VelMax.psi;
VelMax.phi    = alpha*(VarMax.phi-VarMin.phi); VelMin.phi = -VelMax.phi;

%% TAMOPSO Parameters
MaxIt       = 200;    % iterations
nPop        = 500;    % swarm size
nArchive    = 200;    % archive capacity
w           = 0.7;      % inertia
wdamp       = 0.98;   % inertia damping
c1          = 1.5;    % personal coeff
c2          = 1.5;    % archive-guided coeff
mutProb     = 0.90;   % mutation probability

%% Initialization
% Empty template
template.Position = [];
template.Velocity = [];
template.Cost     = [];
template.Best.Position = [];
template.Best.Cost     = [];

% Initialize swarm and archive
particle       = repmat(template, nPop, 1);
GlobalArchive = [];

for i = 1:nPop
    % Random initialization
    particle(i).Position = CreateRandomSolution(VarSize,VarMin,VarMax);
    particle(i).Velocity.r   = zeros(VarSize);
    particle(i).Velocity.psi = zeros(VarSize);
    particle(i).Velocity.phi = zeros(VarSize);
    % Evaluate
    particle(i).Cost = CostFunction(SphericalToCart(particle(i).Position,model));
    % Personal best
    particle(i).Best.Position = particle(i).Position;
    particle(i).Best.Cost     = particle(i).Cost;
    % Archive update
    GlobalArchive = UpdateArchive(GlobalArchive, particle(i), nArchive);
end

BestCost = zeros(MaxIt,1);

%% TAMOPSO Main Loop
for it = 1:MaxIt
    for i = 1:nPop
        % 1) Select guide
        guide = SelectGuide(GlobalArchive);
        
        % 2) Velocity & Position update
        % r
        v = w*particle(i).Velocity.r + ...
            c1*rand(VarSize).*(particle(i).Best.Position.r - particle(i).Position.r) + ...
            c2*rand(VarSize).*(guide.Position.r - particle(i).Position.r);
        particle(i).Velocity.r = max(min(v,VelMax.r),VelMin.r);
        particle(i).Position.r = particle(i).Position.r + particle(i).Velocity.r;
        [particle(i).Position.r, particle(i).Velocity.r] = enforceBounds(particle(i).Position.r, particle(i).Velocity.r, VarMin.r, VarMax.r);

        % psi
        v = w*particle(i).Velocity.psi + ...
            c1*rand(VarSize).*(particle(i).Best.Position.psi - particle(i).Position.psi) + ...
            c2*rand(VarSize).*(guide.Position.psi - particle(i).Position.psi);
        particle(i).Velocity.psi = max(min(v,VelMax.psi),VelMin.psi);
        particle(i).Position.psi = particle(i).Position.psi + particle(i).Velocity.psi;
        [particle(i).Position.psi, particle(i).Velocity.psi] = enforceBounds(particle(i).Position.psi, particle(i).Velocity.psi, VarMin.psi, VarMax.psi);

        % phi
        v = w*particle(i).Velocity.phi + ...
            c1*rand(VarSize).*(particle(i).Best.Position.phi - particle(i).Position.phi) + ...
            c2*rand(VarSize).*(guide.Position.phi - particle(i).Position.phi);
        particle(i).Velocity.phi = max(min(v,VelMax.phi),VelMin.phi);
        particle(i).Position.phi = particle(i).Position.phi + particle(i).Velocity.phi;
        [particle(i).Position.phi, particle(i).Velocity.phi] = enforceBounds(particle(i).Position.phi, particle(i).Velocity.phi, VarMin.phi, VarMax.phi);
        
        % 3) Archive-Guided Mutation
        if rand < mutProb
            particle(i).Position = MutatePosition(particle(i).Position, GlobalArchive, VarMin, VarMax);
        end
        
        % 4) Evaluate & update
        particle(i).Cost = CostFunction(SphericalToCart(particle(i).Position,model));
        if particle(i).Cost < particle(i).Best.Cost
            particle(i).Best.Position = particle(i).Position;
            particle(i).Best.Cost     = particle(i).Cost;
        end
        GlobalArchive = UpdateArchive(GlobalArchive, particle(i), nArchive);
    end
    % Inertia damping
    w = w*wdamp;
    BestCost(it) = GlobalArchive(1).Cost;
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
end

%% Results
BestPos = SphericalToCart(GlobalArchive(1).Position,model);
disp('Best solution found by TAMOPSO:'); disp(BestPos);
smooth = 0.95;
PlotSolution(BestPos,model,smooth);
figure; plot(BestCost,'LineWidth',2); xlabel('Iteration'); ylabel('Best Cost'); grid on;

%% Helper Functions
function [pos, vel] = enforceBounds(pos, vel, lb, ub)
    out = pos<lb | pos>ub;
    vel(out) = -vel(out);
    pos = min(max(pos,lb),ub);
end

function archive = UpdateArchive(archive, p, maxSize)
    archive = [archive; p];
    [~,I] = sort([archive.Cost]);
    archive = archive(I(1:min(end,maxSize)));
end

function guide = SelectGuide(archive)
    guide = archive(randi(numel(archive)));
end

function newPos = MutatePosition(pos, archive, VarMin, VarMax)
    g = SelectGuide(archive);
    phi = rand(size(pos.r));
    newPos.r   = pos.r   + phi.*(g.Position.r   - pos.r);
    newPos.psi = pos.psi + phi.*(g.Position.psi - pos.psi);
    newPos.phi = pos.phi + phi.*(g.Position.phi - pos.phi);
    newPos.r   = max(min(newPos.r,   VarMax.r),   VarMin.r);
    newPos.psi = max(min(newPos.psi, VarMax.psi), VarMin.psi);
    newPos.phi = max(min(newPos.phi, VarMax.phi), VarMin.phi);
end
