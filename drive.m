function [time_to_destination_,avgspeed_,total_ampere_draw_] = drive(thrust_, distance_,all_up_mass_,current_to_force_,ground_friction_)
% This function calculates the total current drawn in driving mode to
% travel the designated mission distance

% From F=ma, Force in Newtons is converted to Kg by replacing it with
% (thrust x g) to calculate vehicle acceleration in m/s^2 

DM_acceleration = (thrust_*9.8)/(all_up_mass_*ground_friction_);   % [m/s^2] Acceleration while driving
time_to_destination_ = sqrt(2*(distance_/DM_acceleration));   % [s] Time taken to reach the destination while driving
avgspeed_ = distance_/time_to_destination_;    % [m/s] Average speed while reaching the destination
total_ampere_draw_ = current_to_force_*10*thrust_*time_to_destination_;   % [A] Total ampere draw to reach destination while driving
end

