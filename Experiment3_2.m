%%%%%%%%%%%%%%%%%%% Vehicle Variables
vehicle.all_up_mass_ = 2.7; % [Kg] Vehicle All Up Mass (AUM)
vehicle.altitude_ = 25; % [m] 
FW.lift_to_drag_ = 4; % [-] lift to drag ratio
FW.wing_area_ = 0.075; % [m^2] area of main wing

%%%%%%%%%%%%%%%%%%%%% Motor Variables
motor.current_to_force_ = 1.39; % [A/N] current reqired for each newton of force
motor.reference_voltage_ = 14.8; % [V] potential difference for motor
motor.amp_1000g_ = 13.9; % [A] Ampere draw to produce 100 grams of thrust by BLDC
motor.power_kg_ = motor.amp_1000g*motor.reference_voltage_; % [W] Power consumed to generate 1 Kilogram thrust


%%%%%%%%%%%%%%%%%%%%% Environment Variables
environment.rho_ = 1.225; % [Kg/m^3] sea level air density
environment.gravity_ = 9.81; % [m/s^2] sea level gravity

%%%%%%%%%%%%%%%%%%%% Performance Variables

% Fixed Wing Variables
FW.cruise_lift_coefficient_ = 0.2565; % [-] cruise lift coefficient
FW.cruise_speed_ = nan; % [m/s] fixedwing cruise speed
FW.cruise_thrust_ = nan; % [N] fixedwing cruise thrust
FW.cruise_current_required_ = nan; % [A] fixedwing cruise current draw


% Multi-rotor Cruise Variables
MR.hover_time_ = 0; % [s] Multi-rotor hover time
MR.cruise_speed_ = 15; % [m/s] Multi-rotor cruise speed

MR.cruise_time_ = nan; % [s] Multi-rotor cruise time
MR.cruise_current_required_ = nan; % [A] Multi-rotor cruise current draw

% Multi-Rotor Climb Variables
MR.climb_TWR_ = 1.1; %[-] Multi-rotor climb Thrust to Weight ratio
MR.climb_time_ = nan; %[s] Multi-rotor climb time
MR.climb_current_draw_=nan; %[A] Multi-rotor climb current draw

% Multi-Rotor Drop Variables
MR.drop_TWR_ = 0.9; %[-] Multi-rotor drop Thrust to Weight ratio
MR.drop_current_draw_ = nan; %[A] Multi-rotor drop current draw
MR.drop_time_ = nan; %[s] Multi-rotor drop time

% Driving Variables

DM.thrust_ = 0.1; %[-] Driving mode Thrust to Weight ratio
DM.ground_friction_ = 1; %[-] Driving surface friction co-efficient


DM.time_to_destination_ = nan; %[s] Driving mode drive time
DM.avgspeed_ = nan; %[m/s] Driving mode avergae speed
DM.total_ampere_draw_ = nan; %[A] Driving mode total current draw


%%%%%%%%%%%%%%%%%%%% Mission Variables
mission.energy_required_multimodal = nan; % [J] energy required to travel using multi-modal from A to B
mission.energy_required_multirotor = nan; % [J] energy required to travel using multi-rotor from A to B


%%%%%% Calling various functions with respect to experiment requirements 
for distance = 0:1:1000
    % Defining percentage of mission distance for each mode of operation
    mission.distance_ = distance;
    FW.cruise_distance_ = mission.distance_*0.7;
    DM.distance_ = mission.distance_*0.2;
    MR.cruise_distance_ = 0.1*mission.distance_;
    % Re-initiating the multi-modal and multi-rotorenergy variable 
    % for every new iteration of the loop
    mission.energy_required_multimodal = nan;
    mission.energy_required_multirotor = nan;
     
    %%%%%%%% Multi-modal operation and energy consumption
    % Evaluating current drawn for multi-rotor altitude climb
    [MR.climb_current_draw_, MR.climb_time_] = MRclimb(vehicle.altitude_,MR.climb_TWR_,vehicle.all_up_mass_,motor.power_kg_,motor.reference_voltage_);

    % Evaluating current drawn for fixed-wing cruise        
    [FW.cruise_speed_, FW.cruise_thrust_, FW.cruise_current_required] = FWCruise(FW.lift_to_drag_,vehicle.all_up_mass_, FW.cruise_lift_coefficient_,...
    environment.rho_,FW.wing_area_,motor.amp_1000g, FW.cruise_distance_);
                            
     % Evaluating current drawn for multi-rotor altitude drop         
    [MR.drop_current_draw_, MR.drop_time_] = MRdrop(vehicle.altitude_,MR.drop_TWR_,vehicle.all_up_mass_,motor.power_kg_,motor.reference_voltage_);
           
     % Evaluating current drawn for driving mode        
    [DM.time_to_destination_,DM.avgspeed_,DM.total_ampere_draw_] = drive(DM.thrust_, DM.distance_,vehicle.all_up_mass_,motor.current_to_force_,DM.ground_friction_);
   
    % Evaluating current drawn for multi-rotor cruise
    [MR.cruise_current_required_, MR.cruise_time,MR.hover_current_required_ ] = MRcruise(motor.reference_voltage_, motor.power_kg_, vehicle.all_up_mass_,...
    MR.hover_time_, MR.cruise_distance_, MR.cruise_speed_);
    
    % Adding the current drawn by each mode used in the multi-modal operation
    % based on how many times each function is used and converting it into
    % Joules
    mission.energy_required_multimodal = ((2*MR.drop_current_draw_)+MR.cruise_current_required_+DM.total_ampere_draw_+FW.cruise_current_required+(2*MR.climb_current_draw_))*motor.reference_voltage_;
    
    
    %%%%% Multi-rotor operation and energy consumption
    MR.cruise_distance_ = mission.distance_;
    
    % Evaluating current drawn for multi-rotor cruise
    [MR.cruise_current_required_, MR.cruise_time,MR.hover_current_required_ ] = MRcruise(motor.reference_voltage_, motor.power_kg_, vehicle.all_up_mass_,...
    MR.hover_time_, MR.cruise_distance_, MR.cruise_speed_);

    % Adding the current drawn by multi-rotor based on how many times 
    % each function is used and converting it into Joules
    mission.energy_required_multirotor = (MR.drop_current_draw_+MR.cruise_current_required_+MR.hover_current_required_+ MR.climb_current_draw_)*motor.reference_voltage_;
    difference = mission.energy_required_multirotor - mission.energy_required_multimodal;
    
    % Plot the energy consumption of each vehicle and their difference
    plot(distance,mission.energy_required_multimodal,'-','Marker','.','Color','G')
    hold on;
    plot(distance,mission.energy_required_multirotor,'-','Marker','.','Color','R')
    hold on;
    plot(distance,difference,'-','Marker','.','Color','B')
    hold on;
    if (mission.energy_required_multirotor<mission.energy_required_multimodal)
        disp(distance)
    end
    title('Energy Consumption Comparison')
    xlabel('Mission Distance(m)')
    ylabel('Energy consumed(J)')
    legend('Multi-modal','Multi-rotor','Difference','Location','northwest')
    grid on;
    
end