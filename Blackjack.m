clc
clear

% Declare global variables to store the dealer's and player's value rows
global dealerValRow playerValRow

% Set the background color
background = [53, 101, 77];

% Load card sprite image using simpleGameEngine
card_scene = simpleGameEngine('images/pixil-frame-0.png', 16, 16, 8, background);

% Define offset for sprite IDs to skip unnecessary sprites
skip_sprites = 20;

% =============== START PAGE ===================

% Define the start page layout
startPageArray = [
    1, 1, 1, 1, 1, 1, 1;
    1, 5, 6, 7, 8, 9, 1;
    1, 10, 7, 8, 9, 1, 1;
    1, 1, 1, 1, 1, 1, 1;
    1, 1, 98, 99, 100, 1, 1;
    1, 1, 1, 1, 1, 1, 1];

% Draw the start page
drawScene(card_scene, startPageArray);

% Initialize the game start flag
gameStart = false;

% Wait for the user to click the "Start Game" button
while ~gameStart
    [r, c, b] = getMouseInput(card_scene);
    if r == 5 && (c == 3 || c == 4 || c == 5)
        gameStart = true;
        % Close the start page
        close all;
    end
end

% =============== BETTING PAGE ===================

% Display the betting page and get the current bet amount
current_amount = BettingPage(card_scene);

% =============== GAME START ===================

% create 2 random card sprites on the player's side
card_vals_start = randi(13, 1, 2);
card_suits_start = randi(4, 1, 2) - 1;
card_sprites_start = skip_sprites + 13 * card_suits_start + card_vals_start;

% Store all cards played so far
cardsPlayed = card_sprites_start;

% create 1 random card sprite on the player's side
card_val = randi(13, 1, 1);
card_suit = randi(4, 1, 1) - 1;
card_sprite = skip_sprites + 13 * card_suit + card_val;

% Add the new card to the list of played cards
cardsPlayed(length(cardsPlayed) + 1) = card_sprite;

% create 1 random card sprite on the dealer's side
card_val_dealer = randi(13, 1, 1);
card_suit_dealer = randi(4, 1, 1) - 1;
card_sprite_dealer = skip_sprites + 13 * card_suit_dealer + card_val_dealer;

% Add the dealer's card to the list of played cards
cardsPlayed(length(cardsPlayed) + 1) = card_sprite_dealer;

% Set up the initial hand arrays
% Start tracking player's cards from index 3
playerCardIndex = 3;
% Player's card array
playerCards = [card_sprites_start, 1, 1, 1, 1, 1];

% Dealer starts with one card face up
dealerCardIndex = 2;
% Dealer's card array
dealerCards = [card_sprite_dealer, 3, 1, 1, 1, 1, 1];

% Define the restart button sprite
restartButtonSprite = 93;

% Display the initial game screen
updateScreen(dealerCards,playerCards);

% Draw the current game scene
drawScene(card_scene, [card_sprite_dealer, 3, 1, 1, 1, 1, 1; ...
    dealerValRow; ...
    1, 1, 1, 1, 1, 1, restartButtonSprite; ...
    playerValRow; ...
    playerCards; ...
    1, 75, 76, 1, 77, 78, 1]);

% Initialize the flag indicating it's the player's turn
playerPlaying = true;

% =============== PLAYER'S TURN ===================

