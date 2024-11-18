clc
clear

global dealerValRow playerValRow

% make the scenes using simpleGameEngine
background = [53, 101, 77];

card_scene = simpleGameEngine('images/retro_cards.png', 16, 16, 8, background);

skip_sprites = 20;

% create 2 random card sprites on the player's side
card_vals_start = randi(13, 1, 2);
card_suits_start = randi(4, 1, 2) - 1;
card_sprites_start = skip_sprites + 13 * card_suits_start + card_vals_start;

cardsPlayed = card_sprites_start;

% create 1 random card sprite on the player's side
card_val = randi(13, 1, 1);
card_suit = randi(4, 1, 1) - 1;
card_sprite = skip_sprites + 13 * card_suit + card_val;

cardsPlayed(length(cardsPlayed) + 1) = card_sprite;

% create 1 random card sprite on the dealer's side
card_val_dealer = randi(13, 1, 1);
card_suit_dealer = randi(4, 1, 1) - 1;
card_sprite_dealer = skip_sprites + 13 * card_suit_dealer + card_val_dealer;

cardsPlayed(length(cardsPlayed) + 1) = card_sprite_dealer;

playerCardIndex = 3;
playerCards = [card_sprites_start, 1, 1, 1, 1, 1];

dealerCardIndex = 2;
dealerCards = [card_sprite_dealer, 3, 1, 1, 1, 1, 1];

updateScreen(dealerCards,playerCards);

% draw the first scene
drawScene(card_scene, [card_sprite_dealer, 3, 1, 1, 1, 1, 1; ...
    dealerValRow; ...
    1, 1, 1, 1, 1, 1, 1; ...
    playerValRow; ...
    playerCards; ...
    1, 75, 76, 1, 77, 78, 1]);

playerPlaying = true;

% if the HIT button was clicked show the next scene with both of the
% dealer's cards face up
% if the HOLD button was clicked show the next scene with one of the
% dealer's card face down

while(playerPlaying)
    % get where the mouse was clicked
    [r, c, b] = getMouseInput(card_scene);

    if r == 6 && (c == 5 || c == 6 )

        while ~pulledNewCard
            card_val_dealer = randi(13, 1, 1);
            card_suit_dealer = randi(4, 1, 1) - 1;
            card_sprite_dealer = skip_sprites + 13 * card_suit_dealer + card_val_dealer;

            pulledNewCard = false;

            for i = 1: length(cardsPlayed)
                if cardsPlayed(i) == card_sprite_dealer
                    pulledNewCard = true;
                end
            end
        end

        dealerCards(dealerCardIndex) = card_sprite_dealer;
        dealerCardIndex = dealerCardIndex + 1;
        
        updateScreen(dealerCards,playerCards);
        drawScene(card_scene, [dealerCards; ...
        dealerValRow; ...
        1, 1, 1, 1, 1, 1, 1; ...
        playerValRow; ...
        playerCards; ...
        1, 75, 76, 1, 77, 78, 1]);

        playerPlaying = false;
    elseif r == 6 && (c == 2 || c == 3)
        pulledNewCard = false;
        
        while ~pulledNewCard
            card_val = randi(13, 1, 1);
            card_suit = randi(4, 1, 1) - 1;
            card_sprite = skip_sprites + 13 * card_suit + card_val;

            pulledNewCard = true;

            for i = 1: length(cardsPlayed)
                if cardsPlayed(i) == card_sprite
                    pulledNewCard = false;
                end
            end
        end

        playerCards(playerCardIndex) = card_sprite;
        playerCardIndex = playerCardIndex + 1;

        updateScreen(dealerCards,playerCards);
        drawScene(card_scene, [card_sprite_dealer, 3, 1, 1, 1, 1, 1; ...
        dealerValRow; ...
        1, 1, 1, 1, 1, 1, 1; ...
        playerValRow; ...
        playerCards; ...
        1, 75, 76, 1, 77, 78, 1]);
    end
end