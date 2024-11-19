function handValue = getHandValue(hand)
handValue = 0;
cardValues = [0 0 1  10 8  5  2  10 0 0
              0 0 2  10 9  6  3  10 0 0
              0 0 3  10 10 7  4  0  0 0
              0 0 4  1  10 8  5  0  0 0
              0 0 5  2  10 9  6  0  0 0
              0 0 6  3  10 10 7  0  0 0 
              0 0 7  4  1  10 8  0  0 0
              0 0 8  5  2  10 9  0  0 0
              0 0 9  6  3  10 10 0  0 0
              0 0 10 7  4  1  10 0  0 0];
% The above matrix represents the values of cards in the sprite-sheet in a manner accessible by
% linear indexing. This simplifies the logic for the rest of the function.

for i = 1:width(hand)
    if cardValues(hand(i)) == 1 % ace logic
        handValue = [handValue+1, handValue+11];
    else
    handValue = handValue + cardValues(hand(i));
    end
end

% To add: tie this code in with the main script to report busts/blackjacks
% if handValue = 21
%   the player with this hand wins
% end
% 
% if handValue > 21
%   the player with this hand loses
% end
%

% takahashi 24/11/18


