function final_amount = determinePayout(playerCards, dealerCards, current_amount)

% Get the points for the player and the dealer
playerHandValue = getHandValue(playerCards);
dealerHandValue = getHandValue(dealerCards);

% Check if it's a Natural Blackjack
playerBlackjack = (playerHandValue == 21 && length(playerCards) == 2 && ...
    any(mod(playerCards - 1, 13) == 0) && ...
    any(mod(playerCards - 1, 13) >= 9));
dealerBlackjack = (dealerHandValue == 21 && length(dealerCards) == 2 && ...
    any(mod(dealerCards - 1, 13) == 0) && ...
    any(mod(dealerCards - 1, 13) >= 9));

% Calculate the final amount
if playerBlackjack && ~dealerBlackjack
    % Player wins with Blackjack, 3:2 payout
    final_amount = current_amount * 2.5;
elseif playerHandValue > 21
    % Player busts
    final_amount = 0;
elseif dealerHandValue > 21
    % Dealer busts
    final_amount = current_amount * 2;
elseif playerHandValue > dealerHandValue
    % Player has a higher score than the dealer
    final_amount = current_amount * 2;
elseif playerHandValue < dealerHandValue
    % Dealer has a higher score than the player
    final_amount = 0;
else
    % Tie
    final_amount = current_amount;
end
end

