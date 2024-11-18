function handValue = getHandValue(hand)
handValue = 0;
cardValues = [0 0 1  10 8  5  2  10 0 0
              0 0 2  10 9  6  3  10 0 0
              0 0 3  10 10 7  4  0  0 0
              0 0 4  1  10 8  5  0  0 0
              0 0 5  2  10 9  6  0  0 0
              0 0 6  3  10 1  7  0  0 0 
              0 0 7  4  1  10 8  0  0 0
              0 0 8  5  2  10 9  0  0 0
              0 0 9  6  3  10 10 0  0 0
              0 0 10 7  4  1  10 0  0 0];
% The above matrix represents the values of cards in the sprite-sheet in a manner accessible by
% linear indexing. This simplifies the logic for the rest of the function.

for i = 1:width(hand)
    fprintf('The card id is %.0f', hand(i)) %debug message only
    if cardValues(hand(i)) == 1 % ace logic
        handValue = [handValue+1, handValue+10]
    else
    handValue = handValue + cardValues(hand(i))
    end
end

% takahashi 24/11/18


