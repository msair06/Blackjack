clc
clear

global dealerValRow playerValRow

% make the scenes using simpleGameEngine
background = [53, 101, 77];

card_scene = simpleGameEngine('images/pixil-frame-0.png', 16, 16, 8, background);

skip_sprites = 20;

% =============== START PAGE ===================

startPageArray = [
    1, 1, 1, 1, 1, 1, 1;
    1, 5, 6, 7, 8, 9, 1;
    1, 10, 7, 8, 9, 1, 1;
    1, 1, 1, 1, 1, 1, 1;
    1, 1, 98, 99, 100, 1, 1;
    1, 1, 1, 1, 1, 1, 1];

drawScene(card_scene, startPageArray);
drawScene(card_scene, startPageArray);

gameStart = false;
while ~gameStart
    [r, c, b] = getMouseInput(card_scene);
    if r == 5 && (c == 3 || c == 4 || c == 5)
        gameStart = true;
        close all;
    end
end

% =============== BETTING PAGE ===================

current_amount = BettingPage(card_scene);

% =============== GAME START ===================

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

restartButtonSprite = 93;

updateScreen(dealerCards,playerCards);

% draw the first scene
drawScene(card_scene, [card_sprite_dealer, 3, 1, 1, 1, 1, 1; ...
    dealerValRow; ...
    1, 1, 1, 1, 1, 1, restartButtonSprite; ...
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
    if r == 3 && c == 7 % Restart button is clicked
        close all;
        clc;
        run('Blackjack.m');
        break;
    end

    if r == 6 && (c == 5 || c == 6 )
        pulledNewCard = false;

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

        % Determine WhoWon
        if getHandValue(dealerCards) > getHandValue(playerCards)
            win = false;
        elseif getHandValue(dealerCards) == getHandValue(playerCards)
            win = 3;
        else
            win = true;
        end %it all

        updateScreen(dealerCards,playerCards);
        drawScene(card_scene, [dealerCards; ...
            dealerValRow; ...
            1, 1, 1, 1, 1, 1, restartButtonSprite; ...
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

        % determine whether the player busted or got a blackjack
        if getHandValue(playerCards) > 21
            playerPlaying = false;
            win = false;
        elseif getHandValue(playerCards) == 21
            playerPlaying = false;
            win = true;
        end

        drawScene(card_scene, [card_sprite_dealer, 3, 1, 1, 1, 1, 1; ...
            dealerValRow; ...
            1, 1, 1, 1, 1, 1, restartButtonSprite; ...
            playerValRow; ...
            playerCards; ...
            1, 75, 76, 1, 77, 78, 1]);

        % We Need A Restart Button On The Screen
        % Clicking The Button Restarts The Game And PlayerPlaying Will Be
        % Equal To Zero

    end
end

if ~playerPlaying
    winnerSprite = 92;
    loserSprite = 94;
    dollarSprite = 88;
    numberSprites = [91, 12:20];

    final_amount = determinePayout(playerCards, dealerCards, current_amount);

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

    pause(2.0);

    finalAmountSprites = ones(1, 7);
    finalAmountSprites(1) = dollarSprite;
    amountStr = sprintf('%d', final_amount);
    for i = 1:length(amountStr)
        finalAmountSprites(i + 1) = numberSprites(str2double(amountStr(i)) + 1);
    end
    if length(amountStr) < 6
        finalAmountSprites(length(amountStr) + 2:end) = 1;
    end

    % ================= FINAL PAGE =====================

    if (getHandValue(playerCards) > 21)
        finalPageArray = [
            1, 1, 1, 1, 1, 1, 1;
            1, 1, loserSprite, loserSprite, loserSprite, 1, 1;
            finalAmountSprites;  
            1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, restartButtonSprite, 1, 1;
            1, 1, 1, 1, 1, 1, 1;
            ];
    elseif (getHandValue(dealerCards) > 21)
        finalPageArray = [
            1, 1, 1, 1, 1, 1, 1;
            1, 1, winnerSprite, winnerSprite, winnerSprite, 1, 1;
            finalAmountSprites;  
            1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, restartButtonSprite, 1, 1;
            1, 1, 1, 1, 1, 1, 1;
            ];
    elseif (getHandValue(playerCards) == getHandValue(dealerCards))
        finalPageArray = [
            1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 73, 74, 1, 1;
            finalAmountSprites;  
            1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, restartButtonSprite, 1, 1;
            1, 1, 1, 1, 1, 1, 1;
            ];
    elseif (getHandValue(playerCards) > getHandValue(dealerCards))
        finalPageArray = [
            1, 1, 1, 1, 1, 1, 1;
            1, 1, winnerSprite, winnerSprite, winnerSprite, 1, 1;
            finalAmountSprites;  
            1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, restartButtonSprite, 1, 1;
            1, 1, 1, 1, 1, 1, 1;
            ];
    else
        finalPageArray = [
            1, 1, 1, 1, 1, 1, 1;
            1, 1, loserSprite, loserSprite, loserSprite, 1, 1;
            finalAmountSprites;  
            1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, restartButtonSprite, 1, 1;
            1, 1, 1, 1, 1, 1, 1;
            ];
    end

    drawScene(card_scene, finalPageArray);  
    restart = false;
    restartButtonRow = 5;
    restartButtonCol = 5;
    while ~restart
        [r, c, b] = getMouseInput(card_scene);
        if r == restartButtonRow && c == restartButtonCol
            close all;
            clc;
            run('Blackjack.m');
            restart = true;
        end
    end
end