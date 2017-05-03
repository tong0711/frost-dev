function [tspan, states, inputs, params] = exportSolution(obj, sol)
    % Analyzes the solution of the NLP problem
    %
    % Parameters:
    % sol: The solution vector of the NLP problem @type colvec
    % t0: the initial time @type double
    %
    % Return values:
    % tspan: the time span of the trajectory @type rowvec
    % states: the state trajectories @type struct
    % inputs: the input variable trajectories @type struct
    % params: the parameter variables @type struct
    
    
    
    
    states = struct();
    inputs = struct();
    params = struct();
    
    vars = obj.OptVarTable;
    if obj.NumNode > 1
        if isnan(obj.Options.ConstantTimeHorizon)
            T = sol(vars.T(1).Indices);
        else
            T = obj.Options.ConstantTimeHorizon;
        end
        
        switch obj.Options.CollocationScheme
            case 'HermiteSimpson'
                tspan = T(1):(T(2)-T(1))/(obj.NumNode-1):(T(2));
            case 'Trapezoidal'
                tspan = T(1):(T(2)-T(1))/(obj.NumNode-1):(T(2));
            case 'PseudoSpectral'
            otherwise
                error('Undefined integration scheme.');
        end
    else
        tspan = {};
    end
    
    plant = obj.Plant;
    state_names = fieldnames(plant.States);
    states = struct();
    for j=1:length(state_names)        
        name = state_names{j};
        
        states.(name) = sol([vars.(name).Indices]);
    end
    inputs = struct();
    input_names = fieldnames(plant.Inputs.Control);
    if ~isempty(input_names)        
        for j=1:length(input_names)
            name = input_names{j};            
            inputs.(name) = sol([vars.(name).Indices]);
        end
    end
    
    input_names = fieldnames(plant.Inputs.ConstraintWrench);
    if ~isempty(input_names)        
        for j=1:length(input_names)
            name = input_names{j};            
            inputs.(name) = sol([vars.(name).Indices]);
        end
    end
    
    
    input_names = fieldnames(plant.Inputs.External);
    
    if ~isempty(input_names)        
        for j=1:length(input_names)
            name = input_names{j};            
            inputs.(name) = sol([vars.(name).Indices]);
        end
    end
    
    
    
    param_names = fieldnames(plant.Params);
    params = struct();
    if ~isempty(param_names)        
        for j=1:length(param_names)
            name = param_names{j};            
            params.(name) = sol([vars.(name)(1).Indices]);
        end
    end
            
    
    
    
    
end