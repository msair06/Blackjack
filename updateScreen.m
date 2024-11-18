function updateScreen(dealerCards, playerCards)
global dealerValRow playerValRow
% create a row that contains the value of the dealer's cards
dealerHandValue = getHandValue(dealerCards)
dealerValRow = ones(1,7);
if width(dealerHandValue) ~= 2
    dealerValRow(1:length(numToSprites(dealerHandValue))) = numToSprites(dealerHandValue);
else
    dealerValRow(1:1+length(numToSprites(dealerHandValue(1)))+length(numToSprites(dealerHandValue(2))))= [numToSprites(playerHandValue(1)),1,numToSprites(playerHandValue(2))]
end
%create a row that contains the value of the player's cards
playerValRow = ones(1,7);
playerHandValue = getHandValue(playerCards)

if width(playerHandValue) ~= 2
    playerValRow(1:length(numToSprites(playerHandValue))) = numToSprites(playerHandValue);
else
    playerValRow(1:1+length(numToSprites(playerHandValue(1)))+length(numToSprites(playerHandValue(2))))= [numToSprites(playerHandValue(1)),1,numToSprites(playerHandValue(2))]
end
end


% takahashi 24/11/18