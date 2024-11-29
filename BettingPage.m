function current_amount = BettingPage(card_scene)

    chip_sprites = [81, 82, 83, 84, 85];  
    function_buttons = [86, 87];          
    chip_values = [5, 10, 25, 50, 100];   
    digit_sprites = [91, 12:20];  

    current_amount = 0;  
    undo_stack = 0;    
    current_page = 1;    

    % Function to draw the betting page
    function drawBettingPage(card_scene, amount_sprites, chip_sprites, function_buttons)
        scene_matrix = [
            95, 96, 97, ones(1, 4);                          
            79, 80, ones(1,5);                          
            89, 90, ones(1,4), 88;                      
            amount_sprites;                     
            ones(1,7);                          
            [chip_sprites, function_buttons]    
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

    % Main game loop for betting
    betting_done = false;
    while ~betting_done
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
                    % Finish betting and confirm amount
                    betting_done = true;
                end
            elseif row == 3 && col == 7  % "88" button clicked
                % Undo the last operation (revert to previous amount)
                if length(undo_stack) > 1
                    current_amount = undo_stack(end); 
                    undo_stack(end) = [];             
                else
                    % Default to 0 if stack is empty
                    current_amount = 0;  
                end

                % Update the displayed amount
                amount_sprites = updateAmountSprites(current_amount, digit_sprites);

                % Redraw the betting page
                drawBettingPage(card_scene, amount_sprites, chip_sprites, function_buttons);

                % Display current amount and undo stack 
                disp(['Current amount after undo: ' num2str(current_amount)]);
                disp(['Undo stack after undo: ' num2str(undo_stack)]);
            end
        end
    end
end