% Handle player actions (HIT, HOLD, or RESTART) during their turn
while(playerPlaying)
    % get where the mouse was clicked
    [r, c, b] = getMouseInput(card_scene);
    % If the restart button (at row 3, column 7) is clicked
    if r == 3 && c == 7
        % Close the game window
        close all;
        % Clear the console
        clc;
        % Restart the game by running the script again
        run('Blackjack.m');
        % Exit the loop and restart the game
        break;
    end

    % Handle HOLD action (player stands)
    if r == 6 && (c == 5 || c == 6 )
        % Initialize card-drawing flag for dealer
        pulledNewCard = false;

        % Loop until a valid card is drawn for the dealer
        while ~pulledNewCard
            card_val_dealer = randi(13, 1, 1);
            card_suit_dealer = randi(4, 1, 1) - 1;
            card_sprite_dealer = skip_sprites + 13 * card_suit_dealer + card_val_dealer;

            % Reset the flag
            pulledNewCard = false;

            % Check if the drawn card is already played
            for i = 1: length(cardsPlayed)
                if cardsPlayed(i) == card_sprite_dealer
                    % Mark as duplicate and redraw
                    pulledNewCard = true;
                end
            end
        end

        % Add the new dealer card to the dealer's hand
        dealerCards(dealerCardIndex) = card_sprite_dealer;
        dealerCardIndex = dealerCardIndex + 1;

        % Determine the outcome of the game by comparing hand values
        if getHandValue(dealerCards) > getHandValue(playerCards)
            % Dealer wins
            win = false;
        elseif getHandValue(dealerCards) == getHandValue(playerCards)
            % Tie
            win = 3;
        else
            % Player wins
            win = true;
        end

        % Update the game screen with the dealer's and player's cards
        updateScreen(dealerCards,playerCards);
        drawScene(card_scene, [dealerCards; ...
            dealerValRow; ...
            1, 1, 1, 1, 1, 1, restartButtonSprite; ...
            playerValRow; ...
            playerCards; ...
            1, 75, 76, 1, 77, 78, 1]);

        % End the player's turn after HOLD
        playerPlaying = false;

        % Handle HIT action (when player decides to draw a card)
        % HIT buttons are at these columns
    elseif r == 6 && (c == 2 || c == 3)
        % Initialize card-drawing flag for player
        pulledNewCard = false;

        % Loop until a valid card is drawn for the player
        while ~pulledNewCard
            % Random card value (1-13)
            card_val = randi(13, 1, 1);
            % Random suit (0-3)
            card_suit = randi(4, 1, 1) - 1;
            card_sprite = skip_sprites + 13 * card_suit + card_val;

            % Assume valid card initially
            pulledNewCard = true;

            % Check if the drawn card is already played
            for i = 1: length(cardsPlayed)
                if cardsPlayed(i) == card_sprite
                    % Mark as duplicate and redraw
                    pulledNewCard = false;
                end
            end
        end

        % Add the new card to the player's hand
        playerCards(playerCardIndex) = card_sprite;
        playerCardIndex = playerCardIndex + 1;

        % Update the game screen with the dealer's and player's cards
        updateScreen(dealerCards,playerCards);

        % Check if the player busted or got a blackjack
        if getHandValue(playerCards) > 21
            % Player busts
            playerPlaying = false;
            % Dealer wins
            win = false;
        elseif getHandValue(playerCards) == 21
            % Player gets blackjack
            playerPlaying = false;
            % Player wins
            win = true;
        end

        % Redraw the game screen with updated hands
        drawScene(card_scene, [card_sprite_dealer, 3, 1, 1, 1, 1, 1; ...
            dealerValRow; ...
            1, 1, 1, 1, 1, 1, restartButtonSprite; ...
            playerValRow; ...
            playerCards; ...
            1, 75, 76, 1, 77, 78, 1]);
    end
end

