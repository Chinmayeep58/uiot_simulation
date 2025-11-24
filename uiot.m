%% STEP 1: ENVIRONMENT SETUP
Lx = 1000; Ly = 1000; Lz = 500;
N = 20; F = 3;
T = 10;     % number of simulation time steps
% Random initial positions for underwater sensor nodes
nodes = [Lx*rand(N,1), Ly*rand(N,1), Lz*rand(N,1)];
% Random fog nodes (fixed at surface)
fogNodes = [Lx*rand(F,1), Ly*rand(F,1), zeros(F,1)];
cloudNode = [Lx/2, Ly/2, 0];
fprintf('--- Underwater Environment Initialized ---\n');
%% Communication parameters
c = 1500;             % speed of sound (m/s)
freq = 25e3;          % frequency (Hz)
f = freq/1000;        % convert to kHz
alpha = 0.11*f^2 / (1+f^2) + 44*f^2 / (4100+f^2) + 2.75e-4*f^2 + 0.003; % Thorp attenuation
maxRange = 400;       % maximum communication range (m)
%% Initialize tracking variables
avgDelayHist = zeros(T,1);
avgPacketLossHist = zeros(T,1);
connectedNodesHist = zeros(T,1);
%% Simulation loop (Mobility + Communication)
for t = 1:T
   fprintf('\n=== Time Step %d ===\n', t);
   %% Sensing Layer - Data generation
   temperature = 10 + 5*randn(N,1);
   salinity = 30 + 2*randn(N,1);
   depth = nodes(:,3);
   %% Communication Layer
   dist = pdist2(nodes, fogNodes);
   [minDist, assignedFog] = min(dist, [], 2);
   delay = minDist / c;  % propagation delay (s)
   attenuation = 10.^(-alpha .* minDist/1000 / 10);
   %% Packet Loss Model
   % Assume packet loss increases exponentially with distance & attenuation
   packetLoss = 1 - exp(-0.005 * minDist) .* attenuation;
   packetLoss(packetLoss > 1) = 1;
   packetLoss(packetLoss < 0) = 0;
   avgDelayHist(t) = mean(delay);
   avgPacketLossHist(t) = mean(packetLoss);
   connectedNodesHist(t) = sum(minDist <= maxRange);
   %% Networking Layer
   fprintf('--- Networking Layer ---\n');
   for i = 1:N
       if minDist(i) <= maxRange
           fprintf('Node %2d -> Fog %d | Dist = %.1f m | Loss = %.2f%%\n', ...
               i, assignedFog(i), minDist(i), packetLoss(i)*100);
       else
           fprintf('Node %2d -> Out of Range (%.1f m)\n', i, minDist(i));
       end
   end
   %% Fog & Cloud Layers (simplified)
   fusedData = zeros(F,2);
   for f = 1:F
       localIdx = find(assignedFog == f & minDist <= maxRange);
       if isempty(localIdx), continue; end
       fusedData(f,1) = mean(temperature(localIdx));
       fusedData(f,2) = mean(salinity(localIdx));
   end
   predTemp = mean(fusedData(fusedData(:,1)~=0,1));
   %% Application Layer
   threshold = mean(fusedData(:,1),'omitnan') + 2;
   anomalyNodes = find(temperature > threshold);
   if ~isempty(anomalyNodes)
       fprintf('Anomalies: %s\n', mat2str(anomalyNodes'));
   end
   %% Visualization (Dynamic Network Plot)
   figure(1); clf;
   subplot(1,2,1);
   scatter3(nodes(:,1), nodes(:,2), nodes(:,3), 60, temperature, 'filled'); hold on;
   scatter3(fogNodes(:,1), fogNodes(:,2), fogNodes(:,3), 150, 'r', 'filled');
   scatter3(cloudNode(1), cloudNode(2), cloudNode(3), 200, 'k', 'filled');
   title(sprintf('Time Step %d: Node Mobility + Connectivity', t));
   xlabel('X (m)'); ylabel('Y (m)'); zlabel('Depth (m)');
   legend('Sensors','Fog Nodes','Cloud Node','Location','best');
   colormap('jet'); colorbar;
   % draw connections
   for i = 1:N
       if minDist(i) <= maxRange
           f = assignedFog(i);
           plot3([nodes(i,1), fogNodes(f,1)], ...
                 [nodes(i,2), fogNodes(f,2)], ...
                 [nodes(i,3), fogNodes(f,3)], 'k--');
       end
   end
   grid on; axis([0 Lx 0 Ly 0 Lz]);
   subplot(1,2,2);
   bar([avgDelayHist(1:t), avgPacketLossHist(1:t), connectedNodesHist(1:t)]);
   xlabel('Time Step');
   ylabel('Metric Value');
   legend('Avg Delay (s)','Avg Packet Loss','Connected Nodes','Location','best');
   title('Network Performance Over Time');
   drawnow;
   %% Mobility Model (Random Drift)
   drift = 5 * randn(N,3);  % random movement (±5 m per axis)
   nodes = nodes + drift;
   % keep within boundaries
   nodes(:,1) = min(max(nodes(:,1),0),Lx);
   nodes(:,2) = min(max(nodes(:,2),0),Ly);
   nodes(:,3) = min(max(nodes(:,3),0),Lz);
   pause(0.5);
end
fprintf('\n Simulation completed with mobility and packet loss modeling.\n');