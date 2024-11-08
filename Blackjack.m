clear
close all
clc

% Initialize sprite engine
sprite_height = 16;
sprite_width = 16;
zoom = 4;
background_color = [34, 139, 34]; % dark green, like a blackjack table

cardEngine = simpleGameEngine('retro_cards.png', sprite_height, sprite_width, zoom, background_color);

% Initial card layout (scene 1)
cardLayout = [
    1, 1, 1, 1, 1;  
    1, 1, 1, 1, 1;
    1, 1, 1, 1, 3;  % Deck of cards        
    1, 1, 1, 1, 1;
    1, 1, 1, 1, 1;  
];

cardEngine.drawScene(cardLayout);
xlabel("This is just the base scene with no cards drawn")
% Wait for 'S' key press to continue to next scene
title("Press S to continue to the next scene");
while true
    key = getKeyboardInput(cardEngine);
    if key == 's'  % Check if 'S' is pressed
        break;  % Exit the loop and proceed
    end
    pause(0.1);  % Small pause to avoid overloading the CPU
end

% 2 unflipped dealer and 2 unflipped player cards, with deck of cards to the right (scene 2)
cardLayoutScene2 = [
    1, 1, 3, 3, 1;  % Dealer cards (face down)
    1, 1, 1, 1, 1;
    1, 1, 1, 1, 3;  % Deck of cards        
    1, 1, 1, 1, 1;
    1, 1, 3, 3, 1;  % Player cards (face down)
];

cardEngine.drawScene(cardLayoutScene2);
xlabel("This has 4 cards face down before they are flipped")
% Wait for 'S' key press to continue to the next scene
title("Press S to reveal the cards");
while true
    key = getKeyboardInput(cardEngine);
    if key == 's'  % Check if 'S' is pressed
        break;  % Exit the loop and proceed
    end
    pause(0.1);  % Small pause to avoid overloading the CPU
end

% Generate random cards for dealer and player
card_ids = 21:73;  % The card IDs in the sprite sheet

dealerCards = card_ids(randi(numel(card_ids)));  
playerCards = card_ids(randi(numel(card_ids)));    % Gets random card from index in sprite sheet
playerCards = [playerCards; card_ids(randi(numel(card_ids)))]; % Gets another random card from index in sprite sheet

% Define the layout for scene 3 (cards revealed)
cardLayoutScene3 = [
    1, 1, dealerCards, 3, 1;  % Dealer cards (revealed)
    1, 1, 1, 1, 1;
    1, 1, 1, 1, 3;  % Deck of cards        
    1, 1, 1, 1, 1;
    1, 1, playerCards(1), playerCards(2), 1;  % Player cards (revealed)
];

cardEngine.drawScene(cardLayoutScene3);
xlabel("2 player cards are flipped, 1 dealer card is flipped")

title(" ")

