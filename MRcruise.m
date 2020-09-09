function [cruise_current_required_, cruise_time,hover_current_required_ ] = MRcruise(reference_voltage_, power_kg, all_up_mass_, hover_time, cruise_distance_, cruise_speed)
% This function calculates the current drawn by the multi-modal vehicle
% to hover and cruise as per mission requirements

MR_AAD = (all_up_mass_*power_kg)/reference_voltage_;   % [A] Average Ampere draw per second to hover the vehicle

% Multi-rotor cruise
cruise_time = cruise_distance_/cruise_speed;      % [s] Time taken to reach the destination at given distance

cruise_current_required_ = cruise_time * MR_AAD;    % [A] Current drawn to fly towards destination at given distance

% Multi-rotor hover
hover_current_required_ = MR_AAD*hover_time;     % [As] Total current drawn to hover for defined time

end

