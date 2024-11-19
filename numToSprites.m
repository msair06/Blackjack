function spriteArray = numToSprites(num)
numArray = num2str(num) - '0'; % Split the number into an array of numbers
spriteArray = zeros(1, width(numArray)); %preallocate array for speed
numberSprites = [11, 12, 13, 14, 15, 16, 17, 18, 19, 20]; % each index corresponds to the proper numeral sprite on the sprite sheet.
for i = 1:width(numArray)
    spriteArray(i) = numberSprites(numArray(i)+1);
end
end

% takahashi 24/11/18