% Evaluate the outcome after the player's turn ends
if ~playerPlaying
    winnerSprite = 92;
    loserSprite = 94;
    dollarSprite = 88;
    % Sprite IDs for numbers 0-9
    numberSprites = [91, 12:20];

    % Calculate the final amount based on the game result
    final_amount = determinePayout(playerCards, dealerCards, current_amount);

    % Update the value rows based on the game outcome
    if (getHandValue(playerCards) > 21)
        % Player Busted - Dealer Wins
        dealerValRow = [dealerValRow(1:end-1), winnerSprite];
        playerValRow = [playerValRow(1:end-1), loserSprite];
    elseif (getHandValue(dealerCards) > 21)
        % Dealer Busted - Player Wins
        dealerValRow = [dealerValRow(1:end-1), loserSprite];
        playerValRow = [playerValRow(1:end-1), winnerSprite];
    elseif (getHandValue(playerCards) > getHandValue(dealerCards))
        % Player Wins
        dealerValRow = [dealerValRow(1:end-1), loserSprite];
        playerValRow = [playerValRow(1:end-1), winnerSprite];
    elseif (getHandValue(playerCards) < getHandValue(dealerCards))
        % Dealer Wins
        dealerValRow = [dealerValRow(1:end-1), winnerSprite];
        playerValRow = [playerValRow(1:end-1), loserSprite];
    else
        % Tie - No winner or loser
        dealerValRow = [dealerValRow(1:end-1), 1];
        playerValRow = [playerValRow(1:end-1), 1];
    end

    % Redraw the scene with updated `dealerValRow` and `playerValRow`
    drawScene(card_scene, [dealerCards; ...
        dealerValRow; ...
        1, 1, 1, 1, 1, 1, restartButtonSprite; ...
        playerValRow; ...
        playerCards; ...
        1, 75, 76, 1, 77, 78, 1]);

    % Pause briefly before showing the final page
    pause(2.0);

    % Prepare to display the final amount
    finalAmountSprites = ones(1, 7);
    finalAmountSprites(1) = dollarSprite;
    amountStr = sprintf('%d', final_amount);
    
    for i = 1:length(amountStr)
        % Map each digit to its corresponding sprite
        finalAmountSprites(i + 1) = numberSprites(str2double(amountStr(i)) + 1);
    end
    if length(amountStr) < 6
        % Fill remaining positions with empty sprites if the amount is short
        finalAmountSprites(length(amountStr) + 2:end) = 1;
    end

    % ================= FINAL PAGE =====================

    % Define the final screen layout based on the game result
    if (getHandValue(playerCards) > 21)
        % Player busted - Display losing message
        finalPageArray = [
            1, 1, 1, 1, 1, 1, 1;
            1, 1, loserSprite, loserSprite, loserSprite, 1, 1;
            finalAmountSprites;
            1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, restartButtonSprite, 1, 1;
            1, 1, 1, 1, 1, 1, 1;
            ];
    elseif (getHandValue(dealerCards) > 21)
        % Dealer busted - Display winning message
        finalPageArray = [
            1, 1, 1, 1, 1, 1, 1;
            1, 1, winnerSprite, winnerSprite, winnerSprite, 1, 1;
            finalAmountSprites;
            1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, restartButtonSprite, 1, 1;
            1, 1, 1, 1, 1, 1, 1;
            ];
    elseif (getHandValue(playerCards) == getHandValue(dealerCards))
        % It's a tie - Display tie message
        finalPageArray = [
            1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 73, 74, 1, 1;
            finalAmountSprites;
            1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, restartButtonSprite, 1, 1;
            1, 1, 1, 1, 1, 1, 1;
            ];
    elseif (getHandValue(playerCards) > getHandValue(dealerCards))
        % Player wins - Display winning message
        finalPageArray = [
            1, 1, 1, 1, 1, 1, 1;
            1, 1, winnerSprite, winnerSprite, winnerSprite, 1, 1;
            finalAmountSprites;
            1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, restartButtonSprite, 1, 1;
            1, 1, 1, 1, 1, 1, 1;
            ];
    else
        % Dealer wins - Display losing message
        finalPageArray = [
            1, 1, 1, 1, 1, 1, 1;
            1, 1, loserSprite, loserSprite, loserSprite, 1, 1;
            finalAmountSprites;
            1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, restartButtonSprite, 1, 1;
            1, 1, 1, 1, 1, 1, 1;
            ];
    end

    % Display the final page
    drawScene(card_scene, finalPageArray);

    % Wait for the user to click the restart button
    restart = false;
    restartButtonRow = 5;
    restartButtonCol = 5;
    while ~restart
        [r, c, b] = getMouseInput(card_scene);
        if r == restartButtonRow && c == restartButtonCol
            % Close the game window
            close all;
            % Clear the console
            clc;
            % Restart the game
            run('Blackjack.m');
            % Exit the loop
            restart = true;
        end
    end
end