clc;
clear;

% Set up the background color
background = [53, 101, 77];

% Initialize the game scene using the sprite sheet
card_scene = simpleGameEngine('images/pixil-frame-0.png', 16, 16, 8, background);

% Define the chip sprites and their values
chip_sprites = [81, 82, 83, 84, 85];  
function_buttons = [86, 87];          
chip_values = [5, 10, 25, 50, 100];   

% Define the mapping for number sprites (11-20 represent 0-9)
digit_sprites = 11:20;  

% Initialize the displayed amount and undo stack
current_amount = 0;  
undo_stack = [0];    
current_page = 1;    

% Function to draw betting page
function drawBettingPage(card_scene, amount_sprites, chip_sprites, function_buttons)
    scene_matrix = [
        ones(1,7);                          
        ones(1,7);                          
        ones(1,6), 88;                      
        amount_sprites;                     
        ones(1,7);                          
        [chip_sprites, function_buttons]    
    ];
    drawScene(card_scene, scene_matrix);
end

% Function to draw second page
function drawSecondPage(card_scene)
    scene_matrix = [
        ones(1,7);           
        ones(1,7);           
        ones(1,7);           
        ones(1,7);           
        ones(1,7);           
        ones(1,7)            
    ];
    drawScene(card_scene, scene_matrix);
end

% Function to update the displayed amount
function amount_sprites = updateAmountSprites(current_amount, digit_sprites)
    amount_sprites = ones(1, 7);  
    num_str = sprintf('%d', current_amount);
    for i = 1:length(num_str)
        digit = str2double(num_str(i));
        amount_sprites(8-length(num_str)+i-1) = digit_sprites(digit + 1);
    end
end

% Initial draw of the betting page
amount_sprites = updateAmountSprites(current_amount, digit_sprites);
drawBettingPage(card_scene, amount_sprites, chip_sprites, function_buttons);

% Main game loop
while true
    % Get mouse input
    [row, col, ~] = getMouseInput(card_scene);
    
    if current_page == 1  
        % Check if a chip, function button, or "88" button was clicked
        if row == 6
            if col >= 1 && col <= 5  % Chip clicked
                % Push the current amount onto the undo stack
                undo_stack = [undo_stack, current_amount];
                
                % Update the amount based on the clicked chip
                current_amount = current_amount + chip_values(col);
                
                % Update the displayed amount
                amount_sprites = updateAmountSprites(current_amount, digit_sprites);
                
                % Redraw the betting page
                drawBettingPage(card_scene, amount_sprites, chip_sprites, function_buttons);
                
                % Display current amount and undo stack (for debugging)
                disp(['Current amount: ' num2str(current_amount)]);
                disp(['Undo stack: ' num2str(undo_stack)]);
                
            elseif col == 6 || col == 7  
                % Switch to second page
                current_page = 2;
                drawSecondPage(card_scene);
                disp('Switched to second page');
            end
        elseif row == 3 && col == 7  % "88" button clicked
            % Undo the last operation (revert to previous amount)
            if length(undo_stack) > 1
                current_amount = undo_stack(end); 
                undo_stack(end) = [];             
            else
                current_amount = 0;  % Default to 0 if stack is empty
            end
            
            % Update the displayed amount
            amount_sprites = updateAmountSprites(current_amount, digit_sprites);
            
            % Redraw the betting page
            drawBettingPage(card_scene, amount_sprites, chip_sprites, function_buttons);
            
            % Display current amount and undo stack 
            disp(['Current amount after undo: ' num2str(current_amount)]);
            disp(['Undo stack after undo: ' num2str(undo_stack)]);
        end
    else  % On second page
        % Add return or other functionality
        % Example: Click anywhere to return to betting page
        current_page = 1;
        drawBettingPage(card_scene, amount_sprites, chip_sprites, function_buttons);
        disp('Returned to betting page');
    end
end