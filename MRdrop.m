function [drop_current_draw_, drop_time_] = MRdrop(altitude_,drop_TWR_,all_up_mass_,power_kg_,reference_voltage_);
% This function calculates the total current drawn by the vehicle to vertically drop the given altitude

% Calculating drop acceleration and drop time               
MR_dropacceleration=9.8-(drop_TWR_*9.8); % [m/s^2] Climb rate of multi rotor mode in m/s^2
drop_time_ = sqrt(2*(altitude_/MR_dropacceleration)); % [s] Time taken to reach given altitude

% current drawn while droping the altitude
dropthrust = all_up_mass_ * drop_TWR_; % [Kg] Thrust generated for the above mentioned THrust to Weight ratio
drop_current_draw_ = ((dropthrust*power_kg_)/reference_voltage_)*drop_time_; % [A] Consumption in amperes till reaching the ground from the given altitude
end

