clc
clear

% make the scenes using simpleGameEngine
card_scene1 = simpleGameEngine('retro_images/retro_cards.png', 16, 16, 8, [255, 255, 255]);
card_scene2 = simpleGameEngine('retro_images/retro_cards.png', 16, 16, 8, [255, 255, 255]);
card_scene3 = simpleGameEngine('retro_images/retro_cards.png', 16, 16, 8, [255, 255, 255]);
button_scene = simpleGameEngine('retro_images/hit_hold.png', 9, 20, 8, [255, 255, 255]);

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
card_vals_dealer = randi(13, 1, 2);
card_suits_dealer = randi(4, 1, 2) - 1;
card_sprites_dealer = skip_sprites + 13 * card_suits_dealer + card_vals_dealer;

% draw the first scene
drawScene(card_scene1, [3, card_sprite_dealer; 1, 1; card_sprites]);
title("This is the dealer's hand with one of the cards being flipped", "FontSize", 16);
xlabel("This is your hand", "FontSize", 16);

% wait for mouse input to display the next scene
getMouseInput(card_scene1);

% display the next scene with buttons
% wait for mouse clicks to show next pieces of text
drawScene(button_scene, [1; 2]);
xlabel("These are the two buttons (Don't click the buttons yet)", "FontSize", 16);
getMouseInput(button_scene);
xlabel("They are used to determine how the next scene is going to look like (Don't click the buttons yet)", "FontSize", 16);
getMouseInput(button_scene);
xlabel("Click a button to see how the next outcome could look like", "FontSize", 16);

% get where the mouse was clicked
[r, c, b] = getMouseInput(button_scene);

% if the HIT button was clicked show the next scene with both of the
% dealer's cards face up
% if the HOLD button was clicked show the next scene with one of the
% dealer's card face down
if r == 1
    drawScene(card_scene2, [card_sprites_dealer; 1, 1; card_sprites]);
    xlabel("This is how next scene could look like when the HIT button is pressed", "FontSize", 16);
elseif r == 2
    drawScene(card_scene3, [3, card_sprite_dealer; 1, 1; card_sprites]);
    xlabel("This is how next scene could look like when the HOLD button is pressed", "FontSize", 16);
end