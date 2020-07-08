# Chaoshead
A scripting interface/level editor/reverse engineering tool for Levelhead levels/stages, made using [Löve2d](http://www.love2d.org).

## Useful links
WIP file specification:<br>
https://docs.google.com/document/d/1_Nt0u3DpgLA2KHgwVdcCnMYaY6nGjZcjbRyx1hHp9rA/<br>
Overview of data (item ID's, music ID's):<br>
https://docs.google.com/spreadsheets/d/1bzASSn2FgjqUldPzX8DS66Lv-r2lk3V12jZjl51uaTk/<br>

## Terminology
- World: the part of a level that contains all the level (world = level - metadata).
- Object: a single thing inside the level.
- (Level) element: a type of object e.g. Blasters, Armor Plates.
- Item: Something GR-18 can grab and carry.
- Mapping vs. Value (in the context of properties): a value is the raw number saved in the file, a mappnig is what that number means. E.g. value 1 for rotation is mapped to/mappnig "Up".
