function [climb_current_draw_, climb_time_] = MRclimb(altitude_,climb_TWR_,all_up_mass_,power_kg_,reference_voltage_)
% This function calculates the total current drawn by the vehicle to vertically climb a given altitude

% Calculating climb acceleration and climb time
MR_climbacceleration=(climb_TWR_*9.8)-9.8;     % [m/s^2] Climb rate of multi rotor mode in m/s^2
climb_time_ = sqrt(2*(altitude_/MR_climbacceleration));    % [s] Time taken to reach given altitude

% current drawn while reaching the altitude
climbthrust = all_up_mass_ * climb_TWR_;     % [Kg] Thrust generated for the above mentioned THrust to Weight ratio

climb_current_draw_ = ((climbthrust*power_kg_)/reference_voltage_)*climb_time_;    % [A] Consumption in amperes till reaching the given altitude
end

