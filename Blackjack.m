clc
clear

% make the scenes using simpleGameEngine
background = [53, 101, 77];

card_scene = simpleGameEngine('images/retro_cards.png', 16, 16, 8, background);

skip_sprites = 20;

% create 2 random card sprites on the player's side
card_vals = randi(13, 1, 2);
card_suits = randi(4, 1, 2) - 1;
card_sprites = skip_sprites + 13 * card_suits + card_vals;

% create 1 random card sprite on the dealer's side
card_val_dealer = randi(13, 1, 1);
card_suit_dealer = randi(4, 1, 1) - 1;
card_sprite_dealer = skip_sprites + 13 * card_suit_dealer + card_val_dealer;

% create 2 random card sprite on the dealer's side
card_val_dealer = randi(13, 1, 2);
card_suit_dealer = randi(4, 1, 2) - 1;
card_sprites_dealer = skip_sprites + 13 * card_suit_dealer + card_val_dealer;
card_sprites_dealer(2) = card_sprite_dealer;

% draw the first scene
drawScene(card_scene, [3, card_sprite_dealer, 1, 1, 1, 1, 1; ...
    1, 1, 1, 1, 1, 1, 1; ...
    1, 1, 1, 1, 1, 1, 1; ...
    card_sprites, 1, 1, 1, 1, 1; ...
    1, 75, 76, 1, 77, 78, 1]);

% get where the mouse was clicked
[r, c, b] = getMouseInput(card_scene);

% if the HIT button was clicked show the next scene with both of the
% dealer's cards face up
% if the HOLD button was clicked show the next scene with one of the
% dealer's card face down
if r == 5 && (c == 5 || c == 6 )
    drawScene(card_scene, [3, card_sprite_dealer, 1, 1, 1, 1, 1; ...
    1, 1, 1, 1, 1, 1, 1; ...
    1, 1, 1, 1, 1, 1, 1; ...
    card_sprites, 1, 1, 1, 1, 1; ...
    1, 75, 76, 1, 77, 78, 1]);
elseif r == 5 && (c == 2 || c == 3)
    drawScene(card_scene, [card_sprites_dealer, 1, 1, 1, 1, 1; ...
    1, 1, 1, 1, 1, 1, 1; ...
    1, 1, 1, 1, 1, 1, 1; ...
    card_sprites, 1, 1, 1, 1, 1; ...
    1, 75, 76, 1, 77, 78, 1]);
end