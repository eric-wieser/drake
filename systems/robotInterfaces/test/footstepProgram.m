function [plan, seed, solvertime] = footstepProgram(biped, seed_plan, weights, goal_pos)

nsteps = length(seed_plan.footsteps);
p = MixedIntegerFootstepPlanningProblem(biped, seed_plan, true);
p.weights = weights;
p = p.addQuadraticGoalObjective(goal_pos, nsteps-1:nsteps, [1,1], true);
p = p.addRotationOuterUnitCircle(8, true);
p = p.addQuadraticRelativeObjective(true);
p = p.addZAndYawReachability(true);
p = p.addXYReachabilityCircles(true);

p = p.solve();

steps = zeros(6, nsteps);
steps(p.pose_indices, :) = p.vars.footsteps.value
% p.vars.cos_yaw.value
% p.vars.sin_yaw.value

figure(21)
clf
hold on
plot(p.vars.cos_yaw.value, p.vars.sin_yaw.value, 'bo')
plot(cos(p.vars.footsteps.value(4,:)), sin(p.vars.footsteps.value(4,:)), 'ro')
plot(cos(linspace(0, 2*pi)), sin(linspace(0, 2*pi)), 'k-')
ylim([-1.1,1.1])
axis equal

plan = seed_plan;
for j = 1:nsteps
  plan.footsteps(j).pos = steps(:,j);
end

seed = [];
solvertime = 0;
