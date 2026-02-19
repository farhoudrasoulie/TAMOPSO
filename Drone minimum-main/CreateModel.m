%% CreateModel (Gaussian-Sum Terrain with 7 Mountains)
function model = CreateModel()
    %% GRID DEFINITION
    MAPSIZE_X = 1000; % grid resolution
    MAPSIZE_Y = 1000;
    [X, Y] = meshgrid(1:MAPSIZE_X, 1:MAPSIZE_Y);

    %% GAUSSIAN-SUM TERRAIN (7 Peaks)
    xi  = [400, 600, 500, 350, 700, 650, 250];   % x-centers
    yi  = [500, 200, 350, 200, 550, 750, 600];   % y-centers
    hi  = [100, 150, 150, 150, 150, 150, 140];   % peak heights
    xsi = [ 80,  70,  80,  70,  70,  80,  75];   % x-spread
    ysi = xsi;                                  % y-spread (same)

    H = zeros(MAPSIZE_Y, MAPSIZE_X);
    for k = 1:numel(xi)
        H = H + hi(k) .* exp(-((X - xi(k))./xsi(k)).^2 - ((Y - yi(k))./ysi(k)).^2);
    end

    %% CYLINDRICAL THREATS OVERLAY (radius = same as spreads)
    R = xsi;  % use same radii as horizontal spread
    threats = [xi', yi', hi', R'];

    %% BOUNDARIES AND PATH PARAMETERS
    model.xmin = 1;
    model.xmax = MAPSIZE_X;
    model.ymin = 1;
    model.ymax = MAPSIZE_Y;
    model.zmin = 0;
    model.zmax = max(hi);

    model.start = [200; 100; 150];
    model.end   = [800; 800; 150];

    % Number of waypoints (you can keep this at 10 or adjust as needed)
    model.n = 10;

    %% PACK STRUCT
    model.X         = X;
    model.Y         = Y;
    model.H         = H;
    model.MAPSIZE_X = MAPSIZE_X;
    model.MAPSIZE_Y = MAPSIZE_Y;
    model.threats   = threats;

    %% INITIAL PLOT
    PlotModel(model);
end
