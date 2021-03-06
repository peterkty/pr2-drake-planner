
warning('off','all');

DRAKE_PATH = '/home/drc/drc/software/drake';

if(~exist('r','var'))
  fprintf('Loading Robot Model...');
  r = RigidBodyManipulator(strcat(DRAKE_PATH,'/examples/PR2/pr2.urdf'),struct('floating',true));
  fprintf('Done\n');
end

dof = r.getNumDOF;
q0 = zeros(dof, 1);

planner = pr2Planner(r);

cabinet_reach_pos = [1,0,1]'; % specify drawer pose (x,y,z)
cabinet_open_pos =  [0,-1,1]';  


T = 10; % seconds
basefixedOnReach = false;
basefixedOnLine = true;
torsofixedOnReach = true;
torsofixedOnCircle = true;
pos_center = [1,0,1]';
radius = 0.5;
deg1 = pi/2;
deg2 = pi;
[xtraj,snopt_info,infeasible_constraint,q_end] = ...
    planner.createReachAndCirclePlan(q0, pos_center, radius, deg1, deg2, T, basefixedOnReach, basefixedOnCircle, torsofixedOnReach, torsofixedOnCircle);
snopt_info;

kinsol = r.doKinematics(q_end(1:dof));
gripper_point = [0.13,0,0]'
reality_reach2 = r.forwardKin(kinsol,findLinkInd(r,'r_gripper_palm_link'),gripper_point);
reality_reach2



planner.publishTraj(xtraj,1);
planner.v.playback(xtraj);





% [xtraj_reach,snopt_info_reach,infeasible_constraint_reach, qnow1] = ...
%     planner.createPointPlan(q0, drawer_close_pos, 10, false);
% 
% kinsol = r.doKinematics(qnow1);
% reality_reach1 = r.forwardKin(kinsol,findLinkInd(r,'r_gripper_palm_link'),[0,0,0]');
% reality_reach1
% snopt_info_reach
% 
% [xtraj_reach,snopt_info_reach,infeasible_constraint_reach, qnow2] = ...
%     planner.createLinePlan(qnow1, reality_reach1, drawer_open_pos, 30, true);
% 
% snopt_info_reach
% infeasible_constraint_reach
% kinsol = r.doKinematics(qnow2);
% reality_reach2 = r.forwardKin(kinsol,findLinkInd(r,'r_gripper_palm_link'),[0,0,0]');
% reality_reach2

